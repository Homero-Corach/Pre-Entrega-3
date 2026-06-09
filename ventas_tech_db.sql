-- =============================================================================
-- SCRIPT SQL - VENTAS_TECH_DB
-- Base de Datos de Ventas de Tecnología - Modelo Relacional Normalizado (3NF)
-- =============================================================================

-- SECCIÓN 1: ELIMINACIÓN DE TABLAS EXISTENTES (Respetando dependencias)
-- =============================================================================
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- =============================================================================
-- SECCIÓN 2: DEFINICIÓN DEL ESQUEMA (DDL - Data Definition Language)
-- =============================================================================

-- Tabla: CATEGORÍAS (Dimensión)
-- Descripción: Almacena las categorías de productos de tecnología
-- Relaciones: 1 categoría -> N productos
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

-- Tabla: CLIENTES (Dimensión)
-- Descripción: Registra la información de los clientes
-- Relaciones: 1 cliente -> N ventas
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);

-- Tabla: PRODUCTOS (Dimensión)
-- Descripción: Catálogo de productos disponibles
-- Relaciones: Muchos productos por categoría, múltiples ventas por producto
-- Constraints: FK a categorías, precios con precisión monetaria
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla: VENTAS (Tabla de Hechos)
-- Descripción: Registra todas las transacciones de venta
-- Relaciones: Conecta clientes, productos y categorías
-- Constraints: FK a clientes y productos (integridad referencial)
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =============================================================================
-- SECCIÓN 3: CARGA INICIAL DE DATOS (DML - Data Manipulation Language)
-- =============================================================================

-- INSERCIÓN DE CATEGORÍAS (4 registros)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO categorias (nombre_categoria, descripcion) VALUES 
    ('Computación', 'Laptops, PCs y monitores'),
    ('Accesorios', 'Periféricos y complementos'),
    ('Audio', 'Auriculares y parlantes'),
    ('Almacenamiento', 'Discos y memorias');

-- INSERCIÓN DE CLIENTES (5 registros)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO clientes (nombre, email, ciudad, fecha_registro) VALUES 
    ('María López', 'maria@mail.com', 'Buenos Aires', '2024-01-05'),
    ('Carlos Ruiz', 'carlos@mail.com', 'Córdoba', '2024-01-10'),
    ('Ana Gómez', 'ana@mail.com', 'Rosario', '2024-02-01'),
    ('Pedro Sanz', 'pedro@mail.com', 'Mendoza', '2024-02-15'),
    ('Laura Torres', 'laura@mail.com', 'Tucumán', '2024-03-01');

-- INSERCIÓN DE PRODUCTOS (6 registros)
-- Distribuidos en las 4 categorías
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO productos (nombre_producto, id_categoria, precio, stock, activo) VALUES 
    ('Laptop Pro 15', 1, 1200.00, 15, 1),
    ('Mouse Inalámbrico', 2, 28.00, 80, 1),
    ('Monitor 4K 27"', 1, 450.00, 12, 1),
    ('Auriculares BT Pro', 3, 120.00, 35, 1),
    ('SSD Externo 1TB', 4, 130.00, 18, 1),
    ('Teclado Mecánico', 2, 95.00, 40, 1);

-- INSERCIÓN DE VENTAS (10 registros)
-- ─────────────────────────────────────────────────────────────────────────
INSERT INTO ventas (id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES 
    (1, 1, 2, 1200.00, '2024-03-05'),
    (2, 2, 5, 28.00, '2024-03-06'),
    (3, 3, 1, 450.00, '2024-03-07'),
    (1, 4, 2, 120.00, '2024-03-08'),
    (4, 5, 3, 130.00, '2024-03-10'),
    (2, 6, 4, 95.00, '2024-03-11'),
    (5, 1, 1, 1200.00, '2024-03-12'),
    (3, 2, 8, 28.00, '2024-03-13'),
    (4, 4, 1, 120.00, '2024-03-14'),
    (5, 3, 2, 450.00, '2024-03-15');

-- =============================================================================
-- VALIDACIÓN E INTEGRIDAD
-- =============================================================================

-- Consulta de validación: Ver todas las ventas con JOIN
-- Verifica que la integridad referencial funciona correctamente
SELECT 
    v.id_venta,
    c.nombre AS cliente,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    v.fecha_venta
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Verificar total de registros por tabla
SELECT 
    'categorias' AS tabla,
    COUNT(*) AS registros
FROM categorias
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas;

-- Análisis de ventas por categoría
SELECT 
    cat.nombre_categoria,
    COUNT(v.id_venta) AS cantidad_ventas,
    SUM(v.cantidad * v.precio_unitario) AS total_ingresos
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
JOIN categorias cat ON p.id_categoria = cat.id_categoria
GROUP BY cat.nombre_categoria
ORDER BY total_ingresos DESC;
