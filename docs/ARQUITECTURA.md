<p align="center">
<img width="200" alt="Logo Empresa v2" src="https://github.com/user-attachments/assets/5b3c0396-ca2c-4451-9047-8d8a835d8087" />
</p>
# Arquitectura del Sistema y Contratos de API — Hogar Geriátrico Casa Trompo

* **Firma Desarrolladora:** CL Solutions
* **Cliente:** Hogar Geriátrico Casa Trompo
* **Líder Técnico / Arquitecto:** Víctor Contreras
* **Versión del Documento:** 1.0 (Actualizado según acuerdos de `ACTA-001-KICKOFF`)

---

## 1. Stack Tecnológico Oficial

* **Frontend:** HTML5 semántico, **CSS3 modular puro (Variables CSS, Grid y Flexbox)** y **JavaScript moderno (ES6+)** bajo arquitectura *Multi-Page Application* (MPA) consumiendo la API mediante `fetch` (`credentials: 'include'`). Sin frameworks CSS externos.
* **Backend:** **Node.js** + **Express** + driver **`mysql2/promise`** (consultas estrictamente parametrizadas con marcadores `?`), validación de esquemas con `Zod`, hashing con `Argon2id` y cabeceras `Helmet`.
* **Base de Datos:** **MySQL 8.0 o superior**, motor transaccional obligatorio **`InnoDB`** y codificación **`utf8mb4_unicode_ci`**.
* **Seguridad y Cumplimiento:** Protección de datos personales (**Ley 1581**), accesibilidad web **WCAG AAA** ($\ge 7:1$) y bitácoras inmutables (*Append-Only*).

---

## 2. Mapa de Módulos y 11 Apartados Funcionales

### Entorno A: Portal Web Público (Acceso Libre)
1. **Inicio (`index.html`):** Presentación institucional, pilares de terapia de reminiscencia, rutina diaria y accesos rápidos.
2. **Nosotros (`nosotros.html`):** Historia del hogar geriátrico, modelo de atención integral, equipo multidisciplinario e instalaciones.
3. **Contacto (`contacto.html`):** Canales de atención, ubicación geográfica, horarios de visita y formulario de consultas generales (`POST /api/contact`).
4. **Registro / Solicitud de Admisión (`registro.html`):** Asistente de pre-valoración asistencial para adultos mayores (edad, movilidad, modalidad de estancia) y radicación de solicitud con aceptación obligatoria de Ley 1581 (`POST /api/admissions`).
5. **Iniciar Sesión (`login.html`):** Autenticación segura para personal interno, residentes y familiares autorizados (`POST /api/auth/login`).
6. **Eventos Comunitarios (`eventos.html`):** Cartelera pública e inscripción con control estricto de cupos para actividades abiertas a ciudadanos externos (aeróbicos, rumba/zumba, almuerzos comunitarios, entrenamientos de porrismo, talleres abiertos) (`GET /api/events`, `POST /api/events/:id/register`).

### Entorno B: Sistema ERP Interno (Acceso Restringido por Rol)
7. **Dashboard Operativo y Eventos (`erp.html`):** Panel resumen con métricas filtradas por rol (`GET /api/dashboard/summary`) y gestión de eventos comunitarios y sus inscritos para `ADMIN` (`POST /api/events`, `GET /api/events/:id/registrations`).
8. **Gestión de Admisiones (`admisiones.html`):** Bandeja de evaluación clínica (`APROBADA` / `RECHAZADA`) y conversión atómica de solicitudes aprobadas en expedientes de residentes.
9. **Expedientes y Bitácora Clínica (`residentes.html`):** Ficha médica (alergias, plan de cuidado) y registro cronológico inmutable de signos vitales/evolución por turno. Familiares y residentes acceden exclusivamente a su registro vinculado.
10. **Inventario Farmacéutico FEFO (`inventario.html`):** Catálogo maestro, control de lotes por fecha de vencimiento y despacho automático bajo algoritmo **FEFO** (*First-Expired, First-Out*) con alertas de stock mínimo.
11. **Usuarios y Auditoría (`usuarios.html`):** Creación de cuentas internas, vinculación familiar-residente y consulta de trazabilidad inmutable (exclusivo `ADMIN`).

---

## 3. Matriz de Control de Acceso Basado en Roles (RBAC)

| Recurso / Operación | `ADMIN` | `ENFERMERIA` | `INVENTARIO` | `FAMILIAR` | `RESIDENTE` |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Formulario de contacto (`POST /api/contact`)** | Público | Público | Público | Público | Público |
| **Solicitud de admisión (`POST /api/admissions`)** | Público | Público | Público | Público | Público |
| **Eventos comunitarios (Consultar / Inscribirse)** | Público | Público | Público | Público | Público |
| **Eventos comunitarios (Crear / Ver inscritos / Anular cupo)** | CRUD | — | — | — | — |
| **Bandeja de admisiones (Listar / Validar)** | Leer / Aprobar | Leer / Aprobar | — | — | — |
| **Expedientes de residentes (Listar)** | Todos | Todos | Lectura | Solo vinculados | Propio |
| **Bitácora clínica (Leer evolución)** | Todos | Todos | — | Solo vinculados | Propio |
| **Bitácora clínica (Registrar signos vitales)** | Crear | Crear | — | — | — |
| **Inventario y lotes (Consultar stock)** | Leer | Leer | Leer | — | — |
| **Inventario (Registrar entrada de lotes)** | Crear | — | Crear | — | — |
| **Inventario (Dispensar dosis FEFO)** | Ejecutar | Ejecutar | Ejecutar | — | — |
| **Usuarios y roles (CRUD y vinculación)** | CRUD | — | — | — | — |
| **Auditoría inmutable (Consultar logs)** | Leer | — | — | — | — |

---

## 4. Reglas Transversales de Arquitectura

1. **Gestión de Sesión en MPA (`Cookies HttpOnly`):**
   - Al autenticarse, el servidor emite dos cookies con flags `HttpOnly; SameSite=Strict` (`Secure` en producción): `access_token` (15 minutos) y `refresh_token` (7 días, rotativo y almacenado como hash en `users.refresh_token_hash`).
   - Cada vista privada (`erp.html`, `admisiones.html`, `residentes.html`, `inventario.html`, `usuarios.html`) ejecuta al cargar el módulo `js/auth-guard.js`, invocando `GET /api/auth/me` para validar sesión, autorizar secciones por rol o redirigir a `login.html` ante `401`.
2. **Prevención de XSS en Vanilla JS:**
   - Queda estrictamente prohibido el uso de `innerHTML`, `outerHTML` o `insertAdjacentHTML` con datos provenientes de la API o de entradas de usuario. Toda renderización dinámica en el DOM se realizará mediante `document.createElement()` y `.textContent`.
3. **Arquitectura CSS3 Pura y Accesibilidad WCAG AAA:**
   - Estructura modular sin librerías externas: `css/tokens.css` (paleta semántica, espaciado y tipografía), `css/layout.css` (grillas responsivas con CSS Grid y Flexbox), `css/components.css` (botones, tarjetas, formularios, tablas y modales nativos `<dialog>`) y `css/accessibility.css` (modo alto contraste **$\ge 7:1$**, áreas táctiles mínimas de `48x48 px`, anillos `:focus-visible` de `3px` y escalado tipográfico `100%`, `125%`, `150%` persistido en `localStorage`).
4. **Aislamiento de Eventos Comunitarios:**
   - Las actividades abiertas a ciudadanos externos (`community_events` y `event_registrations`) operan en tablas independientes sin relación directa con expedientes clínicos (`residents`), preservando la confidencialidad asistencial.

---

## 5. Contratos de Endpoints REST (`/api`)

### 5.1 Convenciones Globales y Códigos HTTP
* **Content-Type:** `application/json; charset=utf-8`
* **Autenticación:** Automática vía cookies `HttpOnly` (`credentials: 'include'` en `fetch`).
* **Códigos de Error Estándar:**
  * `400 Bad Request`: Error de validación de esquema (`Zod`).
  * `401 Unauthorized`: Sesión inexistente, cookie expirada o credenciales inválidas.
  * `403 Forbidden`: Rol sin privilegios o intento IDOR sobre residente no vinculado.
  * `404 Not Found`: Recurso inexistente.
  * `409 Conflict`: Violación de unicidad (`email`, `document_number`, `batch_code`), inscripción duplicada a evento, aforo agotado o stock insuficiente.
  * `429 Too Many Requests`: Límite de tasa excedido.

---

### 5.2 Salud y Contacto Público (`Health & Contact`)

#### `GET /api/health`
* **Acceso:** Público
* **Respuesta `200 OK`:**
```json
{
  "status": "ok",
  "service": "casa-trompo-api",
  "database": "mysql-8.0-innodb",
  "timestamp": "2026-11-23T14:12:00.000Z"
}
