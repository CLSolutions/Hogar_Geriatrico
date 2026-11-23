<p align="center">
<img width="200" alt="Logo Empresa v2" src="https://github.com/user-attachments/assets/5b3c0396-ca2c-4451-9047-8d8a835d8087" />
</p>
  <h1>Hogar Geriátrico Casa Trompo — Portal Web y Sistema ERP</h1>
  <p><strong>Desarrollado por CL Solutions</strong> | Accesibilidad WCAG AAA | Cumplimiento Ley 1581</p>
</div>

---
# Hogar_Geriatrico
---

## Arquitectura y Stack Tecnológico

* **Frontend (`/frontend`):** HTML5 semántico, CSS3 y **JavaScript (ES6+)** bajo arquitectura *Multi-Page Application* (11 apartados: 6 públicos + 5 privados ERP).
* **Backend (`/backend`):** **Node.js** + **Express** + **`mysql2/promise`** + `Zod` + `Argon2id`.
* **Base de Datos (`/database`):** **MySQL 8.0+** (motor transaccional obligatorio `InnoDB`, codificación `utf8mb4_unicode_ci`).
* **Documentación (`/docs`):** Contratos de API, matriz RBAC (`ARQUITECTURA.md`) y actas de seguimiento.

---

## Estructura del Repositorio

```text
casa-trompo/
├── backend/                  # API REST Node.js + Express
│   └── src/
│       ├── config/           # Conexión MySQL, variables de entorno y CORS
│       ├── controllers/      # Controladores HTTP por módulo
│       ├── middlewares/      # Autenticación JWT (cookies), RBAC y manejo de errores
│       ├── routes/           # Definición de rutas /api/*
│       ├── services/         # Lógica de negocio y transacciones FEFO
│       └── validators/       # Esquemas de validación Zod
├── database/                 # Scripts DDL y datos semilla MySQL 8.0+
├── docs/                     # Documentación técnica, actas y activos visuales
│   ├── actas/
│   └── assets/
├── frontend/                 # Portal Público y ERP (HTML5 + JS ES6+)
│   ├── css/               # Imágenes, íconos y favicons
│   ├── img/                  # Sobrescritura WCAG AAA y estilos personalizados
│   └── js/                   # Módulos ES6+, cliente fetch y guardias de sesión
├── .env.example              # Plantilla de variables de entorno
├── .gitattributes            # Normalización de finales de línea (LF)
└── .gitignore                # Exclusión de secretos y dependencias
