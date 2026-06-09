-- ============================================================================
-- MÓDULO 2 - UNIDAD 1: DISEÑO DE ESQUEMAS CON DDL Y TIPOS DE DATOS
-- Práctica: Sistema de Gestión de Ventas
-- ============================================================================
-- Propósito: Definir la estructura de tablas para un sistema de ventas
-- usando DDL (CREATE TABLE) y tipos de datos apropiados.
-- ============================================================================

-- ============================================================================
-- TABLA: CLIENTES
-- ============================================================================
-- Esta tabla almacena la información de los clientes del sistema.
-- Se utiliza como tabla de referencia para vincular con futuras transacciones.

CREATE TABLE clientes (
    -- ID único para cada cliente. Se usa INT porque será un identificador
    -- numérico incremental (1, 2, 3...) y no necesita decimales.
    -- Posteriormente, este será la clave primaria (PK).
    id_cliente INT,
    
    -- Nombre completo del cliente. Usamos VARCHAR(100) porque:
    -- - Los nombres raramente exceden 100 caracteres
    -- - VARCHAR es más eficiente que TEXT para campos cortos y predecibles
    -- - Evitamos consumir espacio innecesario en el servidor
    nombre VARCHAR(100),
    
    -- Biografía o notas sobre el cliente. Usamos TEXT porque:
    -- - El contenido puede variar significativamente en longitud
    -- - Un cliente puede tener notas muy detalladas o ninguna
    -- - TEXT no penaliza por espacio no utilizado como sí lo hace VARCHAR
    perfil_bio TEXT,
    
    -- Fecha de registro del cliente. Usamos DATE porque:
    -- - Solo necesitamos la fecha, no la hora exacta
    -- - DATE es más eficiente en almacenamiento que TIMESTAMP
    -- - Permite que herramientas como Power BI reconozcan automáticamente
    --   que es una fecha y apliquen funciones de tiempo
    fecha_registro DATE
);

-- ============================================================================
-- TABLA: PRODUCTOS
-- ============================================================================
-- Esta tabla contiene el catálogo de productos disponibles para la venta.
-- Cada producto tiene propiedades que permiten gestionar inventario y precios.

CREATE TABLE productos (
    -- ID único para cada producto. Usamos INT por las mismas razones
    -- que id_cliente: es un identificador numérico incremental.
    id_producto INT,
    
    -- Descripción del producto. Usamos VARCHAR(255) porque:
    -- - Las descripciones de productos típicamente son concisas
    --   (ej: "Laptop Dell XPS 13", "Mouse inalámbrico")
    -- - 255 caracteres es suficiente para la mayoría de casos
    -- - Es más eficiente que TEXT para búsquedas y ordenamientos
    descripcion VARCHAR(255),
    
    -- Precio del producto. Usamos DECIMAL(10, 2) porque:
    -- - DECIMAL garantiza precisión exacta en operaciones monetarias
    --   (a diferencia de FLOAT que usa aproximaciones)
    -- - 10 dígitos totales permite precios hasta $99,999,999.99
    -- - 2 decimales son el estándar para representar centavos
    -- - NUNCA usaríamos FLOAT o REAL para dinero (causa errores de redondeo)
    precio DECIMAL(10, 2),
    
    -- Estado del producto (activo/inactivo). Usamos INT porque:
    -- - Solo hay dos valores: 1 (activo) o 0 (inactivo)
    -- - INT(1) o TINYINT es más eficiente en almacenamiento
    -- - Permite operaciones lógicas y cálculos (ej: SUM(esta_activo))
    -- - Alternativa: podría usarse VARCHAR(1) con 'S'/'N', pero INT es preferible
    --   para analítica (puedes sumar cuántos productos activos hay)
    esta_activo INT
);

-- ============================================================================
-- NOTAS IMPORTANTES SOBRE EL DISEÑO:
-- ============================================================================
-- 1. Convención de nombres:
--    - Todos los nombres usan snake_case (letras minúsculas + guion bajo)
--    - Sin espacios ni caracteres especiales (excepto guion bajo)
--    - Esto asegura compatibilidad con SQL estándar
--
-- 2. Próximos pasos (en unidades posteriores):
--    - Agregar PRIMARY KEY a id_cliente e id_producto
--    - Agregar FOREIGN KEY para vincular clientes con sus órdenes
--    - Agregar restricciones (CONSTRAINTS) como NOT NULL y UNIQUE
--    - Crear índices para optimizar búsquedas
--
-- 3. Prueba de integridad:
--    - Este script debe ejecutarse sin errores en PostgreSQL o SQL Server
--    - Si hay error de sintaxis, verificar:
--      a) Las comas están correctas (no falta ninguna, ni sobra al final)
--      b) Los nombres de tipos (INT, VARCHAR, DATE, DECIMAL) son válidos
--      c) Los paréntesis están cerrados correctamente
-- ============================================================================
