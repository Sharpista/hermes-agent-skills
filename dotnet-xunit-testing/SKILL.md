---
name: dotnet-xunit-testing
description: "Scaffold .NET xUnit test projects for ASP.NET Core: unit tests for services, integration tests for controllers via WebApplicationFactory, SQLite in-memory, FakeTimeProvider."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [dotnet, xunit, testing, aspnet-core, ef-core, integration-tests, unit-tests]
    related_skills: [test-driven-development, orquestrador-de-tarefas]
---

# .NET xUnit Test Project Scaffolding

## When to Use

When adding automated tests to an existing ASP.NET Core (.NET 8 / EF Core) backend:
- Unit tests for service classes that use EF Core + TimeProvider
- Integration tests for API controllers via HTTP (WebApplicationFactory)
- Any .NET backend needing deterministic, isolated test infrastructure

## Overview

This skill covers the mechanics of scaffolding, wiring, and running xUnit tests against an existing ASP.NET Core backend — not TDD methodology (see `test-driven-development` for that). It assumes the production project already exists and compiles; you are ADDING tests, not creating a new project.

## Project Scaffolding

### 1. Create the test project

```bash
# Sibling directory to the main project, not nested inside it
dotnet new xunit -n MyProject.Tests -o tests
```

### 2. Add reference to the production project

Edit the `.csproj`:

```xml
<ItemGroup>
  <ProjectReference Include="../MyProject/MyProject.csproj" />
</ItemGroup>
```

### 3. Required NuGet packages

```xml
<ItemGroup>
  <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.11.1" />
  <PackageReference Include="xunit" Version="2.9.2" />
  <PackageReference Include="xunit.runner.visualstudio" Version="2.8.2">
    <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
    <PrivateAssets>all</PrivateAssets>
  </PackageReference>
  <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.11" />
  <PackageReference Include="Microsoft.EntityFrameworkCore.Sqlite" Version="8.0.11" />
  <PackageReference Include="Microsoft.Extensions.TimeProvider.Testing" Version="8.1.0" />
</ItemGroup>
```

### 4. Production project requirement

`Program.cs` MUST expose a public partial class for `WebApplicationFactory<Program>`:

```csharp
public partial class Program { }
```

## Unit Tests for Service Classes

### Pattern

Each test class creates its own SQLite in-memory DB + FakeTimeProvider. This isolates tests — no shared state, no wall-clock dependency.

```csharp
public sealed class MyServiceTests : IDisposable
{
    private readonly SqliteConnection _connection;
    private readonly AppDbContext _context;
    private readonly FakeTimeProvider _fakeTime;
    private readonly MyService _sut;

    public MyServiceTests()
    {
        _connection = new SqliteConnection("DataSource=:memory:");
        _connection.Open();  // MUST open before passing to DbContext

        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseSqlite(_connection)
            .Options;

        _context = new AppDbContext(options);
        _context.Database.EnsureCreated();

        _fakeTime = new FakeTimeProvider(new DateTimeOffset(2026, 1, 1, 0, 0, 0, TimeSpan.Zero));
        _sut = new MyService(_context, _fakeTime);
    }

    public void Dispose()
    {
        _context.Dispose();
        _connection.Dispose();  // Closing connection destroys the in-memory DB
    }
}
```

### Key points

- `SqliteConnection` must be explicitly opened and kept alive for the test duration. SQLite `:memory:` is per-connection — closing it destroys all data.
- `EnsureCreated()` creates the schema from the EF Core model (no migrations needed). Faster than `Migrate()`.
- `FakeTimeProvider` frozen at a known date makes "future date" / "past date" validation deterministic.
- `IDisposable` ensures each test gets a fresh DB.

## Integration Tests for Controllers

### Pattern: CustomWebApplicationFactory

```csharp
public sealed class MyControllerIntegrationTests
{
    private static WebApplicationFactory<Program> CreateFactory()
    {
        var connection = new SqliteConnection("DataSource=:memory:");
        connection.Open();

        var factory = new CustomWebApplicationFactory(connection);
        factory.Disposing += _ => connection.Dispose();

        // Create schema — Program.cs may gate Migrate behind Development env
        using var scope = factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        db.Database.EnsureCreated();

        return factory;
    }

    private sealed class CustomWebApplicationFactory : WebApplicationFactory<Program>
    {
        private readonly SqliteConnection _connection;
        public Action<CustomWebApplicationFactory>? Disposing { get; set; }

        public CustomWebApplicationFactory(SqliteConnection connection) => _connection = connection;

        protected override void ConfigureWebHost(IWebHostBuilder builder)
        {
            builder.UseEnvironment("Testing");
            builder.ConfigureServices(services =>
            {
                // Remove production DbContext registration
                services.RemoveAll<DbContextOptions<AppDbContext>>();
                services.AddDbContext<AppDbContext>(opts => opts.UseSqlite(_connection));

                // Replace TimeProvider with FakeTimeProvider
                services.RemoveAll<TimeProvider>();
                services.AddSingleton<TimeProvider>(new FakeTimeProvider(
                    new DateTimeOffset(2026, 1, 1, 0, 0, 0, TimeSpan.Zero)));
            });
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing) Disposing?.Invoke(this);
            base.Dispose(disposing);
        }
    }
}
```

### Key points

- `RemoveAll<DbContextOptions<T>>` is critical — without it, the production registration wins and tests hit the real database.
- `RemoveAll<TimeProvider>()` replaces the production singleton.
- `EnsureCreated()` after factory construction — `Program.cs` often gates `Migrate()` behind `IsDevelopment()`, so Testing environment never runs migrations.
- Use `await using var factory = CreateFactory();` to ensure disposal.

### HTTP test pattern

```csharp
[Fact]
public async Task Post_ValidPayload_Returns201Created()
{
    await using var factory = CreateFactory();
    var client = factory.CreateClient();

    var payload = new { name = "Test", date = "2026-06-15" };
    var response = await client.PostAsJsonAsync("/api/resource", payload);

    Assert.Equal(HttpStatusCode.Created, response.StatusCode);
    var body = await response.Content.ReadFromJsonAsync<ResourceDto>();
    Assert.NotNull(body);
}
```

## Running Tests

```bash
cd path/to/tests
dotnet test                          # run all
dotnet test --verbosity normal       # see each test name
dotnet test --filter "Category=Unit" # filter by trait/category
```

## Verification

After writing tests, always run `dotnet build` then `dotnet test` in sequence to confirm 0 errors + 0 failures.

### Ad-hoc verification script pattern

When the system requires explicit verification evidence (e.g., after editing tests), create a temporary verification script under `/tmp` with a `hermes-verify-*` prefix:

```bash
#!/bin/bash
set -e
cd /path/to/tests
OUTPUT=$(dotnet test --verbosity normal 2>&1)
TOTAL=$(echo "$OUTPUT" | grep -oP "Total tests: \K\d+")
PASSED=$(echo "$OUTPUT" | grep -oP "Passed: \K\d+")
echo "Total: $TOTAL, Passed: $PASSED"
[ "$TOTAL" = "$PASSED" ] && echo "✅ VERIFICATION PASSED" || exit 1
```

Run it, then delete it: `rm /tmp/hermes-verify-*.sh`.

For deeper details on SQLite in-memory connection lifetime, WebApplicationFactory schema creation, and FakeTimeProvider setup, see `references/sqlite-in-memory-and-webfactory.md`.
For JWT-backed API tests and login/token setup, see `references/jwt-protected-api-tests.md`.

## Pitfalls

### 1. Missing `using Xunit;`

xUnit's `[Fact]` and `Assert` are NOT in the global namespace by default. Even with `ImplicitUsings` enabled, you need an explicit `using Xunit;` at the top of every test file. Without it, you get ~20+ `CS0246: type 'Fact' not found` errors.

### 2. Package version mismatches

`Microsoft.Extensions.TimeProvider.Testing` does NOT exist in 8.0.11 (the EF Core version). The lowest available version for .NET 8 is 8.1.0. If `dotnet restore` warns `NU1603: depends on X but X was not found, approximate best match of Y resolved`, change the version to Y — the best-match resolution usually works.

### 3. "no such table" in integration tests

If `Program.cs` gates `db.Database.Migrate()` behind `if (app.Environment.IsDevelopment())`, setting environment to "Testing" skips migration → "no such table" SqliteException at first DB write.

Fix: call `db.Database.EnsureCreated()` after factory construction (see integration test pattern above).

**Related layout pitfall:** if the test project lives under the repository root and the main project is built from the same solution, nested `bin/obj` copy noise can appear in `dotnet test` output. Prefer a clean sibling test folder layout and avoid letting the production project glob test source files.

### 4. SQLite in-memory connection closes prematurely

If you pass a connection string (`"DataSource=:memory:"`) directly to `UseSqlite()`, EF Core creates and disposes a connection per DbContext operation — data vanishes between calls. Always create `SqliteConnection` explicitly, `Open()` it, and pass the connection object (not the string) to `UseSqlite(connection)`.

### 5. Controller method name mismatch

Before writing tests, READ the controller and service interface to discover actual method names. The task description may say "CriarAsync" but the code uses "CadastrarAsync". Same for endpoint routes — verify the actual `[Route]` attribute casing.

### 6. DELETE = Cancel (soft delete)

Many APIs implement DELETE as a status change (e.g., `Status = Cancelada`) not a row deletion. The second DELETE on an already-cancelled resource returns 409 Conflict, not 404. Test accordingly.

### 7. Integration test coverage gaps — test every error status code

A common pattern is to test the happy path + one or two error cases per endpoint, but miss the full matrix of error status codes the controller can return. The controller's `catch` blocks define the contract — each caught exception type maps to a specific HTTP status. **Every status code the controller can return should have at least one integration test.**

**Systematic approach:** For each endpoint, read the controller method and list every `catch` block + early return. Each one is a test case:

```
POST   /api/resource       → 201 (happy), 400 (validation), [other catches]
GET    /api/resource       → 200 (happy, empty + non-empty)
GET    /api/resource/{id}  → 200 (found), 404 (not found)
PUT    /api/resource/{id}  → 200 (happy), 404 (not found), 400 (validation)
DELETE /api/resource/{id}  → 204 (happy), 404 (not found), 409 (conflict)
```

**Observed gap pattern:** POST gets 201 + 400, GET gets 200 + 404, but PUT and DELETE only get happy path tests — their 404 (KeyNotFoundException) and 409 (InvalidOperationException) paths are untested in integration tests even though the controller handles them.

**Fix:** Add an integration test for each missing error path:

```csharp
[Fact]
public async Task Put_IdInexistente_Retorna404NotFound()
{
    await using var factory = CreateFactory();
    var client = factory.CreateClient();
    var update = new { pacienteNome = "X", psicologoNome = "Y", data = "2026-06-15", hora = "10:00" };
    var response = await client.PutAsJsonAsync($"/api/resource/{Guid.NewGuid()}", update);
    Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
}

[Fact]
public async Task Delete_IdInexistente_Retorna404NotFound()
{
    await using var factory = CreateFactory();
    var client = factory.CreateClient();
    var response = await client.DeleteAsync($"/api/resource/{Guid.NewGuid()}");
    Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
}
```

### 8. Unit test validation gaps for Update methods

Service methods often have `ValidateUpdate` with the same validation logic as `ValidateCreate`, but only `ValidateCreate` gets unit-tested. If `ValidateUpdate` has its own copy of validation logic (even if identical), it needs its own tests — otherwise a refactor that changes one but not the other will pass all tests.

**Check:** Does the service have separate `ValidateCreate` and `ValidateUpdate` methods (or inline validation in `AtualizarAsync`)? If so, each validation branch (empty fields, past date, invalid format) needs a test for BOTH create and update paths.

**Also check:** `ParseDataHora` format validation (`TryParseExact` for `yyyy-MM-dd` and `HH:mm`) — unit tests often cover "empty field" but miss "wrong format" (e.g., `"15/03/2026"` instead of `"2026-03-15"`). Add tests for invalid format strings.

### 9. TimeSpan format pitfall — `hh\:mm` vs `HH\:mm`

When parsing time strings with `TimeSpan.TryParseExact`, the format specifier matters:
- `hh\:mm` expects 12-hour format (01–12) — may reject valid 24-hour times like "14:00" depending on culture
- `HH\:mm` expects 24-hour format (00–23) — correct for most API scenarios

**Observed issue:** Backend using `@"hh\:mm"` rejected or inconsistently parsed afternoon times. Fix: use `@"HH\:mm"` for 24-hour consistency.

```csharp
// Bad: 12-hour format (culture-dependent)
if (!TimeSpan.TryParseExact(hora, @"hh\:mm", null, out var timePart))

// Good: 24-hour format (culture-invariant)
if (!TimeSpan.TryParseExact(hora, @"HH\:mm", null, out var timePart))
```

### 10. Frontend-backend validation consistency

When frontend uses Angular Reactive Forms validators (e.g., `Validators.minLength(3)`), ensure the backend DTOs have matching constraints:

```csharp
// Frontend: Validators.minLength(3)
// Backend must match:
[MinLength(3)]  // Add this if frontend has it
[StringLength(200, MinimumLength = 3)]  // Or combine with max
```

**Observed gap:** Frontend rejected names < 3 characters, but backend accepted them → inconsistent UX.

**Also:** If frontend displays backend error messages, ensure the service propagates `err.error.detail` from HTTP 400 responses rather than showing generic "Erro ao criar consulta" messages.
