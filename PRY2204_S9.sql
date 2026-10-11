/* =============================================================================
ASIGNATURA: Modelamiento de Bases de Datos - Semana 9 (EFT)
PROYECTO: Infraestructura de Datos ANFP - Caso Mikes Modificado
AUTOR: Fabián Segura
============================================================================= */
-- =============================================================================
-- FASE 3: CREACIÓN DE TABLAS Y RESTRICCIONES (DDL)
-- Estructurado secuencialmente de acuerdo con el orden de dependencia jerárquica.
-- =============================================================================
CREATE TABLE region (
id_region  NUMBER(3) NOT NULL,
nombre     VARCHAR2(50) NOT NULL,
CONSTRAINT region_pk PRIMARY KEY (id_region)
);
CREATE TABLE comuna (
id_comuna  NUMBER(3) NOT NULL,
id_region  NUMBER(3) NOT NULL,
nombre     VARCHAR2(30) NOT NULL,
CONSTRAINT comuna_pk PRIMARY KEY (id_comuna),
CONSTRAINT comuna_fk_region FOREIGN KEY (id_region) REFERENCES region (id_region)
);
CREATE TABLE asociacion (
id_asociacion    NUMBER(3) NOT NULL,
nombre_asociacion VARCHAR2(100) NOT NULL,
fecha_creacion   DATE NOT NULL,
tipo_asociacion  CHAR(1) NOT NULL,
CONSTRAINT asociacion_pk PRIMARY KEY (id_asociacion),
CONSTRAINT asoc_fecha_ck CHECK (fecha_creacion >= TO_DATE('1980-12-31', 'YYYY-MM-YYYY'))
);
CREATE TABLE nacionalidad (
id_nacion   NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 2),
descripcion VARCHAR2(30) NOT NULL,
CONSTRAINT nacionalidad_pk PRIMARY KEY (id_nacion)
);
CREATE TABLE club_futbol (
id_club          NUMBER(5) NOT NULL,
nombre_club      VARCHAR2(100) NOT NULL,
patrimonio       NUMBER(15) NOT NULL,
ubicacion_calle  VARCHAR2(100) NOT NULL,
tipo_club        VARCHAR2(20) NOT NULL,
CONSTRAINT club_futbol_pk PRIMARY KEY (id_club),
CONSTRAINT club_nombre_un UNIQUE (nombre_club)
);
-- =============================================================================
-- FASE 3: SECUENCIAS Y POBLAMIENTO DE DATOS (DML)
-- Ejecución secuencial libre de errores de integridad referencial.
-- =============================================================================
-- Secuencia para el código de la tabla CLUB_FUTBOL (Inicio 703, incremento de 4)
CREATE SEQUENCE seq_club_futbol
START WITH 703
INCREMENT BY 4
NOCACHE;
-- 1. Poblar Tabla REGION
INSERT INTO region (id_region, nombre) VALUES (1, 'ARICA Y PARINACOTA Y TARAPACA');
INSERT INTO region (id_region, nombre) VALUES (2, 'ANTOFAGASTA');
INSERT INTO region (id_region, nombre) VALUES (3, 'ATACAMA Y COQUIMBO');
INSERT INTO region (id_region, nombre) VALUES (5, 'VALPARAISO');
INSERT INTO region (id_region, nombre) VALUES (13, 'METROPOLITANA');
-- 2. Poblar Tabla COMUNA
INSERT INTO comuna (id_comuna, id_region, nombre) VALUES (101, 13, 'Santiago');
INSERT INTO comuna (id_comuna, id_region, nombre) VALUES (102, 5, 'Valparaiso');
INSERT INTO comuna (id_comuna, id_region, nombre) VALUES (103, 8, 'Concepción');
INSERT INTO comuna (id_comuna, id_region, nombre) VALUES (104, 2, 'Antofagasta');
INSERT INTO comuna (id_comuna, id_region, nombre) VALUES (105, 16, 'Chillán');
-- 3. Poblar Tabla ASOCIACION (Validado por restricción CHECK >= 31-Dic-1980)
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (25, 'Asociación de Fútbol de Santiago', TO_DATE('15-05-2001', 'DD-MM-YYYY'), 'P');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (26, 'Asociación National de Fútbol Amateur', TO_DATE('10-03-1998', 'DD-MM-YYYY'), 'A');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (27, 'Asociación de Fútbol de Valparaiso', TO_DATE('21-07-1987', 'DD-MM-YYYY'), 'P');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (28, 'Asociación de Fútbol de Concepción', TO_DATE('30-11-1995', 'DD-MM-YYYY'), 'A');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (29, 'Asociación de Fútbol de Antofagasta', TO_DATE('25-06-2003', 'DD-MM-YYYY'), 'P');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (30, 'Asociación de Fútbol de Temuco', TO_DATE('12-01-2010', 'DD-MM-YYYY'), 'A');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (31, 'Asociación de Fútbol de Rancagua', TO_DATE('08-09-1999', 'DD-MM-YYYY'), 'P');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (32, 'Asociación de Fútbol de Puerto Montt', TO_DATE('20-04-2005', 'DD-MM-YYYY'), 'A');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (33, 'Asociación de Fútbol de La Serena', TO_DATE('14-08-2012', 'DD-MM-YYYY'), 'P');
INSERT INTO asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
VALUES (34, 'Asociación de Fútbol de Chillán', TO_DATE('01-12-2018', 'DD-MM-YYYY'), 'A');
-- 4. Poblar Tabla NACIONALIDAD (Usa IDENTITY autoincrementable 210, 212, 214...)
INSERT INTO nacionalidad (descripcion) VALUES ('Chilena');
INSERT INTO nacionalidad (descripcion) VALUES ('Argentina');
INSERT INTO nacionalidad (descripcion) VALUES ('Peruana');
INSERT INTO nacionalidad (descripcion) VALUES ('Boliviana');
INSERT INTO nacionalidad (descripcion) VALUES ('Brasileña');
-- 5. Poblar Tabla CLUB_FUTBOL (Usa la secuencia seq_club_futbol.NEXTVAL)
INSERT INTO club_futbol (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club_futbol.NEXTVAL, 'Colo-Colo', 500000000, 'Av. Marathon 5300', 'Profesional');
INSERT INTO club_futbol (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club_futbol.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. El Parrón 0931', 'Profesional');
INSERT INTO club_futbol (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club_futbol.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606', 'Profesional');
INSERT INTO club_futbol (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club_futbol.NEXTVAL, 'Huachipato', 220000000, 'Avenida Desiderio Garcia 909', 'Profesional');
INSERT INTO club_futbol (id_club, nombre_club, patrimonio, ubicacion_calle, tipo_club)
VALUES (seq_club_futbol.NEXTVAL, 'Nublense', 170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');
COMMIT;
-- =============================================================================
-- FASE 4: RECUPERACIÓN DE DATOS (REPORTES SELECT CON FORMATO ESPECÍFICO)
-- =============================================================================
-- INFORME 1: Asociaciones de fútbol profesional
SELECT
'ID:' || id_asociacion || ' * ' || nombre_asociacion AS "ASOCIACION",
TO_CHAR(fecha_creacion, 'DD-MM-YYYY') AS "CREADA",
tipo_asociacion AS "TIPO"
FROM
asociacion
WHERE
tipo_asociacion = 'P'
AND fecha_creacion > TO_DATE('31-12-2000', 'YYYY-MM-YYYY')
ORDER BY
fecha_creacion DESC;
-- INFORME 2: Patrimonio de clubes de fútbol (Conversión a dólares a tasa $955)
SELECT
id_club AS "CLUB",
nombre_club AS "NOMBRE CLUB",
patrimonio AS "PATRIMONIO EN PESOS",
ROUND(patrimonio / 955, 3) AS "PATRIMONIO EN DOLARES"
FROM
club_futbol
WHERE
LOWER(nombre_club) LIKE '%a%'
AND patrimonio > 200000000
AND tipo_club = 'Profesional'
ORDER BY
id_club DESC;