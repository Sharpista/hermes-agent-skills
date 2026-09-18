# SQLite In-Memory + WebApplicationFactory for ASP.NET Core Integration Tests

## SQLite In-Memory Connection Lifetime

SQLite `:memory:` databases are **per-connection**. When the connection closes, the data vanishes. EF Core's `UseSqlite("DataSource=:memory:")` opens a connection internally, but each DbContext instance may get a different connection, losing data between operations.

**Fix**: Create one `SqliteConnection` explicitly, call `Open()` on it, and pass that open connection to `UseSqlite(connection)`. All DbContext instances sharing that connection see the same in-memory database. Dispose the connection when the test/factory is disposed.

```csharp
var connection = new SqliteConnection("DataSource=:memory:");
connection.Open();

var options = new DbContextOptionsBuilder<AppDbContext>()
    .UseSqlite(connection)
    .Options;
```

## WebApplicationFactory + Custom DbContext

When replacing the production DbContext in integration tests, remove ALL existing registrations first, then add the test one:

```csharp
services.RemoveAll<DbContextOptions<AppDbContext>>();
services.AddDbContext<AppDbContext>(opts => opts.UseSqlite(_connection));
```

`RemoveAll<DbContextOptions<T>>` is critical — without it, the production registration wins and tests hit the real database.

## Schema Creation in Testing Environment

`Program.cs` often gates `db.Database.Migrate()` behind `if (app.Environment.IsDevelopment())`. Integration tests typically set environment to "Testing", so Migrate never runs → "no such table" error at first DB operation.

**Fix**: Call `EnsureCreated()` or `Migrate()` after building the factory:

```csharp
using var scope = factory.Services.CreateScope();
var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
db.Database.EnsureCreated();
```

`EnsureCreated()` is faster than `Migrate()` for tests (no migration history table). Use `Migrate()` only if the test depends on migration-specific schema.

## FakeTimeProvider for Deterministic Time

`Microsoft.Extensions.TimeProvider.Testing` provides `FakeTimeProvider` — inject it in place of `TimeProvider.System` to control `GetUtcNow()`:

```csharp
services.RemoveAll<TimeProvider>();
services.AddSingleton<TimeProvider>(new FakeTimeProvider(
    new DateTimeOffset(2026, 1, 1, 0, 0, 0, TimeSpan.Zero)));
```

Freezing time at a known point makes "future date" / "past date" validation logic deterministic — no flaky tests depending on wall clock.

## WebApplicationFactory<Program> Requirement

The API project's `Program.cs` MUST expose a public partial class for WebApplicationFactory to reference:

```csharp
public partial class Program { }
```

Without this, `WebApplicationFactory<Program>` can't find the entry point and compilation fails.
