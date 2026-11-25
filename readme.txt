# Hogar Geriátrico Casa Trompo — Portal Web & Sistema ERP Empresarial

> *"Donde la infancia vuelve a casa"* — Desarrollado por **CL Solutions**.

## Estructura del Proyecto


casa-trompo-erp/
├── .env / .env.example          # Variables de entorno y secretos criptográficos
├── docker-compose.yml           # Orquestación completa (PostgreSQL + API + Web)
├── database/init.sql            # Esquema relacional PostgreSQL, índices y restricciones
├── backend/                     # API REST Node.js + TypeScript + Argon2id + RBAC
└── frontend/                    # Aplicación React + TypeScript + Tailwind + Nginx
