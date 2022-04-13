CREATE DATABASE c_cliente;

\c c_cliente;

-- 1. Cargar el respaldo de la base de datos unidad2.sql desde fuera de PSQL.
psql -U postgres -d c_cliente -f unidad2.sql

-- 2. El cliente usuario01 ha realizado la siguiente compra:
-- ● producto: producto9
-- ● cantidad: 5
-- ● fecha: fecha del sistema
-- Transaccion realizada con fecha 2022-02-09

BEGIN;
INSERT INTO compra (cliente_id, fecha) VALUES (1, NOW());
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (9, (SELECT MAX(id) FROM compra), 5);
UPDATE producto SET stock = stock - 5 WHERE id = 9;
COMMIT;


SELECT cl.nombre, co.fecha, dc.cantidad, p.descripcion, p.stock
FROM cliente cl
JOIN compra co ON cl.id = co.cliente_id
JOIN detalle_compra dc ON co.id = dc.compra_id
JOIN producto p ON dc.producto_id = p.id
WHERE co.cliente_id = 1
ORDER BY co.fecha DESC
LIMIT 1;


-- 3. El cliente usuario02 ha realizado la siguiente compra:
-- ● producto: producto1, producto 2, producto 8
-- ● cantidad: 3 de cada producto
-- ● fecha: fecha del sistema


-- Consulta antes de Transacción.
SELECT * FROM producto WHERE id IN (1,2,8);

BEGIN;
INSERT INTO compra (cliente_id, fecha) VALUES (2, NOW());
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (1, (SELECT MAX(id) FROM compra), 3);
UPDATE producto SET stock = stock - 3 WHERE id = 1;

INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (2, (SELECT MAX(id) FROM compra), 3);
UPDATE producto SET stock = stock - 3 WHERE id = 2;

INSERT INTO detalle_compra (producto_id, compra_id, cantidad) VALUES (8, (SELECT MAX(id) FROM compra), 3);
UPDATE producto SET stock = stock - 3 WHERE id = 8;
COMMIT;

-- Consulta después de Transacción.
SELECT * FROM producto WHERE id IN (1,2,8);


-- 4. Realizar las siguientes consultas:
-- a. Deshabilitar el AUTOCOMMIT
\echo :AUTOCOMMIT
\set AUTOCOMMIT off

-- b. Insertar un nuevo cliente
INSERT INTO cliente(nombre, email) VALUES ('Ramoncito Gómecito', 'ramoncito@gomecito.cl');
-- c. Confirmar que fue agregado en la tabla cliente
SELECT * FROM cliente;

-- d. Realizar un ROLLBACK
ROLLBACK;
-- e. Confirmar que se restauró la información, sin considerar la inserción del punto b
SELECT * FROM cliente;

-- f. Habilitar de nuevo el AUTOCOMMIT
\set AUTOCOMMIT on
\echo :AUTOCOMMIT
