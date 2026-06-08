-- ============================================================
-- NexShop Group S.A. — Base de Datos
-- Archivo: datos.sql
-- Descripcion: INSERT con datos ficticios pero realistas
--              para probar todas las consultas.
-- ============================================================

USE nexshop;

-- ------------------------------------------------------------
-- SEDES
-- ------------------------------------------------------------
INSERT INTO sede (nombre, tipo, ciudad, direccion) VALUES
('Almacen Central Valencia',  'almacen_central', 'Valencia',  'Calle Mayor 1, Nave 3'),
('Tienda NexShop Valencia',   'tienda_fisica',   'Valencia',  'Calle Colón 10, Local 2'),
('Tienda NexShop Madrid',     'tienda_fisica',   'Madrid',    'Gran Vía 45, Local 1'),
('Tienda NexShop Barcelona',  'tienda_fisica',   'Barcelona', 'Passeig de Gràcia 88, Planta Baja');

-- ------------------------------------------------------------
-- EMPLEADOS
-- ------------------------------------------------------------
INSERT INTO empleado (nombre, apellidos, dni, email_corporativo, fecha_incorporacion, id_sede) VALUES
('Carlos',  'García Moreno',    '12345678A', 'c.garcia@nexshop.es',   '2016-03-15', 1),
('María',   'López Fernández',  '23456789B', 'm.lopez@nexshop.es',    '2017-06-01', 2),
('Juan',    'Martínez Ruiz',    '34567890C', 'j.martinez@nexshop.es', '2018-09-10', 2),
('Ana',     'Ferrer Blasco',    '45678901D', 'a.ferrer@nexshop.es',   '2015-11-20', 1),
('David',   'Cano Jiménez',     '56789012E', 'd.cano@nexshop.es',     '2016-01-08', 1),
('Pedro',   'Sánchez Vidal',    '67890123F', 'p.sanchez@nexshop.es',  '2019-02-14', 3),
('Elena',   'Torres Navarro',   '78901234G', 'e.torres@nexshop.es',   '2020-05-03', 4),
('Laura',   'Pons Castelló',    '89012345H', 'l.pons@nexshop.es',     '2017-07-22', 1),
('Sergio',  'Blanco Ortega',    '90123456I', 's.blanco@nexshop.es',   '2015-12-01', 1),
('Beatriz', 'Mora Alonso',      '01234567J', 'b.mora@nexshop.es',     '2021-03-18', 3);

-- ------------------------------------------------------------
-- CATEGORIAS
-- ------------------------------------------------------------
INSERT INTO categoria (nombre) VALUES
('Informática'),
('Telefonía'),
('Gaming'),
('Hogar y Audio');

-- ------------------------------------------------------------
-- SUBCATEGORIAS
-- ------------------------------------------------------------
INSERT INTO subcategoria (nombre, id_categoria) VALUES
('Portátiles',   1),
('Monitores',    1),
('Periféricos',  1),
('Smartphones',  2),
('Tablets',      2),
('Consolas',     3),
('Videojuegos',  3),
('Televisores',  4),
('Audio',        4);

-- ------------------------------------------------------------
-- PRODUCTOS
-- ------------------------------------------------------------
INSERT INTO producto (nombre, descripcion, pvp, id_subcategoria) VALUES
('Portátil Acer Aspire 5 A515',      'Intel i5 12ª gen, 16GB RAM, 512GB SSD, pantalla 15.6" FHD',  649.99, 1),
('Portátil HP Pavilion Gaming 15',   'Intel i7, RTX 3060, 16GB RAM, 512GB SSD',                    899.99, 1),
('Portátil Lenovo IdeaPad 3',        'AMD Ryzen 5, 8GB RAM, 256GB SSD, pantalla 15.6"',             469.99, 1),
('Monitor Samsung 27" IPS FHD',      'Resolución 1920x1080, 75Hz, panel IPS, HDMI/DP',             259.99, 2),
('Monitor LG UltraWide 34" QHD',     'Resolución 3440x1440, 100Hz, IPS Nano, USB-C',               549.99, 2),
('iPhone 15 128GB',                  'A16 Bionic, cámara 48MP, Dynamic Island, USB-C',             999.99, 4),
('Samsung Galaxy S24 256GB',         'Snapdragon 8 Gen 3, cámara 50MP, 6.2" AMOLED',              849.99, 4),
('iPad Air M1 64GB WiFi',            'Chip Apple M1, pantalla 10.9" Liquid Retina, USB-C',         749.99, 5),
('PlayStation 5 Disc Edition',       'Consola PS5 con lector Blu-ray, SSD 825GB, DualSense',       499.99, 6),
('Xbox Series X 1TB',                'Consola Microsoft, SSD 1TB, 4K 120fps, Xbox Game Pass',     499.99, 6),
('FIFA 25 PS5',                      'Edición estándar para PlayStation 5, EA Sports',              69.99, 7),
('Spider-Man 2 PS5',                 'Exclusivo PlayStation 5, edición estándar',                   59.99, 7),
('Samsung QLED TV 55" 4K',           'Resolución 4K UHD, Quantum HDR, Smart TV Tizen, 120Hz',     699.99, 8),
('Sonos Era 300 Speaker',            'Altavoz inalámbrico Hi-Fi con Dolby Atmos',                  449.99, 9),
('AirPods Pro 2ª Generación',        'Cancelación activa de ruido, carga MagSafe, USB-C',          279.99, 9);

-- ------------------------------------------------------------
-- HISTORIAL DE PRECIOS
-- ------------------------------------------------------------
INSERT INTO historial_precio (id_producto, precio, fecha_inicio, fecha_fin) VALUES
(1, 699.99, '2023-01-01', '2023-06-30'),
(1, 679.99, '2023-07-01', '2023-12-31'),
(1, 649.99, '2024-01-01', NULL),
(6, 1099.99, '2023-01-01', '2023-09-14'),
(6, 999.99,  '2023-09-15', NULL),
(9, 549.99, '2022-01-01', '2022-11-30'),
(9, 499.99, '2022-12-01', NULL);

-- ------------------------------------------------------------
-- PROVEEDORES
-- ------------------------------------------------------------
INSERT INTO proveedor (nombre, cif, email_contacto, telefono, id_empleado_representante) VALUES
('TechDistrib S.L.',              'A12345678', 'ventas@techdistrib.es',   '961234567', 4),
('InfoSuministros S.A.',          'B23456789', 'pedidos@infosum.es',      '912345678', 1),
('GamingPro Distribución S.L.',   'C34567890', 'stock@gamingpro.es',      '932345678', 5),
('AudioVisual Distribución S.A.', 'D45678901', 'comercial@avdist.es',     '963456789', 4);

-- ------------------------------------------------------------
-- PRODUCTO_PROVEEDOR (con historico de condiciones)
-- ------------------------------------------------------------
INSERT INTO producto_proveedor (id_producto, id_proveedor, precio_coste, plazo_entrega_dias, fecha_inicio, fecha_fin) VALUES
(1,  1, 420.00, 5,  '2023-01-01', '2023-12-31'),
(1,  1, 399.00, 4,  '2024-01-01', NULL),
(1,  2, 410.00, 7,  '2023-06-01', NULL),
(2,  1, 620.00, 5,  '2023-01-01', NULL),
(3,  2, 300.00, 6,  '2023-01-01', NULL),
(6,  1, 780.00, 3,  '2023-01-01', NULL),
(7,  1, 650.00, 4,  '2023-01-01', NULL),
(9,  3, 380.00, 5,  '2022-01-01', NULL),
(10, 3, 380.00, 5,  '2022-01-01', NULL),
(13, 4, 480.00, 7,  '2023-01-01', NULL),
(14, 4, 310.00, 10, '2023-01-01', NULL),
(15, 1, 180.00, 3,  '2023-01-01', NULL);

-- ------------------------------------------------------------
-- CLIENTES
-- ------------------------------------------------------------
INSERT INTO cliente (nombre, apellidos, email, contrasena_hash, fecha_nacimiento, fecha_registro) VALUES
('Ana',       'García Martínez',  'ana.garcia@email.com',       '$2b$10$abc123hashed1', '1990-03-15', '2023-02-10 10:20:00'),
('Roberto',   'Jiménez Sáez',     'roberto.j@gmail.com',        '$2b$10$abc123hashed2', '1985-07-22', '2023-04-05 16:45:00'),
('Carmen',    'López Díaz',       'carmen.lopez@hotmail.com',   '$2b$10$abc123hashed3', '1992-11-08', '2023-05-18 09:30:00'),
('Alejandro', 'Ruiz Torres',      'alejandro.r@email.com',      '$2b$10$abc123hashed4', '1988-01-30', '2023-07-01 12:00:00'),
('Beatriz',   'Fernández Gil',    'beatriz.f@gmail.com',        '$2b$10$abc123hashed5', '1995-05-20', '2023-08-14 18:15:00'),
('Miguel',    'Navarro Peña',     'miguel.n@email.com',         '$2b$10$abc123hashed6', '1983-09-03', '2024-01-20 08:00:00'),
('Adriana',   'Santos Blanco',    'adriana.s@email.com',        '$2b$10$abc123hashed7', '1997-12-25', '2024-03-11 11:30:00'),
('Fernando',  'Castro Méndez',    'fernando.c@email.com',       '$2b$10$abc123hashed8', '1979-06-14', '2024-04-02 14:00:00');

-- ------------------------------------------------------------
-- DIRECCIONES DE CLIENTE
-- ------------------------------------------------------------
INSERT INTO direccion_cliente (id_cliente, tipo, calle, numero, piso, codigo_postal, ciudad, pais) VALUES
(1, 'domicilio', 'Calle Ruzafa',        '12', '3B', '46002', 'Valencia',   'España'),
(1, 'trabajo',   'Avenida del Puerto',  '25', NULL,  '46023', 'Valencia',   'España'),
(2, 'domicilio', 'Calle Alcalá',        '78', '2A', '28009', 'Madrid',     'España'),
(3, 'domicilio', 'Carrer de Gràcia',    '45', '1A', '08012', 'Barcelona',  'España'),
(4, 'domicilio', 'Calle Alfonso I',     '33', '4C', '50003', 'Zaragoza',   'España'),
(5, 'domicilio', 'Gran Vía Fernando',   '8',  '2B', '46008', 'Valencia',   'España'),
(5, 'trabajo',   'Parque Tecnológico',  '1',  NULL,  '46980', 'Paterna',    'España'),
(6, 'domicilio', 'Calle Serrano',       '92', '5D', '28006', 'Madrid',     'España'),
(6, 'trabajo',   'Paseo de la Habana',  '14', NULL,  '28036', 'Madrid',     'España'),
(7, 'domicilio', 'Avenida de América',  '20', '8F', '28028', 'Madrid',     'España'),
(8, 'domicilio', 'Calle Fuencarral',    '60', '1A', '28004', 'Madrid',     'España');

-- ------------------------------------------------------------
-- PEDIDOS ONLINE
-- ------------------------------------------------------------
INSERT INTO pedido_online (id_cliente, id_direccion_entrega, fecha_pedido, estado, descuento_puntos, total) VALUES
(1, 1,  '2024-01-15 10:30:00', 'entregado',   0.00,   649.99),
(2, 3,  '2024-02-03 14:00:00', 'entregado',   5.00,   944.99),
(3, 4,  '2024-02-20 09:15:00', 'entregado',   0.00,   499.99),
(1, 1,  '2024-03-10 16:45:00', 'entregado',  10.00,   269.98),
(4, 5,  '2024-04-01 11:00:00', 'enviado',     0.00,   999.99),
(5, 6,  '2024-04-22 18:30:00', 'en_proceso',  0.00,  1349.98),
(6, 8,  '2024-05-05 08:00:00', 'confirmado',  0.00,   449.99),
(2, 3,  '2024-05-18 13:20:00', 'pendiente',   0.00,   279.99),
(7, 10, '2024-06-01 20:00:00', 'pendiente',   0.00,   849.99),
(8, 11, '2024-06-02 09:45:00', 'cancelado',   0.00,   699.99);

-- ------------------------------------------------------------
-- LINEAS DE PEDIDO
-- ------------------------------------------------------------
INSERT INTO linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento_aplicado) VALUES
(1,  1,  1, 649.99,  0.00),
(2,  2,  1, 899.99,  0.00),
(2,  11, 1,  59.99,  0.00),  -- Note: precio + descuento_puntos = 944.99 aprox
(3,  9,  1, 499.99,  0.00),
(4,  4,  1, 259.99,  0.00),
(4,  11, 1,  69.99,  0.00),
(5,  6,  1, 999.99,  0.00),
(6,  7,  1, 849.99,  0.00),
(6,  15, 1, 279.99, 10.00),  -- 10% descuento por promocion
(7,  14, 1, 449.99,  0.00),
(8,  15, 1, 279.99,  0.00),
(9,  7,  1, 849.99,  0.00),
(10, 13, 1, 699.99,  0.00);

-- ------------------------------------------------------------
-- ENVIOS
-- ------------------------------------------------------------
INSERT INTO envio (id_pedido, id_sede_origen, numero_seguimiento, transportista, fecha_estimada_entrega, fecha_entrega_real, estado) VALUES
(1, 1, 'SEUR-2024-0001', 'SEUR',    '2024-01-18', '2024-01-17', 'entregado'),
(2, 1, 'MRW-2024-0002',  'MRW',     '2024-02-06', '2024-02-07', 'entregado'),
(3, 1, 'SEUR-2024-0003', 'SEUR',    '2024-02-23', '2024-02-22', 'entregado'),
(4, 2, 'CORREOS-0004',   'Correos', '2024-03-13', '2024-03-14', 'entregado'),
-- Pedido 5: dos envios parciales (split shipment)
(5, 1, 'MRW-2024-0005A', 'MRW',     '2024-04-04', NULL,         'en_transito'),
(5, 3, 'MRW-2024-0005B', 'MRW',     '2024-04-05', NULL,         'en_transito'),
(6, 1, 'SEUR-2024-0007', 'SEUR',    '2024-04-25', NULL,         'preparando'),
(7, 1, 'DHL-2024-0008',  'DHL',     '2024-05-08', NULL,         'preparando'),
(9, 3, 'MRW-2024-0010',  'MRW',     '2024-06-05', NULL,         'preparando');

-- ------------------------------------------------------------
-- LINEAS DE ENVIO
-- ------------------------------------------------------------
INSERT INTO linea_envio (id_envio, id_linea_pedido, cantidad_enviada) VALUES
(1, 1, 1),   -- Envio 1: linea 1 del pedido 1
(2, 2, 1),   -- Envio 2: portatil HP del pedido 2
(2, 3, 1),   -- Envio 2: FIFA del pedido 2
(3, 4, 1),   -- Envio 3: PS5 pedido 3
(4, 5, 1),   -- Envio 4: monitor pedido 4
(4, 6, 1),   -- Envio 4: FIFA pedido 4
(5, 7, 1),   -- Envio 5A: iPhone desde almacen central (split)
(7, 8, 1),   -- Envio 7: Samsung Galaxy
(7, 9, 1),   -- Envio 7: AirPods con descuento
(8, 10, 1),  -- Envio 8: Sonos
(9, 12, 1);  -- Envio 9: Samsung Galaxy para pedido 9

-- ------------------------------------------------------------
-- VENTAS PRESENCIALES
-- ------------------------------------------------------------
INSERT INTO venta_presencial (id_sede, id_empleado, id_cliente, fecha_venta, total) VALUES
(2, 3,    1, '2024-01-20 11:00:00', 499.99),   -- Cliente registrado (Ana)
(2, 3,    NULL, '2024-02-10 17:30:00', 69.99), -- Cliente anonimo
(3, 6,    2, '2024-03-05 12:00:00', 279.99),   -- Roberto en Madrid
(4, 7,    NULL, '2024-03-22 16:00:00', 849.99),-- Anonimo en Barcelona
(3, 10,   5, '2024-04-15 10:30:00', 59.99);    -- Beatriz en Madrid

-- ------------------------------------------------------------
-- LINEAS DE VENTA
-- ------------------------------------------------------------
INSERT INTO linea_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(1, 9,  1, 499.99),  -- PS5 en tienda Valencia
(2, 11, 1,  69.99),  -- FIFA en tienda Valencia (cliente anonimo)
(3, 15, 1, 279.99),  -- AirPods en tienda Madrid
(4, 7,  1, 849.99),  -- Galaxy S24 en tienda Barcelona (anonimo)
(5, 12, 1,  59.99);  -- Spider-Man en tienda Madrid

-- ------------------------------------------------------------
-- DEVOLUCIONES PRESENCIALES
-- ------------------------------------------------------------
INSERT INTO devolucion_presencial (id_venta, id_empleado, fecha_devolucion, motivo) VALUES
(2, 3, '2024-02-17 10:00:00', 'Producto defectuoso: pantalla con rayas');

INSERT INTO linea_devolucion (id_devolucion, id_linea_venta, cantidad_devuelta) VALUES
(1, 2, 1);

-- ------------------------------------------------------------
-- STOCK (por producto y sede)
-- ------------------------------------------------------------
INSERT INTO stock (id_producto, id_sede, cantidad) VALUES
-- Almacen central (1)
(1,  1, 45), (2,  1, 20), (3,  1, 30), (4,  1, 25), (5,  1, 10),
(6,  1, 15), (7,  1, 18), (8,  1, 12), (9,  1, 22), (10, 1, 20),
(11, 1, 60), (12, 1, 50), (13, 1, 14), (14, 1,  8), (15, 1, 35),
-- Tienda Valencia (2)
(1,  2,  5), (3,  2,  8), (4,  2,  4), (6,  2,  3),
(9,  2,  2), (11, 2, 10), (12, 2,  8), (15, 2,  6),
-- Tienda Madrid (3)
(2,  3,  3), (4,  3,  6), (7,  3,  5), (9,  3,  3),
(10, 3,  4), (13, 3,  2), (15, 3,  4),
-- Tienda Barcelona (4)
(1,  4,  4), (5,  4,  3), (6,  4,  2), (7,  4,  6),
(8,  4,  5), (14, 4,  3), (15, 4,  3);

-- ------------------------------------------------------------
-- TRANSFERENCIAS DE STOCK
-- ------------------------------------------------------------
INSERT INTO transferencia_stock (id_producto, id_sede_origen, id_sede_destino, cantidad, fecha, id_empleado_autoriza) VALUES
(9,  1, 2, 5, '2024-01-10 09:00:00', 5),  -- PS5: almacen a Valencia
(7,  1, 4, 3, '2024-02-15 14:00:00', 5),  -- Galaxy: almacen a Barcelona
(15, 1, 3, 4, '2024-03-20 11:30:00', 1),  -- AirPods: almacen a Madrid
(4,  2, 3, 2, '2024-04-05 10:00:00', 2);  -- Monitor: Valencia a Madrid

-- ------------------------------------------------------------
-- PROMOCIONES
-- ------------------------------------------------------------
INSERT INTO promocion (nombre, id_producto, descuento_porcentaje, fecha_inicio, fecha_fin) VALUES
('Black Friday 2023 - Portatiles',   1,  20.00, '2023-11-24', '2023-11-27'),
('Rebajas Enero 2024 - Portatiles',  1,  10.00, '2024-01-07', '2024-01-31'),
('Rebajas Enero 2024 - Gaming',      9,  15.00, '2024-01-07', '2024-01-31'),
('Promo Verano - Audio',            15,  10.00, '2024-06-01', '2024-08-31'),
('Black Friday 2023 - Samsung TV',  13,  25.00, '2023-11-24', '2023-11-27'),
('Oferta PS5 Bundle',                9,   8.00, '2024-04-01', '2024-04-30'),
('Rebajas Enero 2024 - Monitores',   4,  12.00, '2024-01-07', '2024-01-31');

-- ------------------------------------------------------------
-- TICKETS DE INCIDENCIA
-- ------------------------------------------------------------
INSERT INTO ticket_incidencia (id_cliente, id_pedido, id_empleado_agente, asunto, descripcion, estado, fecha_apertura, fecha_cierre, nota_resolucion) VALUES
(1, 1,    8, 'Retraso en la entrega',
   'Mi pedido debía llegar el día 18 pero aún no ha llegado.',
   'resuelto', '2024-01-19 09:00:00', '2024-01-19 16:30:00',
   'Confirmado con SEUR: entrega realizada el 17/01. Cliente confirmó recepción.'),
(2, 2,    8, 'Producto llegó dañado',
   'El portátil HP llegó con la pantalla rajada. Quiero devolución o cambio.',
   'en_gestion', '2024-02-08 11:00:00', NULL, NULL),
(3, NULL, 8, 'Consulta sobre política de devoluciones',
   'Quiero saber cuántos días tengo para devolver un producto comprado online.',
   'resuelto', '2024-02-25 10:30:00', '2024-02-25 11:00:00',
   'Informada de política: 30 días desde recepción para devoluciones online.'),
(NULL, NULL, 8, 'Pregunta sobre disponibilidad iPhone 15',
   'Quiero saber si tienen iPhone 15 en la tienda de Madrid.',
   'resuelto', '2024-03-01 14:00:00', '2024-03-01 14:30:00',
   'Confirmado stock disponible en tienda Madrid. Cliente asistirá en persona.');

-- ------------------------------------------------------------
-- VALORACIONES
-- ------------------------------------------------------------
INSERT INTO valoracion (id_cliente, id_producto, puntuacion, comentario, fecha, verificada) VALUES
(1, 1,  5, 'Excelente portátil, muy rápido y con gran batería. Lo recomiendo.',                          '2024-01-25 10:00:00', TRUE),
(2, 2,  4, 'Muy buena máquina para gaming. La pantalla es espectacular.',                               '2024-02-15 17:00:00', TRUE),
(3, 9,  5, 'La PS5 es una pasada. Los gráficos son increíbles.',                                        '2024-03-05 20:00:00', TRUE),
(1, 4,  4, 'Buen monitor para el precio. Los colores son precisos.',                                    '2024-03-20 12:00:00', TRUE),
(5, 7,  3, 'El Galaxy S24 está bien pero esperaba más duración de batería.',                            '2024-04-20 09:00:00', FALSE),  -- Sin compra verificada (historico antiguo)
(4, 6,  5, 'El iPhone 15 es simplemente perfecto. La cámara es increíble.',                            '2024-04-10 18:30:00', FALSE),
(2, 15, 4, 'Los AirPods Pro tienen una cancelación de ruido excepcional.',                              '2024-05-25 11:00:00', TRUE),
(6, 14, 5, 'El Sonos Era 300 llena la habitación de sonido. Vale cada euro.',                           '2024-05-20 14:00:00', TRUE);

-- ------------------------------------------------------------
-- MOVIMIENTOS DE PUNTOS
-- ------------------------------------------------------------
-- Regla: 1€ = 10 puntos / 100 puntos = 1€ descuento

-- Ana García (cliente 1)
INSERT INTO movimiento_puntos (id_cliente, id_pedido, tipo, puntos, fecha, descripcion) VALUES
(1, 1, 'ganado',   6499, '2024-01-15 10:30:00', 'Puntos por pedido #1 (649.99€)'),
(1, 4, 'ganado',   2699, '2024-03-10 16:45:00', 'Puntos por pedido #4 (269.98€)'),
(1, 4, 'canjeado', 1000, '2024-03-10 16:44:00', 'Canje 1000 pts = 10€ descuento pedido #4'),
-- Roberto Jiménez (cliente 2)
(2, 2, 'ganado',   9499, '2024-02-03 14:00:00', 'Puntos por pedido #2 (949.99€)'),
(2, 8, 'ganado',   2799, '2024-05-18 13:20:00', 'Puntos por pedido #8 (279.99€)'),
(2, 2, 'canjeado',  500, '2024-02-03 13:59:00', 'Canje 500 pts = 5€ descuento pedido #2'),
-- Carmen López (cliente 3)
(3, 3, 'ganado',   4999, '2024-02-20 09:15:00', 'Puntos por pedido #3 (499.99€)'),
-- Alejandro Ruiz (cliente 4)
(4, 5, 'ganado',   9999, '2024-04-01 11:00:00', 'Puntos por pedido #5 (999.99€)'),
-- Beatriz Fernández (cliente 5)
(5, 6, 'ganado',  13499, '2024-04-22 18:30:00', 'Puntos por pedido #6 (1349.98€)'),
-- Miguel Navarro (cliente 6)
(6, 7, 'ganado',   4499, '2024-05-05 08:00:00', 'Puntos por pedido #7 (449.99€)');
