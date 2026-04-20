# Gorda Docker Stack

Local Docker now runs explicit services instead of the legacy `gorda` toolbox container.

## Services

- `admin`: Vue build watcher that keeps `admin/dist` updated
- `api`: Node/Express + Socket.IO on `http://localhost:3000`
- `functions`: TypeScript watch/build sidecar for Firebase Functions
- `emulators`: Firebase emulators UI and runtime, including Hosting serving the SPA on `http://localhost:5005`
- `postgres`: PostgreSQL/PostGIS on `localhost:5432`
- `redis`: Redis on `localhost:6379`
- `ia`: AI service on `http://localhost:8000`

## Common Commands

```bash
cd dock
docker compose config
docker compose up -d --build postgres redis ia api functions emulators admin
docker compose logs -f api
docker compose exec admin sh -lc "npm run lint"
docker compose exec api sh -lc "npm run build"
docker compose exec functions sh -lc "npm run lint"
docker compose down
```

## Notes

- Firebase emulators now use `admin/firebase.json` and `admin/dataEmulators`.
- The local SPA at `http://localhost:5005` is served by Firebase Hosting Emulator from `admin/dist`.
- The `admin` service only rebuilds the SPA in watch mode and no longer exposes an HTTP port.
- Firestore is exposed locally on `localhost:8080`; host-based `api` runs should set `FIRESTORE_EMULATOR_HOST=localhost:8080`.
- Functions runtime execution stays inside the `emulators` service; the `functions` service only keeps `lib/` updated.
- The local stack keeps RTDB/Auth/Firestore/Storage emulation for operational flows and migration backfills, plus PostgreSQL for migrated datasets.
