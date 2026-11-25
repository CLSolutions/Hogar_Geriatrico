<p align="center">
<img width="200" alt="Logo Empresa v2" src="https://github.com/user-attachments/assets/5b3c0396-ca2c-4451-9047-8d8a835d8087" />
</p>
  <h1>ACTA DE REUNIÓN DE INICIO (KICKOFF)</h1>
  <p><strong>Proyecto:</strong> Portal Web Público y Sistema ERP Clínico/Administrativo — <em>Hogar Geriátrico Casa Trompo</em></p>
</div>

---

- **Código de Acta:** ACTA-001-KICKOFF
- **Fecha:** 19 de noviembre de 2026
- **Lugar / Modalidad:** Sogamoso, Boyacá — Sesión Virtual de Equipo Ejecutor
- **Proyecto:** Plataforma Web Pública y Sistema ERP Clínico/Administrativo "Hogar Geriátrico Casa Trompo"
- **Fase:** Sprint 0 — Planteamiento, Arquitectura y Cimientos

---

## 1. Asistentes y Roles Asignados

| Nombre | Rol en el Equipo | Responsabilidad Principal |
| :--- | :--- | :--- |
| **Víctor Contreras** | Scrum Master / Tech Lead | Arquitectura del sistema, contratos de API, gobierno de GitHub y gestión de impedimentos. |
| **Yonatan Rodriguez Martínez** | Diseñador UI/UX & Marca | Logotipo vectorial (SVG), paleta cromática accesible WCAG AAA y *wireframes* en grilla Bootstrap. |
| **Valerie Sofia Camargo Monroy** | Desarrollador Backend | API REST en Node.js/Express, seguridad y auditoría. |
| **Julián Camilo Montaña Montaña** | Desarrollador Frontend & DB | Modelado relacional MySQL 8.0+, Maquetación HTML5/CSS3/Bootstrap 5, lógica cliente JS (ES6+) y accesibilidad WCAG AAA. |

---

## 2. Orden del Día
1. Definición oficial y congelamiento del stack tecnológico.
2. Alcance funcional: delimitación de entornos, módulos y apartados del sistema.
3. Lineamientos obligatorios de seguridad, privacidad (Ley 1581) y accesibilidad (WCAG AAA).
4. Asignación de responsabilidades iniciales (Sprint 0) y flujo de trabajo en GitHub.

---

## 3. Acuerdos Técnicos y Arquitectónicos

### 3.1 Stack Tecnológico Oficial
Se aprueba por unanimidad la siguiente arquitectura desacoplada en tres capas:
- **Frontend:** HTML5 semántico, CSS3, **Bootstrap 5** y **JavaScript moderno (ES6+)** bajo arquitectura *Multi-Page Application* (MPA) modular consumiendo servicios vía `fetch`.
- **Backend:** **Node.js** con framework **Express** y driver `mysql2/promise` (consultas estrictamente parametrizadas con `?`).
- **Base de Datos:** **MySQL 8.0 o superior**, motor transaccional obligatorio **`InnoDB`** y codificación **`utf8mb4_unicode_ci`**.
- **Control de Versiones:** Repositorio central en **GitHub**. Rama `main` protegida; todo desarrollo se ejecutará en ramas independientes `feature/<nombre-modulo>` mediante *Pull Requests*.

### 3.2 Reglas Transversales No Negociables
1. **Accesibilidad (WCAG AAA):** Toda interfaz pública e interna debe soportar escalado tipográfico (`100%` a `150%`), áreas táctiles mínimas de `48x48 px` y modo de alto contraste con ratio **$\ge 7:1$** (sobrescribiendo variables CSS base de Bootstrap).
2. **Privacidad y Control de Acceso (RBAC + Ley 1581):**
   - El apartado público **Registro** opera exclusivamente como **formulario de solicitud de admisión / pre-valoración** con consentimiento explícito de datos personales.
   - No existirá auto-registro libre de cuentas internas; los usuarios con roles `ADMIN`, `ENFERMERIA`, `INVENTARIO`, `FAMILIAR` y `RESIDENTE` serán creados únicamente por Dirección (`ADMIN`).
3. **Seguridad en Cliente y Servidor:** Prohibido el uso de `innerHTML` para renderizar datos provenientes de la API (mitigación XSS); uso obligatorio de `textContent` / creación segura de nodos DOM. Bitácoras clínicas y de auditoría bajo esquema *Append-Only* (solo inserción).

---

## 4. Estructura Funcional Aprobada (10 Apartados)

### Entorno A: Portal Web Público (Acceso Libre)
1. **Inicio (`index.html`):** Presentación institucional, pilares de terapia de reminiscencia, rutina diaria y accesos rápidos.
2. **Nosotros (`nosotros.html`):** Historia del hogar geriátrico, modelo de atención integral, equipo multidisciplinario e instalaciones.
3. **Contacto (`contacto.html`):** Canales de atención, ubicación geográfica, horarios de visita y formulario de consultas generales.
4. **Registro / Solicitud de Admisión (`registro.html`):** Asistente de pre-valoración asistencial (edad, movilidad, modalidad de estancia) y radicación de solicitud con aceptación de Ley 1581.
5. **Iniciar Sesión (`login.html`):** Autenticación segura para personal interno, residentes y familiares autorizados.

### Entorno B: Sistema ERP Interno (Acceso Restringido por Rol)
6. **Dashboard Operativo (`erp.html`):** Panel resumen con métricas e indicadores filtrados según el rol autenticado.
7. **Gestión de Admisiones (`admisiones.html`):** Bandeja de evaluación clínica (`APROBADA` / `RECHAZADA`) y conversión de solicitudes aprobadas en expedientes de residentes.
8. **Expedientes y Bitácora Clínica (`residentes.html`):** Ficha médica (alergias, plan de cuidado) y registro diario de signos vitales/evolución por turno. Familiares solo acceden a su residente vinculado.
9. **Inventario Farmacéutico FEFO (`inventario.html`):** Gestión de medicamentos e insumos por lotes y fechas de vencimiento con descuento automático **FEFO** (*First-Expired, First-Out*) y alertas de stock mínimo.
10. **Usuarios y Auditoría (`usuarios.html`):** Gestión de cuentas internas, vinculación familiar-residente y consulta de trazabilidad inmutable (exclusivo `ADMIN`).

---

## 5. Compromisos y Entregables del Sprint 0

| Responsable | Tarea Asignada (GitHub Issue) | Entregable Verificable | Fecha Límite |
| :--- | :--- | :--- | :--- |
| **Víctor Contreras** *(Scrum Master / Tech Lead)* | Definición de contratos API, matriz RBAC y estructura base del repositorio. | Documento `/docs/ARQUITECTURA.md`, estructura de carpetas en `main` y reglas de protección de ramas. | `[21/11/2026]` |
| **Yonatan Rodriguez Martinez** *(UI/UX & Marca)* | Identidad visual, tokens cromáticos accesibles y bocetos de interfaz. | Logotipo en `.svg` (color, negativo, monocromático), favicons `.png`, tabla de colores `#HEX` ($\ge 7:1$) y *wireframes*. | `[20/11/2026]` |
| **Valerie Sofia Camargo Monroy** *(Backend)* | inicialización de servidor Node.js/Express. | Script `/database/init.sql` ejecutado sin errores y endpoints base de `/api/health`, `/api/auth/login` y `/api/admissions`. | `[21/11/2026]` |
| **Julian Camilo Montaña Montaña** *(Frontend  & DB)* | Despliegue de esquema relacional en MySQL 8.0+, Maquetación del Portal Público y barra transversal de accesibilidad. | Vistas `index.html`, `nosotros.html`, `contacto.html`, `registro.html` y `login.html` en Bootstrap 5 con controles de fuente y alto contraste. | `[21/11/2026]` |

---

## 6. Seguimiento y Próxima Sesión
- **Cadencia de Seguimiento:** *Daily Standup* diaria de máximo 15 minutos a las **`[09:00 AM]`** para reportar avance, plan del día y bloqueos técnicos.
- **Cierre de Sesión:** Siendo las **`[09:40 AM]`**, se da por concluida la reunión de inicio con la conformidad de todos los asistentes.
