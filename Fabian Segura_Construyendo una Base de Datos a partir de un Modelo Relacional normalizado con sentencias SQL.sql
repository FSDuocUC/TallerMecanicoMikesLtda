/* =============================================================================
ASIGNATURA: Modelamiento de Bases de Datos - Semana 8
PROYECTO: Construcción Base de Datos Mikes Ltda.
AUTOR: Fabián Segura
============================================================================= */
-- =============================================================================
-- CASO 1: IMPLEMENTACIÓN DEL MODELO RELACIONAL (DDL)
-- Creado secuencialmente desde las tablas fuertes (independientes) a débiles.
-- =============================================================================
CREATE TABLE pais (
id_pais   NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 9 INCREMENT BY 3),
nom_pais  VARCHAR2(30) NOT NULL,
CONSTRAINT pais_pk PRIMARY KEY (id_pais)
);
CREATE TABLE ciudad (
id_ciudad  NUMBER(3) NOT NULL,
nom_ciudad VARCHAR2(30) NOT NULL,
cod_pais   NUMBER(3) NOT NULL,
CONSTRAINT ciudad_pk PRIMARY KEY (id_ciudad),
CONSTRAINT ciudad_fk_pais FOREIGN KEY (cod_pais) REFERENCES pais (id_pais)
);
CREATE TABLE sucursal (
id_sucursal   CHAR(3) NOT NULL,
nom_sucursal  VARCHAR2(20) NOT NULL,
calle         VARCHAR2(20) NOT NULL,
num_calle     NUMBER(4) NOT NULL,
cod_ciudad    NUMBER(3) NOT NULL,
CONSTRAINT sucursal_pk PRIMARY KEY (id_sucursal),
CONSTRAINT sucursal_fk_ciudad FOREIGN KEY (cod_ciudad) REFERENCES ciudad (id_ciudad)
);
CREATE TABLE servicio (
id_servicio  NUMBER(3) NOT NULL,
descripcion  VARCHAR2(100) NOT NULL,
costo        NUMBER(7) NOT NULL,
CONSTRAINT servicio_pk PRIMARY KEY (id_servicio)
);
CREATE TABLE mecanico (
cod_mechanico    NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 460 INCREMENT BY 7),
pnombre          VARCHAR2(20) NOT NULL,
snombre          VARCHAR2(20),
apaterno         VARCHAR2(20) NOT NULL,
amaterno         VARCHAR2(20) NOT NULL,
bono_jefatura    NUMBER(10),
sueldo           NUMBER(10) NOT NULL,
monto_impuestos  NUMBER(10) NOT NULL,
cod_supervisor   NUMBER(5),
CONSTRAINT mecanico_pk PRIMARY KEY (cod_mechanico),
CONSTRAINT mecanico_fk_mecanico FOREIGN KEY (cod_supervisor) REFERENCES mecanico (cod_mechanico)
);
CREATE TABLE cliente (
rut       NUMBER(8) NOT NULL,
dv        CHAR(1) NOT NULL,
pnombre   VARCHAR2(20) NOT NULL,
snombre   VARCHAR2(20),
apaterno  VARCHAR2(20) NOT NULL,
amaterno  VARCHAR2(20) NOT NULL,
telefono  VARCHAR2(12) NOT NULL,
email     VARCHAR2(40),
tipo_cli  CHAR(1) NOT NULL,
CONSTRAINT cliente_pk PRIMARY KEY (rut)
);
CREATE TABLE estandar (
cl_rut            NUMBER(8) NOT NULL,
puntaje_fidelidad NUMBER(10) NOT NULL,
CONSTRAINT normal_pk PRIMARY KEY (cl_rut),
CONSTRAINT normal_fk_cliente FOREIGN KEY (cl_rut) REFERENCES cliente (rut)
);
CREATE TABLE premium (
cl_rut         NUMBER(8) NOT NULL,
pesos_clientes NUMBER(10) NOT NULL,
monto_credito  NUMBER(10) NOT NULL,
CONSTRAINT premium_pk PRIMARY KEY (cl_rut),
CONSTRAINT premium_fk_cliente FOREIGN KEY (cl_rut) REFERENCES cliente (rut)
);
CREATE TABLE tipo_automovil (
id_tipo     CHAR(3) NOT NULL,
descripcion VARCHAR2(20) NOT NULL,
CONSTRAINT tipo_automovil_pk PRIMARY KEY (id_tipo)
);
CREATE TABLE modelo (
id_modelo   NUMBER(5) NOT NULL,
marca_id    NUMBER(2) NOT NULL,
descripcion VARCHAR2(20) NOT NULL,
CONSTRAINT modelo_pk PRIMARY KEY (id_modelo, marca_id)
);
CREATE TABLE marca (
id_marca    NUMBER(2) NOT NULL,
descripcion VARCHAR2(20) NOT NULL,
CONSTRAINT marca_pk PRIMARY KEY (id_marca)
);
ALTER TABLE modelo ADD CONSTRAINT modelo_fk_marca FOREIGN KEY (marca_id) REFERENCES marca (id_marca);
CREATE TABLE automovil (
patente        CHAR(8) NOT NULL,
annio          NUMBER(4) NOT NULL,
cant_puertas   NUMBER(1) NOT NULL,
km             NUMBER(6) NOT NULL,
color          VARCHAR2(30) NOT NULL,
cod_tipo_auto  CHAR(3) NOT NULL,
cod_modelo     NUMBER(5) NOT NULL,
cod_marca      NUMBER(2) NOT NULL,
cl_rut         NUMBER(8) NOT NULL,
CONSTRAINT automovil_pk PRIMARY KEY (patente),
CONSTRAINT automovil_fk_cliente FOREIGN KEY (cl_rut) REFERENCES cliente (rut),
CONSTRAINT automovil_fk_modelo FOREIGN KEY (cod_modelo, cod_marca) REFERENCES modelo (id_modelo, marca_id),
CONSTRAINT automovil_fk_tipo FOREIGN KEY (cod_tipo_auto) REFERENCES tipo_automovil (id_tipo)
);
CREATE TABLE mantencion (
num_mantencion  NUMBER(4) NOT NULL,
cod_sucursal    CHAR(3) NOT NULL,
fecha_ingreso   DATE NOT NULL,
fecha_salida    DATE,
patente_auto    CHAR(8),
cod_mecanico    NUMBER(5) NOT NULL,
costo_total     NUMBER(7) NOT NULL,
estado          VARCHAR2(15) NOT NULL,
CONSTRAINT mantencion_pk PRIMARY KEY (num_mantencion),
CONSTRAINT mant_fk_automovil FOREIGN KEY (patente_auto) REFERENCES automovil (patente),
CONSTRAINT mant_fk_mecanico FOREIGN KEY (cod_mecanico) REFERENCES mecanico (cod_mechanico),
CONSTRAINT mant_fk_sucursal FOREIGN KEY (cod_sucursal) REFERENCES sucursal (id_sucursal)
);
CREATE TABLE detalle_servicio (
mantencion_num NUMBER(4) NOT NULL,
cod_servicio   NUMBER(3) NOT NULL,
descuento_serv NUMBER(4,3) NOT NULL,
cantidad       NUMBER(3) NOT NULL,
CONSTRAINT detalle_servicio_pk PRIMARY KEY (mantencion_num, cod_servicio),
CONSTRAINT det_serv_fk_mantencion FOREIGN KEY (mantencion_num) REFERENCES mantencion (num_mantencion),
CONSTRAINT det_serv_fk_servicio FOREIGN KEY (cod_servicio) REFERENCES servicio (id_servicio)
);
-- =============================================================================
-- CASO 2: MODIFICACIÓN DEL MODELO MEDIANTE REGLAS DE NEGOCIO (ALTER TABLE)
-- =============================================================================
ALTER TABLE mantencion DROP COLUMN costo_total;
ALTER TABLE detalle_servicio DROP CONSTRAINT det_serv_fk_mantencion;
ALTER TABLE mantencion DROP CONSTRAINT mantencion_pk;
ALTER TABLE mantencion ADD CONSTRAINT mantencion_pk PRIMARY KEY (num_mantencion, cod_sucursal);
ALTER TABLE detalle_servicio ADD (cod_sucursal CHAR(3));
ALTER TABLE detalle_servicio DROP CONSTRAINT detalle_servicio_pk;
ALTER TABLE detalle_servicio ADD CONSTRAINT detalle_servicio_pk PRIMARY KEY (mantencion_num, cod_sucursal, cod_servicio);
ALTER TABLE detalle_servicio ADD CONSTRAINT det_serv_fk_mantencion FOREIGN KEY (mantencion_num, cod_sucursal) REFERENCES mantencion (num_mantencion, cod_sucursal);
ALTER TABLE cliente ADD CONSTRAINT cliente_email_un UNIQUE (email);
ALTER TABLE cliente ADD CONSTRAINT cliente_dv_ck CHECK (dv IN ('0','1','2','3','4','5','6','7','8','9','K'));
ALTER TABLE mecanico ADD CONSTRAINT mecanico_sueldo_ck CHECK (sueldo >= 510000);
ALTER TABLE mantencion ADD CONSTRAINT mantencion_estado_ck CHECK (estado IN ('Reserva', 'Ingresado', 'Entregado', 'Anulado'));
-- =============================================================================
-- CASO 3: POBLAMIENTO DEL MODELO (DML) Y SECUENCIAS
-- =============================================================================
CREATE SEQUENCE seq_servicio
START WITH 400
INCREMENT BY 2
NOCACHE;
CREATE SEQUENCE seq_ciudad
START WITH 165
INCREMENT BY 5
NOCACHE;
INSERT INTO pais (nom_pais) VALUES ('Chile');
INSERT INTO pais (nom_pais) VALUES ('Peru');
INSERT INTO pais (nom_pais) VALUES ('Colombia');
INSERT INTO ciudad (id_ciudad, nom_ciudad, cod_pais) VALUES (seq_ciudad.NEXTVAL, 'Santiago', 9);
INSERT INTO ciudad (id_ciudad, nom_ciudad, cod_pais) VALUES (seq_ciudad.NEXTVAL, 'Lima', 12);
INSERT INTO ciudad (id_ciudad, nom_ciudad, cod_pais) VALUES (seq_ciudad.NEXTVAL, 'Bogotá', 15);
INSERT INTO sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad) VALUES ('S01', 'Providencia', 'Av. A. Varas', 234, 165);
INSERT INTO sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad) VALUES ('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170);
INSERT INTO sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad) VALUES ('S03', 'El Cafetero', 'Av. El Faro', 900, 175);
INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Cambio Luces', 45000);
INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Desabolladura', 67000);
INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Revisión Frenos', 30000);
INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Cambio Puerta Trasera', 50000);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, NULL);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Pedro', 'Jose', 'Manriqueque', 'Corral', NULL, 759000, 23980, NULL);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Felipe', 'M.', 'Vidal', 'A.', NULL, 759000, 23580, 460);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alberto', 'P.', 'Cerda', 'Ramírez', NULL, 559000, 22380, 460);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alejandra', 'Gabriela', 'Infanti', 'R.', NULL, 659000, 22380, 460);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', NULL, 859000, 22380, 460);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jose', 'Miguel', 'Troncoso', 'B.', NULL, 659000, 44580, 474);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Juan', 'Pablo', 'Sánchez', 'R.', NULL, 859000, 23380, 474);
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);
INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (101, 'S01', TO_DATE('12-04-2023', 'DD-MM-YYYY'), NULL, NULL, 481, 'Reserva');
INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (102, 'S02', TO_DATE('21-02-2023', 'DD-MM-YYYY'), TO_DATE('21-02-2023', 'DD-MM-YYYY'), NULL, 502, 'Entregado');
INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (103, 'S02', TO_DATE('09-10-2023', 'DD-MM-YYYY'), NULL, NULL, 502, 'Anulado');
INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (104, 'S03', TO_DATE('11-08-2023', 'DD-MM-YYYY'), TO_DATE('18-08-2023', 'DD-MM-YYYY'), NULL, 509, 'Entregado');
INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (105, 'S03', TO_DATE('03-12-2023', 'DD-MM-YYYY'), NULL, NULL, 509, 'Ingresado');
COMMIT;
-- =============================================================================
-- CASO 4: RECUPERACIÓN DE DATOS (QUERIES SELECT)
-- =============================================================================
SELECT
cod_mechanico AS "ID MECANICO",
pnombre || ' ' || apaterno AS "NOMBRE MECANICO",
sueldo AS "SALARIO",
monto_impuestos AS "IMPUESTO ACTUAL",
monto_impuestos * 0.8 AS "IMPUESTO REBAJADO",
sueldo - (monto_impuestos * 0.8) AS "SUELDO CON REBAJA IMPUESTOS"
FROM
mecanico
WHERE
bono_jefatura IS NULL
AND monto_impuestos < 40000
ORDER BY
"IMPUESTO ACTUAL" DESC,
apaterno ASC;
SELECT
cod_mechanico AS "IDENTIFICADOR",
pnombre || ' ' || NVL2(snombre, snombre || ' ', '') || apaterno AS "MECANICO",
sueldo AS "SALARIO ACTUAL",
sueldo * 0.05 AS "AJUSTE",
sueldo + (sueldo * 0.05) AS "SUELDO_REAJUSTADO"
FROM
mecanico
WHERE
(sueldo BETWEEN 600000 AND 900000)
OR cod_supervisor IS NULL
ORDER BY
"SALARIO ACTUAL" ASC,
"MECANICO" DESC;