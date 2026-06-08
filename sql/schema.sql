-- ============================================================
-- NexShop Group S.A. — Base de Datos
-- Archivo: schema.sql
-- Descripcion: CREATE TABLE con tipos, PKs, FKs y restricciones
-- ============================================================

CREATE DATABASE IF NOT EXISTS nexshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nexshop;

-- ============================================================
-- TABLA: sede
-- Motivo: LO PIDE EL CLIENTE.
-- La empresa opera en 4 ubicaciones: almacen central en Valencia
-- y 3 tiendas fisicas (Valencia, Madrid, Barcelona).
-- Unificamos tiendas y almacen en una sola entidad "sede"
-- para reutilizarla en stock, empleados y transferencias.
-- ============================================================
CREATE TABLE sede (
    id_sede       INT             AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100)    NOT NULL,
    tipo          ENUM('tienda_fisica','almacen_central') NOT NULL,
    ciudad        VARCHAR(100)    NOT NULL,
    direccion     VARCHAR(255)    NOT NULL,
    activa        BOOLEAN         NOT NULL DEFAULT TRUE
);

-- ============================================================
-- TABLA: empleado
-- Motivo: LO PIDE EL CLIENTE (email Ana Ferrer).
-- 47 empleados con nombre, DNI, email corporativo,
-- fecha de incorporacion y sede asignada.
-- ============================================================
CREATE TABLE empleado (
    id_empleado         INT          AUTO_INCREMENT PRIMARY KEY,
    nombre              VARCHAR(100) NOT NULL,
    apellidos           VARCHAR(150) NOT NULL,
    dni                 CHAR(9)      NOT NULL UNIQUE,
    email_corporativo   VARCHAR(150) NOT NULL UNIQUE,
    fecha_incorporacion DATE         NOT NULL,
    id_sede             INT          NOT NULL,
    activo              BOOLEAN      NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_sede) REFERENCES sede(id_sede)
);

-- ============================================================
-- TABLA: categoria
-- Motivo: LO PIDE EL CLIENTE.
-- El catalogo se organiza en categorias (ej: Informatica).
-- ============================================================
CREATE TABLE categoria (
    id_categoria INT          AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL UNIQUE
);

-- ============================================================
-- TABLA: subcategoria
-- Motivo: LO PIDE EL CLIENTE.
-- Cada categoria tiene subcategorias (ej: Portatiles).
-- Un producto pertenece a exactamente UNA subcategoria.
-- Usamos dos tablas separadas (no autorreferencia) porque el
-- enunciado solo describe dos niveles y facilita la legibilidad.
-- ============================================================
CREATE TABLE subcategoria (
    id_subcategoria INT          AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    id_categoria    INT          NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    UNIQUE (nombre, id_categoria)
);

-- ============================================================
-- TABLA: producto
-- Motivo: LO PIDE EL CLIENTE.
-- Mas de 2000 referencias con PVP actual y subcategoria unica.
-- El campo pvp refleja el precio vigente; el historico se
-- guarda en historial_precio (tabla separada).
-- ============================================================
CREATE TABLE producto (
    id_producto     INT             AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(200)    NOT NULL,
    descripcion     TEXT,
    pvp             DECIMAL(10,2)   NOT NULL CHECK (pvp >= 0),
    id_subcategoria INT             NOT NULL,
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_subcategoria) REFERENCES subcategoria(id_subcategoria)
);

-- ============================================================
-- TABLA: historial_precio
-- Motivo: LO PIDE EL CLIENTE.
-- El PVP puede variar con el tiempo. Se registra cada cambio
-- con fecha_inicio y fecha_fin (NULL = precio vigente actual).
-- DISTINTO de promociones: aqui es el precio base sin descuento.
-- ============================================================
CREATE TABLE historial_precio (
    id_historial INT           AUTO_INCREMENT PRIMARY KEY,
    id_producto  INT           NOT NULL,
    precio       DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    fecha_inicio DATE          NOT NULL,
    fecha_fin    DATE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ============================================================
-- TABLA: proveedor
-- Motivo: LO PIDE EL CLIENTE.
-- Proveedores con representante comercial de NexShop asignado.
-- ============================================================
CREATE TABLE proveedor (
    id_proveedor              INT          AUTO_INCREMENT PRIMARY KEY,
    nombre                    VARCHAR(200) NOT NULL,
    cif                       VARCHAR(20)  NOT NULL UNIQUE,
    email_contacto            VARCHAR(150),
    telefono                  VARCHAR(20),
    id_empleado_representante INT          NOT NULL,
    activo                    BOOLEAN      NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_empleado_representante) REFERENCES empleado(id_empleado)
);

-- ============================================================
-- TABLA: producto_proveedor
-- Motivo: LO PIDE EL CLIENTE.
-- Relacion N:M entre producto y proveedor. Para cada combinacion
-- se negocia precio de coste y plazo de entrega.
-- Guardamos historico: fecha_fin NULL = condicion vigente.
-- ============================================================
CREATE TABLE producto_proveedor (
    id_producto_proveedor INT           AUTO_INCREMENT PRIMARY KEY,
    id_producto           INT           NOT NULL,
    id_proveedor          INT           NOT NULL,
    precio_coste          DECIMAL(10,2) NOT NULL CHECK (precio_coste >= 0),
    plazo_entrega_dias    INT           NOT NULL CHECK (plazo_entrega_dias > 0),
    fecha_inicio          DATE          NOT NULL,
    fecha_fin             DATE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- ============================================================
-- TABLA: cliente
-- Motivo: LO PIDE EL CLIENTE.
-- Clientes registrados en la plataforma online con datos
-- personales. La fecha_nacimiento se usa para promociones
-- de cumpleanos.
-- ============================================================
CREATE TABLE cliente (
    id_cliente      INT          AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    apellidos       VARCHAR(150) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    fecha_registro  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo          BOOLEAN      NOT NULL DEFAULT TRUE
);

-- ============================================================
-- TABLA: direccion_cliente
-- Motivo: LO PIDE EL CLIENTE.
-- Un cliente puede tener multiples direcciones guardadas
-- (domicilio, trabajo u otras) para elegir al pedir online.
-- ============================================================
CREATE TABLE direccion_cliente (
    id_direccion INT          AUTO_INCREMENT PRIMARY KEY,
    id_cliente   INT          NOT NULL,
    tipo         ENUM('domicilio','trabajo','otra') NOT NULL DEFAULT 'otra',
    calle        VARCHAR(200) NOT NULL,
    numero       VARCHAR(20)  NOT NULL,
    piso         VARCHAR(20),
    codigo_postal VARCHAR(10) NOT NULL,
    ciudad       VARCHAR(100) NOT NULL,
    pais         VARCHAR(100) NOT NULL DEFAULT 'España',
    activa       BOOLEAN      NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- ============================================================
-- TABLA: pedido_online
-- Motivo: LO PIDE EL CLIENTE.
-- Canal online. Cada pedido tiene cliente, direccion de
-- entrega, estado y posible descuento por puntos canjeados.
-- ============================================================
CREATE TABLE pedido_online (
    id_pedido           INT           AUTO_INCREMENT PRIMARY KEY,
    id_cliente          INT           NOT NULL,
    id_direccion_entrega INT          NOT NULL,
    fecha_pedido        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado              ENUM('pendiente','confirmado','en_proceso','enviado','entregado','cancelado')
                        NOT NULL DEFAULT 'pendiente',
    descuento_puntos    DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (descuento_puntos >= 0),
    total               DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_direccion_entrega) REFERENCES direccion_cliente(id_direccion)
);

-- ============================================================
-- TABLA: linea_pedido
-- Motivo: LO PROPONGO YO.
-- Necesaria para registrar que productos y cantidades componen
-- cada pedido. Sin ella no habria detalle del carrito.
-- Guarda el precio_unitario y descuento al momento de la compra
-- para que el historico de precios no afecte registros pasados.
-- ============================================================
CREATE TABLE linea_pedido (
    id_linea_pedido    INT           AUTO_INCREMENT PRIMARY KEY,
    id_pedido          INT           NOT NULL,
    id_producto        INT           NOT NULL,
    cantidad           INT           NOT NULL CHECK (cantidad > 0),
    precio_unitario    DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    descuento_aplicado DECIMAL(5,2)  NOT NULL DEFAULT 0.00
                       CHECK (descuento_aplicado BETWEEN 0 AND 100),
    FOREIGN KEY (id_pedido) REFERENCES pedido_online(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ============================================================
-- TABLA: envio
-- Motivo: LO PIDE EL CLIENTE.
-- Un pedido puede generar VARIOS envios parciales desde
-- distintos almacenes. Cada envio tiene numero de seguimiento,
-- transportista y fecha estimada de entrega.
-- ============================================================
CREATE TABLE envio (
    id_envio               INT          AUTO_INCREMENT PRIMARY KEY,
    id_pedido              INT          NOT NULL,
    id_sede_origen         INT          NOT NULL,
    numero_seguimiento     VARCHAR(100) UNIQUE,
    transportista          VARCHAR(100),
    fecha_estimada_entrega DATE,
    fecha_entrega_real     DATE,
    estado                 ENUM('preparando','en_transito','entregado','fallido')
                           NOT NULL DEFAULT 'preparando',
    FOREIGN KEY (id_pedido) REFERENCES pedido_online(id_pedido),
    FOREIGN KEY (id_sede_origen) REFERENCES sede(id_sede)
);

-- ============================================================
-- TABLA: linea_envio
-- Motivo: LO PROPONGO YO.
-- Necesaria para saber exactamente que lineas de pedido (y que
-- cantidad) van en cada envio parcial. Sin esta tabla no podemos
-- saber que productos ya fueron enviados en un split-shipment.
-- ============================================================
CREATE TABLE linea_envio (
    id_linea_envio  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_envio        INT NOT NULL,
    id_linea_pedido INT NOT NULL,
    cantidad_enviada INT NOT NULL CHECK (cantidad_enviada > 0),
    FOREIGN KEY (id_envio) REFERENCES envio(id_envio),
    FOREIGN KEY (id_linea_pedido) REFERENCES linea_pedido(id_linea_pedido)
);

-- ============================================================
-- TABLA: venta_presencial
-- Motivo: LO PIDE EL CLIENTE.
-- Las ventas en tienda generan un "ticket de venta" distinto
-- al pedido online. id_cliente es nullable: una venta
-- sin cliente registrado se registra igualmente (Laura Pons).
-- Si ese cliente se registra despues, el campo se puede
-- actualizar para vincular el historial (solucion al problema
-- mencionado en la reunion).
-- ============================================================
CREATE TABLE venta_presencial (
    id_venta    INT           AUTO_INCREMENT PRIMARY KEY,
    id_sede     INT           NOT NULL,
    id_empleado INT           NOT NULL,
    id_cliente  INT,                          -- NULL = compra sin cuenta registrada
    fecha_venta DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total       DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (id_sede) REFERENCES sede(id_sede),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- ============================================================
-- TABLA: linea_venta
-- Motivo: LO PROPONGO YO.
-- Detalle de productos y cantidades por ticket de venta
-- presencial. Analogia directa a linea_pedido.
-- ============================================================
CREATE TABLE linea_venta (
    id_linea_venta  INT           AUTO_INCREMENT PRIMARY KEY,
    id_venta        INT           NOT NULL,
    id_producto     INT           NOT NULL,
    cantidad        INT           NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    FOREIGN KEY (id_venta) REFERENCES venta_presencial(id_venta),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ============================================================
-- TABLA: devolucion_presencial
-- Motivo: LO PIDE EL CLIENTE.
-- Devoluciones de compras en tienda fisica, vinculadas al
-- ticket de venta original. Requiere un empleado que la tramite.
-- ============================================================
CREATE TABLE devolucion_presencial (
    id_devolucion  INT          AUTO_INCREMENT PRIMARY KEY,
    id_venta       INT          NOT NULL,
    id_empleado    INT          NOT NULL,
    fecha_devolucion DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo         VARCHAR(255),
    FOREIGN KEY (id_venta) REFERENCES venta_presencial(id_venta),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- ============================================================
-- TABLA: linea_devolucion
-- Motivo: LO PROPONGO YO.
-- Detalle de que productos y cantidades se devuelven.
-- Se referencia a linea_venta para saber exactamente que
-- linea del ticket original se esta devolviendo.
-- ============================================================
CREATE TABLE linea_devolucion (
    id_linea_devolucion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_devolucion       INT NOT NULL,
    id_linea_venta      INT NOT NULL,
    cantidad_devuelta   INT NOT NULL CHECK (cantidad_devuelta > 0),
    FOREIGN KEY (id_devolucion) REFERENCES devolucion_presencial(id_devolucion),
    FOREIGN KEY (id_linea_venta) REFERENCES linea_venta(id_linea_venta)
);

-- ============================================================
-- TABLA: stock
-- Motivo: LO PIDE EL CLIENTE.
-- El stock se controla POR UBICACION: cada tienda y el almacen
-- central tienen su propio nivel de stock por referencia.
-- UNIQUE en (id_producto, id_sede) garantiza una sola fila
-- por combinacion producto-sede.
-- ============================================================
CREATE TABLE stock (
    id_stock    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_sede     INT NOT NULL,
    cantidad    INT NOT NULL DEFAULT 0 CHECK (cantidad >= 0),
    UNIQUE (id_producto, id_sede),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_sede) REFERENCES sede(id_sede)
);

-- ============================================================
-- TABLA: transferencia_stock
-- Motivo: LO PIDE EL CLIENTE.
-- Transferencias internas entre ubicaciones. El CHECK
-- (origen != destino) evita transferencias a si misma.
-- ============================================================
CREATE TABLE transferencia_stock (
    id_transferencia      INT      AUTO_INCREMENT PRIMARY KEY,
    id_producto           INT      NOT NULL,
    id_sede_origen        INT      NOT NULL,
    id_sede_destino       INT      NOT NULL,
    cantidad              INT      NOT NULL CHECK (cantidad > 0),
    fecha                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_empleado_autoriza  INT      NOT NULL,
    CHECK (id_sede_origen <> id_sede_destino),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_sede_origen) REFERENCES sede(id_sede),
    FOREIGN KEY (id_sede_destino) REFERENCES sede(id_sede),
    FOREIGN KEY (id_empleado_autoriza) REFERENCES empleado(id_empleado)
);

-- ============================================================
-- TABLA: promocion
-- Motivo: LO PIDE EL CLIENTE.
-- Marketing lanza promociones con descuento % sobre el PVP
-- durante un rango de fechas. Un mismo producto puede tener
-- varias promociones en distintos momentos (historial completo).
-- DISTINTO de historial_precio: aqui es un descuento temporal
-- sobre el precio base, no un cambio del precio base.
-- ============================================================
CREATE TABLE promocion (
    id_promocion         INT           AUTO_INCREMENT PRIMARY KEY,
    nombre               VARCHAR(200)  NOT NULL,
    id_producto          INT           NOT NULL,
    descuento_porcentaje DECIMAL(5,2)  NOT NULL
                         CHECK (descuento_porcentaje BETWEEN 0.01 AND 100),
    fecha_inicio         DATE          NOT NULL,
    fecha_fin            DATE          NOT NULL,
    CHECK (fecha_fin >= fecha_inicio),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ============================================================
-- TABLA: ticket_incidencia
-- Motivo: LO PIDE EL CLIENTE.
-- Soporte al cliente. Puede o no estar vinculado a un pedido.
-- El agente es un empleado. Si se resuelve, se guarda fecha
-- de cierre y nota de resolucion.
-- ============================================================
CREATE TABLE ticket_incidencia (
    id_ticket           INT          AUTO_INCREMENT PRIMARY KEY,
    id_cliente          INT,                 -- NULL: cliente no registrado
    id_pedido           INT,                 -- NULL: consulta no vinculada a pedido
    id_empleado_agente  INT          NOT NULL,
    asunto              VARCHAR(255) NOT NULL,
    descripcion         TEXT         NOT NULL,
    estado              ENUM('abierto','en_gestion','resuelto') NOT NULL DEFAULT 'abierto',
    fecha_apertura      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre        DATETIME,
    nota_resolucion     TEXT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES pedido_online(id_pedido),
    FOREIGN KEY (id_empleado_agente) REFERENCES empleado(id_empleado)
);

-- ============================================================
-- TABLA: valoracion
-- Motivo: LO PIDE EL CLIENTE (email Ana Ferrer).
-- Clientes registrados puntuan (1-5) y comentan productos
-- que hayan comprado. UNIQUE(id_cliente, id_producto) garantiza
-- una sola valoracion por cliente y producto.
-- El campo 'verificada' distingue compras confirmadas de
-- las antiguas sin compra previa (historico existente).
-- ============================================================
CREATE TABLE valoracion (
    id_valoracion INT          AUTO_INCREMENT PRIMARY KEY,
    id_cliente    INT          NOT NULL,
    id_producto   INT          NOT NULL,
    puntuacion    TINYINT      NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario    TEXT,
    fecha         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verificada    BOOLEAN      NOT NULL DEFAULT FALSE,
    UNIQUE (id_cliente, id_producto),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ============================================================
-- TABLA: movimiento_puntos
-- Motivo: LO PIDE EL CLIENTE (email Ana Ferrer).
-- Historial completo de puntos ganados y canjeados por cliente.
-- El saldo se calcula SIEMPRE desde este historico (SUM ganados
-- - SUM canjeados). NO almacenamos saldo_actual en cliente
-- para evitar inconsistencias (ver memoria, pregunta 4).
-- ============================================================
CREATE TABLE movimiento_puntos (
    id_movimiento INT          AUTO_INCREMENT PRIMARY KEY,
    id_cliente    INT          NOT NULL,
    id_pedido     INT,                 -- NULL: canje manual o ajuste
    tipo          ENUM('ganado','canjeado') NOT NULL,
    puntos        INT          NOT NULL CHECK (puntos > 0),
    fecha         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion   VARCHAR(255),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES pedido_online(id_pedido)
);
