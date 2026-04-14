# Gorda Docker Stack

Local Docker now runs explicit services instead of the legacy `gorda` toolbox container.

## Services

- `admin`: Vue dev server on `http://localhost:5005`
- `api`: Node/Express + Socket.IO on `http://localhost:3000`
- `functions`: TypeScript watch/build sidecar for Firebase Functions
- `emulators`: Firebase emulators UI and runtime
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
- Firestore is exposed locally on `localhost:8080`; host-based `api` runs should set `FIRESTORE_EMULATOR_HOST=localhost:8080`.
- Functions runtime execution stays inside the `emulators` service; the `functions` service only keeps `lib/` updated.
- The local stack keeps RTDB/Auth/Firestore/Storage emulation for operational flows and migration backfills, plus PostgreSQL for migrated datasets.
