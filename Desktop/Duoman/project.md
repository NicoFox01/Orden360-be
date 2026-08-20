# DUOMAN - Plataforma de Gestión y Landing Web (PROJECT.MD)

> **Documento de especificación para Vibe Coding con IA.**
> Este archivo define las reglas de arquitectura, diseño, estructura de datos, endpoints y módulos para el desarrollo integral del frontend (Angular SPA) y backend (FastAPI + Supabase).

---

## 1. Visión General del Proyecto
**DUOMAN - Servicio de Mantenimiento** es una plataforma web orientada a la contratación y gestión integral de servicios de instalaciones, mantenimiento preventivo por abono y atención ante imprevistos/reparaciones corporativas y residenciales.

El sistema comprende:
1. **Frontend Público (SPA):** Landing corporativa institucional, catálogo interactivo de servicios clasificados, cotizador online y módulo de captación de talento ("Trabajá con nosotros").
2. **Backoffice / Dashboard Administrativo (Privado):** Acceso oculto por ruta `/login` con panel de control, métricas en tiempo real (contadores de estados), gestión de cotizaciones recibidas, postulaciones con visualización de CVs y directorio de empleados.
3. **Backend API Serverless:** Desarrollado en Python con FastAPI, conectado a Supabase (PostgreSQL + Auth + Storage).

---

## 2. Stack Tecnológico & Arquitectura

### 2.1. Frontend
- **Framework:** Angular (Última versión LTS / Standalone Components).
- **Enrutamiento:** Angular Router con Guards (`AuthGuard`) para proteger rutas administrativas.
- **Estilos & UI:** Tailwind CSS o CSS Modules con sistema de tokens de diseño DUOMAN.
- **Iconografía:** Lucide Angular o Heroicons.
- **Gestión de Estado / Reactividad:** Signals y RxJS.

### 2.2. Backend
- **Framework:** Python con FastAPI (orientado a arquitectura limpia / hexagonal / serverless deploy en Vercel o AWS Lambda).
- **Validación de Datos:** Pydantic V2.
- **Seguridad y Auth:** JWT y Supabase Auth con middleware de verificación de roles (`role == 'admin'`).

### 2.3. Base de Datos & Almacenamiento
- **Base de Datos:** PostgreSQL (alojado en Supabase).
- **Storage:** Supabase Storage (Bucket privado `resumes` para almacenar archivos PDF/DOCX de CVs).
- **Estrategia de Eliminación:** **Borrado Lógico** en todas las entidades (`is_active: bool = True`).

---

## 3. Guía de Estilos & Paleta de Marca (DUOMAN Design System)

Basado en el isologo oficial de DUOMAN:

| Elemento / Token | Color HEX | RGB | Aplicación Recomendada |
| :--- | :--- | :--- | :--- |
| **Primary (Amarillo)** | `#F2D20B` | `242, 210, 11` | Botones de acción (CTA), badges destacados, acentos |
| **Secondary (Naranja)** | `#D97A1D` | `217, 122, 29` | Gradientes, íconos activos, bordes secundarios |
| **Dark Orange** | `#C75B1C` | `199, 91, 28` | Sombras, estados hover de botones |
| **Dark Surface / Text**| `#050505` | `5, 5, 5` | Tipografía principal, footer, backgrounds oscuros |
| **Light Surface / BG** | `#FFFFFF` | `255, 255, 255` | Fondos de secciones claras, inputs, tarjetas |
| **Muted Grey** | `#B8B9B5` | `184, 185, 181`| Subtítulos, bordes tenues, dividers |

---

## 4. Estructura del Frontend (SPA)

### 4.1. Navegación & Estructura de Rutas
- `/` -> Landing Page completa con navegación por secciones / anclas suaves:
  - `#inicio` (Hero section)
  - `#nosotros` (Historia, Misión, Visión, Valores)
  - `#servicios` (Catálogo interactivo con filtrado por categoría)
  - `#cotizaciones` (Formulario cotizador)
  - `#trabaja-con-nosotros` (Formulario de postulaciones)
- `/login` -> **Ruta oculta** (sin botón visible en el navbar público) para acceso de administradores.
- `/admin` -> Layout protegido con panel de administración:
  - `/admin/dashboard` (Métricas, contadores y accesos rápidos)
  - `/admin/cotizaciones` (Gestión, filtros por estado, detalle y borrado lógico)
  - `/admin/postulaciones` (Gestión de CVs, cambio de estado y descarga de adjuntos)
  - `/admin/empleados` (Listado y gestión básica de personal)

---

### 4.2. Contenido Detallado de Secciones Públicas

#### A. Inicio (Hero Section)
- **Titular:** Soluciones integrales en mantenimiento e instalaciones para empresas y hogares.
- **Subtítulo:** Planes preventivos por abono, proyectos de obra y respuesta rápida ante imprevistos técnicos con garantía de calidad y personal especializado.
- **CTAs:** `[Solicitar Cotización]` (lleva a `#cotizaciones`) | `[Nuestros Servicios]` (lleva a `#servicios`).

#### B. Nosotros
- **Historia:** Más de 10 años brindando soluciones de mantenimiento edilicio, infraestructura y mejoras continuas a empresas, industrias y residencias.
- **Misión:** Garantizar la continuidad operativa, seguridad y confort de las instalaciones de nuestros clientes mediante un servicio ágil, profesional y preventivo.
- **Visión:** Ser la empresa referente en servicios integrales de mantenimiento e infraestructura corporativa, reconocida por su excelencia operativa e innovación en gestión.
- **Valores:**
  1. *Compromiso y Puntualidad:* Respuesta eficaz y cumplimiento de plazos.
  2. *Seguridad Técnica:* Apego a normas vigentes y estándares de prevención.
  3. *Transparencia:* Presupuestos claros y trazabilidad en cada intervención.
  4. *Calidad Duradera:* Materiales de primera línea y mano de obra certificada.

#### C. Catálogo de Servicios
Organizado en 2 grandes categorías:

##### Categoría 1: Mantenimiento & Instalaciones Técnicas
1. **Cableado de datos y redes:** Diseño, instalación y mantenimiento de redes UTP (Cat5e/Cat6), fibra óptica, patch panels, racks, switches, Wi-Fi y certificación.
2. **Climatización (Split):** Cálculo térmico, instalación interior/exterior, tendido de cañerías, carga de gas, limpieza preventiva y abonos de mantenimiento.
3. **Electricidad:** Tableros, circuitos, puesta a tierra, protecciones termo-magnéticas y diferenciales, detección de fallas bajo normativa.
4. **Iluminación:** Proyectos de iluminación LED, sensores, dimmers y optimización del consumo energético en oficinas y locales.
5. **Plomería:** Redes de agua, desagües, colocación de artefactos, detección de fugas, bombas y termotanques con guardias técnicas.
6. **Cerrajería:** Aperturas de urgencia, cambio de cilindros, cerraduras de seguridad, cierres automáticos y control de accesos.
7. **Vidriería:** Vidrios templados/laminados, aberturas de aluminio, mamparas a medida y sellado hermético.
8. **Destapaciones:** Desobstrucción electromecánica e hidrolavado, cámaras de inspección cloacal y mantenimiento de sumideros.

##### Categoría 2: Construcción y Mejoras
9. **Construcción en seco:** Tabiquería, cielorrasos y revestimientos (Durlock), aislación termoacústica y pases para instalaciones sin generar escombros masivos.
10. **Albañilería:** Mampostería, revoques, contrapisos, colocación de cerámicos/porcelanatos y reparaciones estructurales ligeras.
11. **Pintura:** Preparación de superficies, enduido, aplicación de látex, esmalte y poliuretano (rodillo/airless) interior y exterior.
12. **Herrería:** Estructuras metálicas, rejas, portones, barandas y soportes con tratamientos anticorrosivos.
13. **Techos:** Reparación y montaje de cubiertas (chapa, tejas), zinguería, aislaciones térmicas y control de pendientes.
14. **Impermeabilizaciones:** Tratamiento de terrazas, azoteas y muros con membranas asfálticas, poliuretano líquido y selladores de alta resistencia.

---

### 4.3. Formularios Públicos

#### Formulario 1: Cotizaciones (`#cotizaciones`)
- `nombre_completo` (String, requerido)
- `email` (Email, requerido)
- `telefono` (String, requerido)
- `empresa` (String, opcional)
- `ubicacion` (String, requerido - ej: Localidad / Zona)
- `servicios_interes` (Array de strings - checkboxes multiselección basados en la lista de servicios)
- `observaciones` (Textarea, opcional)

#### Formulario 2: Trabajá con Nosotros (`#trabaja-con-nosotros`)
- `nombre_completo` (String, requerido)
- `telefono` (String, requerido)
- `email` (Email, requerido)
- `zona_residencia` (Select: `CABA`, `GBA Norte`, `GBA Sur`, `GBA Oeste`)
- `rol_buscado` (String, requerido - ej: "Técnico Electricista", "Oficial Pintor")
- `cv_file` (File input - solo `.pdf`, `.doc`, `.docx`, máx 5MB)

---

## 5. Módulo Administrativo (Backoffice)

### 5.1. Dashboard Principal (`/admin/dashboard`)
- **Cards de Métricas en Tiempo Real:**
  - Total Cotizaciones Nuevas (`Pendiente`)
  - Total Cotizaciones en Proceso (`Contactado` / `Cotizacion Presentada`)
  - Postulaciones Nuevas (`Postulado`)
  - Postulaciones en Proceso (`Visto` / `Contactado` / `Entrevistado`)
  - Total Empleados Activos

### 5.2. Estados y Flujos

#### Estados de Cotizaciones:
1. `PENDIENTE` (Default)
2. `CONTACTADO`
3. `COTIZACION_PRESENTADA`
4. `PROPUESTA_CONFIRMADA`
5. `RECHAZADA` / `CANCELADA`

#### Estados de Postulaciones:
1. `POSTULADO` (Default)
2. `VISTO`
3. `CONTACTADO`
4. `ENTREVISTADO`
5. `NO_APLICA`
6. `CONTRATADO`

### 5.3. Funcionalidades del Backoffice
- Filtro por tabs o select de estados.
- Buscador por texto (nombre, empresa, teléfono, rol).
- Cambio rápido de estado desde la tabla/tarjeta.
- Modal de detalle completo (ver array de servicios y notas).
- Botón de descarga/visualización directa del CV desde Supabase Storage.
- Eliminación con confirmación (Soft Delete: `is_active = false`).

---

## 6. Modelo de Datos (Esquema Supabase / PostgreSQL)

```sql
-- Habilitar extensión para UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Tabla de Cotizaciones
CREATE TYPE quotation_status AS ENUM (
    'Pendiente', 
    'Contactado', 
    'Cotizacion Presentada', 
    'Propuesta Confirmada', 
    'Cancelada'
);

CREATE TABLE quotations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    company VARCHAR(150),
    location VARCHAR(200) NOT NULL,
    services TEXT[] NOT NULL DEFAULT '{}',
    notes TEXT,
    status quotation_status NOT NULL DEFAULT 'Pendiente',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Tabla de Postulaciones / Candidatos
CREATE TYPE candidate_status AS ENUM (
    'Postulado', 
    'Visto', 
    'Contactado', 
    'Entrevistado', 
    'No aplica', 
    'Contratado'
);

CREATE TYPE residency_zone AS ENUM (
    'CABA', 
    'GBA Norte', 
    'GBA Sur', 
    'GBA Oeste'
);

CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    zone residency_zone NOT NULL,
    target_role VARCHAR(150) NOT NULL,
    resume_url TEXT NOT NULL,
    status candidate_status NOT NULL DEFAULT 'Postulado',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Tabla de Empleados
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(50) NOT NULL,
    role VARCHAR(100) NOT NULL,
    specialties TEXT[] DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índices de consulta rápida
CREATE INDEX idx_quotations_status ON quotations(status) WHERE is_active = TRUE;
CREATE INDEX idx_applications_status ON applications(status) WHERE is_active = TRUE;
```

---

## 7. Especificación de Endpoints API (FastAPI)

### 7.1. Rutas Públicas (Sin autenticación)
- `POST /api/v1/quotations`
  - **Body:** `QuotationCreateSchema`
  - **Acción:** Inserta una nueva solicitud de presupuesto en estado `Pendiente`.
- `POST /api/v1/applications`
  - **Body:** `multipart/form-data` (datos personales + archivo de CV).
  - **Acción:** Sube el archivo a Supabase Storage (`resumes/`) y registra al candidato en estado `Postulado`.

### 7.2. Rutas Privadas (Requieren Bearer JWT Admin)
- `GET /api/v1/admin/metrics`
  - **Retorno:** Contadores agregados para el dashboard (solicitudes pendientes, en proceso, postulaciones nuevas, etc.).
- `GET /api/v1/admin/quotations?status={optional}&search={optional}`
  - **Retorno:** Lista de cotizaciones con `is_active == True`.
- `PATCH /api/v1/admin/quotations/{id}/status`
  - **Body:** `{"status": "..."}`
- `DELETE /api/v1/admin/quotations/{id}`
  - **Acción:** Borrado lógico (`is_active = false`).
- `GET /api/v1/admin/applications?status={optional}&search={optional}`
  - **Retorno:** Lista de postulaciones con URL firmada para visualización de CV.
- `PATCH /api/v1/admin/applications/{id}/status`
  - **Body:** `{"status": "..."}`
- `DELETE /api/v1/admin/applications/{id}`
  - **Acción:** Borrado lógico (`is_active = false`).
- `GET /api/v1/admin/employees`
- `POST /api/v1/admin/employees`
- `DELETE /api/v1/admin/employees/{id}`

---

## 8. Guía de Implementación para el Asistente de IA (Vibe Coding Prompt Rules)
Cuando se trabaje en el código con la IA, seguir este orden de sprints:
1. **Sprint 1 (Backend Core):** Estructura FastAPI con modelos Pydantic, configuración del cliente Supabase y endpoints públicos con subida a bucket.
2. **Sprint 2 (Frontend Público):** Configuración de Angular SPA, estilos DUOMAN con Tailwind, diseño responsivo de Hero, Servicios (con cards interactivas y modales de detalle) y formularios con validación reactiva.
3. **Sprint 3 (Auth & Endpoints Privados):** Integración de login con JWT/Supabase Auth y endpoints administrativos protegidos.
4. **Sprint 4 (Backoffice Angular):** Implementación del panel `/admin` con contadores rápidos de dashboard, tablas de cotizaciones y candidatos con filtros reactivos y cambio de estados.
