-- Script de Base de Datos para Sistema de Recepcion de Documentos Grupo DCA
-- Motor: MySQL 8.0+ / MariaDB 10.4+

CREATE DATABASE IF NOT EXISTS dca_documentos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dca_documentos;

-- 1. Catalogo de Roles
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- 2. Empresas del Grupo DCA
CREATE TABLE IF NOT EXISTS empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    rfc VARCHAR(15),
    activo TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

-- 3. Departamentos
CREATE TABLE IF NOT EXISTS departamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- 4. Tipos de Documento
CREATE TABLE IF NOT EXISTS tipos_documento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- 5. Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rfc VARCHAR(15) NOT NULL UNIQUE,
    razon_social VARCHAR(200) NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(20),
    estado ENUM('ACTIVO', 'INACTIVO', 'SUSPENDIDO') DEFAULT 'ACTIVO',
    contador_id INT NULL, -- FK asignada tras crear la tabla usuarios
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 6. Usuarios del Sistema
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    cliente_id INT NULL, -- Vinculo si el usuario es un Cliente externo
    firma_path LONGTEXT NULL,
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES roles(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Clave Foranea para contador asignado al cliente
ALTER TABLE clientes
    ADD CONSTRAINT fk_clientes_contador
    FOREIGN KEY (contador_id) REFERENCES usuarios(id) ON DELETE SET NULL;

-- 7. Documentos (Recepciones / Folios)
CREATE TABLE IF NOT EXISTS documentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    folio VARCHAR(50) NOT NULL UNIQUE,
    cliente_id INT NOT NULL,
    empresa_id INT NOT NULL,
    tipo_doc_id INT NOT NULL,
    departamento_id INT NOT NULL,
    usuario_recep_id INT NOT NULL,
    contador_id INT NULL,
    asunto VARCHAR(255) NOT NULL,
    prioridad ENUM('BAJA', 'MEDIA', 'ALTA', 'URGENTE') DEFAULT 'MEDIA',
    estado ENUM('RECEPCIONADO', 'EN_PROCESO', 'PENDIENTE_CLIENTE', 'COMPLETADO', 'CANCELADO') DEFAULT 'RECEPCIONADO',
    firma_cliente LONGTEXT NULL,
    firma_recep LONGTEXT NULL,
    firma_contador_recep LONGTEXT NULL,
    firma_contador LONGTEXT NULL,
    notificar_correo TINYINT(1) DEFAULT 0,
    fecha_recepcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_limite_sla DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (empresa_id) REFERENCES empresas(id),
    FOREIGN KEY (tipo_doc_id) REFERENCES tipos_documento(id),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    FOREIGN KEY (usuario_recep_id) REFERENCES usuarios(id),
    FOREIGN KEY (contador_id) REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- 8. Archivos Adjuntos por Documento
CREATE TABLE IF NOT EXISTS documento_archivos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    documento_id INT NOT NULL,
    ruta_storage VARCHAR(255) NOT NULL,
    nombre_original VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100),
    tamano_bytes BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (documento_id) REFERENCES documentos(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. Historial de Estados (Trazabilidad para Seguimiento)
CREATE TABLE IF NOT EXISTS documento_historial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    documento_id INT NOT NULL,
    usuario_id INT NOT NULL,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50) NOT NULL,
    comentarios TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (documento_id) REFERENCES documentos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- 10. Documentos Requeridos por Cliente (Matriz del Semáforo)
CREATE TABLE IF NOT EXISTS cliente_doc_requeridos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    tipo_doc_id INT NOT NULL,
    documento_id INT NULL,
    periodo VARCHAR(20) NOT NULL,
    entregado TINYINT(1) DEFAULT 0,
    fecha_limite_entrega DATE NULL,
    fecha_entrega DATETIME NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_doc_id) REFERENCES tipos_documento(id),
    FOREIGN KEY (documento_id) REFERENCES documentos(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ===================================================
-- DATOS SEMILLA INICIALES (CATALOGOS BASE)
-- ===================================================

INSERT INTO roles (id, nombre, descripcion) VALUES
(1, 'Administrador', 'Acceso total al sistema'),
(2, 'Contador', 'Gestión de documentos y clientes asignados'),
(3, 'Recepcionista', 'Recepción e ingreso de documentos con firma'),
(4, 'Cliente', 'Consulta y seguimiento de documentos propios')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

INSERT INTO empresas (nombre, rfc) VALUES
('DCA Contadores S.C.', 'DCA101010AB1'),
('DCA Asesores y Consultores', 'DAC202020CD2')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

INSERT INTO departamentos (nombre, descripcion) VALUES
('Contabilidad', 'Gestión contable e impuestos'),
('Fiscal', 'Declaraciones y auditoría fiscal'),
('Nóminas', 'Gestión de nóminas y seguridad social'),
('Legal', 'Trámites legales y corporativos')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);

INSERT INTO tipos_documento (nombre, descripcion) VALUES
('Constancia de Situación Fiscal', 'Constancia actualizada emitida por el SAT'),
('Opinión de Cumplimiento', 'Opinión en sentido positivo del SAT'),
('Declaración Mensual', 'Declaración de impuestos mensuales'),
('Firma Electrónica (FIEL)', 'Archivos .cer y .key'),
('Comprobante de Pago', 'Facturas, recibos de pago y vouchers')
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre);
