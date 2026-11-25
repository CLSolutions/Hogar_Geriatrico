DROP DATABASE IF EXISTS casa_trompo_db;
CREATE DATABASE casa_trompo_db;
USE casa_trompo_db;
-- SEGURIDAD Y USUARIOS
-- ______________________________________________ Rol ______________________________________________
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre_rol VARCHAR(20) NOT NULL,
    descripcion_rol VARCHAR(100) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

-- --------------Usuario (personal, administrativos, familiares con acceso)-----------------
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_rol INT,
    FOREIGN KEY (id_rol)
        REFERENCES rol (id_rol),
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

-- ______________________________________________ RESIDENTES ______________________________________________

-- --------------Residente-----------------
CREATE TABLE residente (
    id_residente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    tipo_doc ENUM('CC', 'CE', 'PAS') NOT NULL,
    num_doc VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('F', 'M', 'OTRO') NOT NULL,
    eps VARCHAR(60) NULL,
    grupo_sanguineo ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NULL,
    nivel_dependencia ENUM('INDEPENDIENTE', 'LEVE', 'MODERADA', 'TOTAL') NOT NULL DEFAULT 'INDEPENDIENTE',
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE NULL,
    motivo_salida ENUM('RETIRO_FAMILIAR', 'TRASLADO', 'FALLECIMIENTO') NULL,
    observaciones VARCHAR(255) NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

-- --------------Familiar / Acudiente-----------------
-- id_usuario es NULL cuando el familiar es solo un contacto sin cuenta.
-- Si tiene cuenta, su usuario debe tener el rol FAMILIAR.
CREATE TABLE familiar (
    id_familiar INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    id_usuario INT NULL,
    FOREIGN KEY (id_residente)
        REFERENCES residente (id_residente),
    FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario),
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    parentesco VARCHAR(30) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NULL,
    direccion VARCHAR(60) NULL,
    es_responsable BOOLEAN NOT NULL DEFAULT FALSE,
    es_contacto_emergencia BOOLEAN NOT NULL DEFAULT FALSE
);

-- --------------Habitacion-----------------
CREATE TABLE habitacion (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    piso TINYINT NOT NULL,
    capacidad TINYINT NOT NULL DEFAULT 1,
    tipo ENUM('INDIVIDUAL', 'COMPARTIDA', 'ENFERMERIA') NOT NULL DEFAULT 'INDIVIDUAL',
    estado ENUM('DISPONIBLE', 'OCUPADA', 'MANTENIMIENTO') NOT NULL DEFAULT 'DISPONIBLE'
);

-- --------------Asignacion de habitacion (historial)-----------------
CREATE TABLE asignacion_habitacion (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    id_habitacion INT NOT NULL,
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    FOREIGN KEY (id_habitacion) REFERENCES habitacion (id_habitacion),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL
);

-- ______________________________________________ SALUD ______________________________________________

-- --------------Historia clinica -----------------
CREATE TABLE historia_clinica (
    id_historia INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL UNIQUE,
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    diagnosticos TEXT NULL,
    alergias TEXT NULL,
    antecedentes TEXT NULL,
    dieta_especial VARCHAR(100) NULL,
    fecha_apertura DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- --------------Control de signos vitales-----------------
CREATE TABLE signos_vitales (
    id_signos INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    id_usuario INT NOT NULL COMMENT 'Quien registra (enfermería)',
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    presion_sistolica SMALLINT NULL,
    presion_diastolica SMALLINT NULL,
    frecuencia_cardiaca SMALLINT NULL,
    temperatura DECIMAL(4,1) NULL,
    saturacion_oxigeno TINYINT NULL,
    peso_kg DECIMAL(5,2) NULL,
    glucosa SMALLINT NULL,
    observaciones VARCHAR(255) NULL
);

-- --------------Cita medica-----------------
CREATE TABLE cita_medica (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    especialidad VARCHAR(50) NOT NULL,
    medico VARCHAR(60) NULL,
    lugar VARCHAR(80) NULL,
    fecha_hora DATETIME NOT NULL,
    motivo VARCHAR(150) NULL,
    estado ENUM('PROGRAMADA', 'REALIZADA', 'CANCELADA') NOT NULL DEFAULT 'PROGRAMADA',
    resultado TEXT NULL
);

-- ______________________________________________ INSUMOS Y MEDICAMENTOS ______________________________________________

-- ---------------------------Categoria Insumos (medicamentos, jeringas, etc.)----------------------------
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cat VARCHAR(40) NOT NULL,
    descripcion_cat VARCHAR(100) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

-- --------------Proveedor-----------------
CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    nit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NULL,
    direccion VARCHAR(60) NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

-- --------------Insumo (producto del inventario)-----------------
CREATE TABLE insumo (
    id_insumo INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria),
    nombre VARCHAR(60) NOT NULL,
    descripcion VARCHAR(100) NULL,
    unidad_medida VARCHAR(20) NOT NULL COMMENT 'tabletas, ml, unidad, caja...',
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    fecha_vencimiento DATE NULL,
    requiere_formula BOOLEAN NOT NULL DEFAULT FALSE,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

-- --------------Compra (entrada de insumos)-----------------
CREATE TABLE compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor (id_proveedor),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    fecha_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE detalle_compra (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_insumo INT NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES compra (id_compra),
    FOREIGN KEY (id_insumo) REFERENCES insumo (id_insumo),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL
);

-- --------------Prescripcion (medicamento formulado a un residente)-----------------
CREATE TABLE prescripcion (
    id_prescripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    id_insumo INT NOT NULL,
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    FOREIGN KEY (id_insumo) REFERENCES insumo (id_insumo),
    dosis VARCHAR(40) NOT NULL,
    frecuencia VARCHAR(40) NOT NULL COMMENT 'ej: cada 8 horas',
    via ENUM('ORAL', 'INYECTABLE', 'TOPICA', 'INHALADA', 'OTRA') NOT NULL DEFAULT 'ORAL',
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    medico VARCHAR(60) NULL,
    estado ENUM('ACTIVA', 'SUSPENDIDA', 'FINALIZADA') NOT NULL DEFAULT 'ACTIVA'
);

-- --------------Administracion de medicamento (registro por turno)-----------------
CREATE TABLE administracion_medicamento (
    id_administracion INT AUTO_INCREMENT PRIMARY KEY,
    id_prescripcion INT NOT NULL,
    id_usuario INT NOT NULL COMMENT 'Quien administra',
    FOREIGN KEY (id_prescripcion) REFERENCES prescripcion (id_prescripcion),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cantidad_administrada INT NOT NULL DEFAULT 1,
    administrado BOOLEAN NOT NULL DEFAULT TRUE,
    observaciones VARCHAR(150) NULL
);

-- ______________________________________________ CUIDADO DIARIO Y ACTIVIDADES ______________________________________________

-- --------------Actividad (terapia, juegos, manualidades...)-----------------
CREATE TABLE actividad (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL COMMENT 'Responsable',
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    nombre VARCHAR(60) NOT NULL,
    descripcion VARCHAR(150) NULL,
    tipo ENUM('TERAPIA', 'RECREATIVA', 'CULTURAL', 'FISICA', 'ESPIRITUAL') NOT NULL,
    fecha_hora DATETIME NOT NULL,
    duracion_min SMALLINT NULL,
    estado ENUM('PROGRAMADA', 'REALIZADA', 'CANCELADA') NOT NULL DEFAULT 'PROGRAMADA'
);

CREATE TABLE actividad_residente (
    id_actividad INT NOT NULL,
    id_residente INT NOT NULL,
    PRIMARY KEY (id_actividad, id_residente),
    FOREIGN KEY (id_actividad) REFERENCES actividad (id_actividad),
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    asistio BOOLEAN NULL
);

-- --------------Visita de familiares-----------------
CREATE TABLE visita (
    id_visita INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    id_familiar INT NULL,
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    FOREIGN KEY (id_familiar) REFERENCES familiar (id_familiar),
    nombre_visitante VARCHAR(60) NULL COMMENT 'Si no es familiar registrado',
    fecha_hora_entrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_salida DATETIME NULL,
    observaciones VARCHAR(150) NULL
);

-- --------------Incidente (caidas, malestares, etc.)-----------------
CREATE TABLE incidente (
    id_incidente INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    id_usuario INT NOT NULL COMMENT 'Quien reporta',
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    tipo ENUM('CAIDA', 'MALESTAR', 'CONFLICTO', 'FUGA', 'OTRO') NOT NULL,
    gravedad ENUM('LEVE', 'MODERADO', 'GRAVE') NOT NULL DEFAULT 'LEVE',
    descripcion TEXT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    se_notifico_familia BOOLEAN NOT NULL DEFAULT FALSE
);


-- ______________________________________________ FACTURACION (mensualidades) ______________________________________________

CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_residente INT NOT NULL,
    id_familiar INT NULL COMMENT 'Quien paga',
    FOREIGN KEY (id_residente) REFERENCES residente (id_residente),
    FOREIGN KEY (id_familiar) REFERENCES familiar (id_familiar),
    concepto VARCHAR(80) NOT NULL COMMENT 'Mensualidad, servicio extra...',
    periodo_mes TINYINT NULL,
    periodo_anio SMALLINT NULL,
    valor DECIMAL(12,2) NOT NULL,
    metodo_pago ENUM('EFECTIVO', 'TRANSFERENCIA', 'TARJETA') NOT NULL,
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PAGADO', 'PENDIENTE', 'VENCIDO') NOT NULL DEFAULT 'PENDIENTE'
);