# Angular dev API proxy + smoke note

## When to use
Use this note when an Angular frontend should talk to a local backend during development/QA and the frontend already builds cleanly, but browser smoke still needs the right API base URL.

## Pattern used successfully
- Keep the dev environment URL relative in `src/environments/environment.ts` (for example `'/api'`).
- Add an Angular dev-server proxy file, e.g. `proxy.conf.json`, that maps `/api` to the validated backend origin.
- Wire the proxy into `angular.json` under the `serve` target via `proxyConfig`.
- Keep `environment.prod.ts` aligned with the same relative API base when the deployment origin is expected to serve the backend path.

## Validation steps
1. Run the frontend build and confirm it still passes.
2. Start the dev server with the proxy in place.
3. Open the app in the browser and submit a login.
4. Inspect `performance.getEntriesByType('resource')` to confirm the request target actually includes the validated backend origin.

## Troubleshooting cue
If the browser request already goes to the correct backend origin but the UI still shows a login failure, treat it as a frontend/auth-flow issue rather than an API-host mismatch.

## Example evidence collected in this session
- Backend login endpoint responded `200 OK` on `http://127.0.0.1:5053/api/auth/login`.
- Browser resource timing showed the login request hitting `http://127.0.0.1:5053/api/auth/login`.
- Frontend build remained green after the proxy alignment.
