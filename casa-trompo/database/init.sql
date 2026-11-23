DROP DATABASE IF EXISTS casa_trompo_db;
CREATE DATABASE casa_trompo_db;
USE casa_trompo_db;

-- --------------Rol-----------------
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre_rol VARCHAR(20) NOT NULL,
    descripcion_rol VARCHAR(100) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

-- --------------Usuario-----------------
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES rol (id_rol),
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    tipo_doc ENUM('CC', 'TI', 'PAS', 'NIT', 'CE') NOT NULL,
    num_doc VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE NULL,
    telefono VARCHAR(20) NOT NULL,
    departamento VARCHAR(30) NOT NULL,
    ciudad VARCHAR(30) NULL,
    direccion VARCHAR(40) NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    fecha_ingreso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------Categoria Insumos (medicamentos,geringas,etc )----------------------------
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cat VARCHAR(40) NOT NULL,
    descripcion_cat VARCHAR(100) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);