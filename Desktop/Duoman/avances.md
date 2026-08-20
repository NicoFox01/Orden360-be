# Avances del proyecto DUOMAN

Resumen de lo construido y lo pendiente. Archivo vivo: actualizalo a medida que avanza el proyecto.

## Stack

| Capa | Tecnología |
| --- | --- |
| Frontend | Angular 20 (standalone, Signals, RxJS, Reactive Forms), Tailwind CSS v4, TypeScript estricto |
| Backend | Python 3.12 + FastAPI (async, compatible serverless) |
| Base de datos | Supabase (PostgreSQL, free tier) + Alembic (code-first) |
| Storage | Supabase Storage (bucket privado `resumes` para CVs) |
| Auth | Supabase Auth (proxy vía FastAPI) + JWT verificados por JWKS |
| Deploy | Vercel (frontend + backend serverless) + Vercel Cron |
| Tooling | .venv local (uvicorn), Angular CLI 20, Pillow (conversión de imágenes) |

---

## ✅ Backend (`Duomanbe/`) — COMPLETO

- **Estructura** limpia: `app/{api,core,models,schemas,services,repositories,utils}`, `alembic/`, `tests/`, `scripts/`.
- **Auth admin**:
  - `POST /api/v1/auth/login` — valida contra Supabase Auth y chequea que el usuario tenga rol `admin`.
  - Verificación JWT por **JWKS** (Supabase firma con ES256) con fallback HS256. Seguridad 401/403.
  - `scripts/set_admin_role.py` asigna el rol admin (Supabase no lo expone en UI).
- **Endpoints públicos**:
  - `POST /api/v1/quotations` — cotizaciones con honeypot anti-spam + rate limit (10/min).
  - `POST /api/v1/applications/presign-resume` — firma URL de subida (PDF/DOC/DOCX, máx 5 MB).
  - `POST /api/v1/applications` — postulaciones con CV.
  - `GET /api/v1/health`.
- **Endpoints admin** (`/api/v1/admin/*`, protegidos):
  - `GET /metrics` — KPIs.
  - Listado con filtros/búsqueda + cambio de estado + borrado lógico de cotizaciones y postulaciones (con URL firmada del CV).
  - Empleados: crear / listar / borrado lógico.
- **Cron**: `POST /api/v1/cron/keepalive` protegido con `CRON_SECRET` (Vercel Cron `0 8 * * *` → tabla `cronjobs`).
- **Notificaciones por email (Resend)**: cada cotización real dispara un mail a `NOTIFY_EMAIL_TO` vía `app/services/notifications.py` (httpx → API de Resend). Best-effort: si falla el envío solo loguea warning, nunca rompe el 201. El honeypot retorna antes del insert → spam no notifica. Sin `RESEND_API_KEY`/`NOTIFY_EMAIL_TO` la app funciona igual (sin mails). `reply_to` apunta al mail del cliente para responder directo.
- **Base de datos** (Alembic): enums unificados en español (`quotation_status`, `candidate_status`, `residency_zone`), tablas `quotations`, `applications`, `employees`, `cronjobs`, trigger `set_updated_at`, RLS habilitado.
- **Storage**: bucket privado `resumes` creado vía script idempotente.
- **Tests**: 13 tests pytest pasando (7 originales + 6 de notificaciones con Resend/httpx mockeados) + smoke test E2E de 22 checks.

## ✅ Frontend (`Duomanfe/`) — LANDING PÚBLICA COMPLETA

- **Landing** (ruta `/`) con secciones:
  - `#inicio` — hero oscuro con isologo, titular y CTAs.
  - `#nosotros` — historia, misión, visión y 4 valores.
  - `#servicios` — **3 categorías / 15 servicios**, grilla de tarjetas con imagen + modal "Ver más".
  - `#cotizaciones` — formulario (Reactive Forms) → `POST /quotations`.
  - `#trabaja-con-nosotros` — formulario con **drag & drop de CV**: presign → upload directo al bucket → registro de postulación.
- **Navbar** fija con scroll-spy, menú hamburguesa responsive y **toggle claro/oscuro** (default claro, persistido en localStorage).
- **Footer** con datos de contacto (placeholder) y copyright.
- **Tema**: tokens semánticos (`bg`, `surface`, `ink`, `muted`, `line`) que cambian con `.dark`; marca DUOMAN fija en ambos modos.
- **Imágenes**: 15 JPG de servicios optimizados a **WebP ~1200px** (27–178 KB c/u) en `public/images/servicios/`; isologo → `public/images/logo.png` (con transparencia, sirve en ambos temas).
- **Datos centralizados**: `shared/data/services.ts` (catálogo) y `shared/data/contact.ts` (email `correodeprueba@gmail.com`, tel `11223344`).
- **Tailwind v4 integrado correctamente** vía `.postcssrc.json` (genera utilidades; antes compilaba sin aplicarlas).
- Landing lazy-loaded (chunk ~21 KB) + ruta wildcard a `/`.

## ✅ Backoffice (`/admin`) + Login — Sprint 3 COMPLETO

- **Login oculto** en `/login` (sin botón en el navbar público; se accede directo por URL). Formulario → `POST /api/v1/auth/login`, token persistido en `localStorage` (`duoman-auth-token`) con `AuthService` (signals).
- **Interceptor HTTP** que agrega `Authorization: Bearer <token>` a todas las requests.
- **Guards**: `authGuard` (protege `/admin`, redirige a `/login`) y `guestGuard` (si ya estás logueado, `/login` → `/admin/dashboard`).
- **Layout `/admin`** con sidebar responsive (nav + logout):
  - `/admin/dashboard` — KPIs desde `GET /metrics` (cotizaciones nuevas/en proceso, postulaciones nuevas/en proceso, empleados activos) con skeleton de carga y actualización manual.
  - `/admin/cotizaciones` — tabla con filtro por estado (`status_filter`), buscador, cambio de estado inline (select), modal de detalle con servicios/notas y borrado lógico.
  - `/admin/postulaciones` — tabla con filtro/buscardor, cambio de estado, modal "Ver CV" con URL firmada y borrado lógico.
  - `/admin/empleados` — directorio con buscador, alta (form inline) y borrado lógico.
- Server-route: rutas lazy (`login`, `admin-layout`, `dashboard`, `quotations`, `applications`, `employees`) — cada página su propio chunk.
- **Verificado**: build OK + E2E real (TestClient): login 200 con token JWT, `/metrics`/`/quotations`/`/applications`/`/employees` todos 200 con cotizaciones reales de la DB. Backend tests: 7 passed.

## 🔧 Problemas resueltos (a tener en cuenta)

- **uvloop cuelga en WSL**: uvicorn debe correr con `--loop asyncio`.
- **Tailwind v4 en Angular**: Angular solo lee `.postcssrc.json` (no `postcss.config.js`). Sin eso, el build "compila" pero **no genera ninguna utilidad**.
- **Supabase firma con ES256 (JWKS)**: el "JWT secret" del `.env` es en realidad el `kid`. No usar como secreto HS256.
- **`sign_in_with_password` muta el contexto del cliente Supabase**: usar un cliente de auth dedicado, nunca el de service role sobre tablas.

---

## ❌ PENDIENTE

### Sprint 4 (falta) / Deploy
- [x] Notificaciones por email (Resend) — implementadas para cotizaciones.

### Deploy
- [ ] Subir backend a Vercel y setear env vars (`SUPABASE_*`, `CRON_SECRET`, `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `CORS_ALLOWED_ORIGINS`, `BUCKET_RESUMES`).
- [ ] Subir frontend a Vercel + apuntar `environment.prod.ts` a la URL real de la API.
- [ ] Probar cron + RLS en producción.

### Pulido / contenido real
- [ ] Cambiar datos de contacto placeholder (email y teléfono reales) en `shared/data/contact.ts`.
- [ ] Cambiar email/password del admin de prueba (`cuentas.gonzalez.familia@gmail.com` / en `.env`).
- [ ] Revisar hero oscuro (usuario dijo que lo iba a evaluar).
- [ ] Revisar textos/copy del catálogo de servicios.
- [ ] Al verificar dominio en Resend: cambiar `NOTIFY_FROM_EMAIL` en Vercel (sin cambios de código).

### Mejoras de UX/UI (ideas para ir aplicando, aún no implementadas)
- [ ] **Rediseñar el selector de servicios del formulario de cotización**: reemplazar los checkboxes por categoría por un **dropdown combinable + tags removibles**. Al elegir un servicio en el dropdown se agrega como *chip/tag* debajo, y cada tag se puede **borrar** con una "x". Queda más limpio, escalable (sirve si crecen los servicios) y estilizado. Detalles a definir en su momento:
  - Mostrar los servicios agrupados por categoría dentro del dropdown (con `<optgroup>` o menú custom).
  - Evitar duplicados (no permitir agregar un servicio ya seleccionado) y permitir deseleccionar desde el propio tag.
  - Estilo de tags con los tokens de tema (`surface-2`, `line`, `ink`) para que funcionen en claro y oscuro.
  - Mantener el estado en el `FormArray` actual para no cambiar el payload que recibe el backend.
- [ ] (Idea) Placeholder/estado vacío más amigable en el formulario de cotización.
- [ ] (Idea) Autoscroll al primer campo con error al intentar enviar.

---

## ▶️ Cómo correr el proyecto

Backend local, dos opciones (misma API en `http://localhost:8000/api/v1`):

```bash
# Opción WSL (Linux venv, dentro de Duomanbe) — esperar ~15 s a "Application startup complete"
./run.sh
```

```powershell
# Opción PowerShell (venv nativo de Windows, dentro de Duomanbe)
.\run.ps1
# o con helpers:  . .\tools.ps1  →  du-run   (ver más abajo)
```

Frontend (WSL; node vive en Windows):

```bash
cmd.exe /c "cd /d C:\Users\gonza\Desktop\Duoman\Duomanfe && ng serve"
```

- Frontend: `http://localhost:4200` · API: `http://localhost:8000/api/v1`
- Si "port already in use": `pkill -f uvicorn` (WSL) o matar uvicorn en PowerShell (Ctrl+C).

### Venv nativo de Windows (`.venv-win`)

Creado con `py -m venv .venv-win` (Python 3.11.4) en `Duomanbe/`. Requisitos instalados y **7 tests pasando**.

Dot-source los helpers una vez por sesión:

```powershell
cd C:\Users\gonza\Desktop\Duoman\Duomanbe
. .\tools.ps1
```

Funciones disponibles:

| Comando | Qué hace |
| --- | --- |
| `du-freeze` | Lista paquetes instalados (pip freeze) |
| `du-pip install ...` | Instala paquetes en el venv Windows |
| `du-run` | Arranca uvicorn (reload) |
| `du-test` | Corre pytest |
| `du-alembic ...` | Ejecuta Alembic (ej: `du-alembic current`) |

Notas:
- Ambos venvs (`./.venv` Linux y `./.venv-win` Windows) están ignorados en git.
- El venv Windows usa Python 3.11 mientras el de WSL usa 3.12; ambos pasan los mismos tests.

## 🔑 Datos clave

- Proyecto Supabase: `https://vqctmwasxxlpzsxuogna.supabase.co` · región pooler `aws-0-us-east-2`.
- Admin backend: `cuentas.gonzalez.familia@gmail.com` (rol admin vía `scripts/set_admin_role.py`).
- Enums de estado en español (ver `Duomanbe/app/schemas/enums.py`).
- Backend corre con `run.sh` (= uvicorn `--loop asyncio`).
