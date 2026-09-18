# Ad-hoc verification note: configurable CORS

Session pattern:
- Verified a backend CORS hardening change by exercising preflight requests instead of only relying on build output.
- Confirmed `Cors:AllowedOrigins` can be set through configuration/environment and that `http://localhost:4200` remains the dev/testing fallback.
- Used a focused temp script under `/tmp/hermes-verify-*.sh` to run:
  - `dotnet build SaasConsultaOnlineBackend.sln`
  - `dotnet test SaasConsultaOnlineBackend.sln --no-build --filter FullyQualifiedName~CorsConfigurationTests`

What to remember:
- For config-driven behavior, write or reuse a regression test that asserts the runtime header/status behavior, not just service registration.
- Prefer a narrow filter when the change is isolated, and report the result as targeted/ad-hoc verification unless the whole suite was actually run.
- If the repo has recursive test-output symptoms, run from the test project directory and clean inside the script before trying path overrides.
