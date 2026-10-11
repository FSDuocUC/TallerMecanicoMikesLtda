# Portafolio de Proyectos - Modelamiento de Bases de Datos

Este repositorio funciona como el portafolio académico oficial para la asignatura **Modelamiento de Bases de Datos**, registrando el progreso, diseño y la implementación de soluciones relacionales sobre la infraestructura de **Oracle Cloud**.

---

## SECCIÓN II: Semana 9 – Evaluación Final Transversal (ANFP)
En esta novena semana se diseñó e implementó la solución corporativa para la **Asociación Nacional de Fútbol Profesional (ANFP)**, enfocada en la centralización y normalización de ligas, comunas y patrimonios de clubes profesionales.

### Estructura del Script SQL (`.sql`)
El script de esta semana está consolidado en un único archivo estructurado secuencialmente de acuerdo con el orden estricto de dependencia de las tablas, garantizando una ejecución libre de errores de integridad referencial:

*   **Fase 3 - Implementación DDL:** Creación de tablas desde las entidades independientes fuertes (`REGION`, `NACIONALIDAD`, `ASOCIACION`) hacia las dependientes débiles (`COMUNA`, `CLUB_FUTBOL`).
*   **Automatización de Identidades:** Configuración nativa en Oracle mediante columnas `GENERATED ALWAYS AS IDENTITY` para la tabla `NACIONALIDAD`, forzando un inicio en 210 con incrementos de 2 en 2.
*   **Reglas de Negocio Físicas:** Restricción de unicidad (`UNIQUE`) en el nombre del club y cláusula `CHECK` en `ASOCIACION` para impedir fechas de creación anteriores al 31 de diciembre de 1980.
*   **Poblamiento y Secuencias (DML):** Creación del objeto secuencia `seq_club_futbol` (inicio 703, incremento de 4) para la carga automatizada de los identificadores de los equipos.
*   **Fase 4 - Reportes Estadísticos (SELECT):** 
    *   *Informe 1 (Asociaciones):* Filtro de asociaciones profesionales creadas después del año 2000 con ordenamiento cronológico descendente.
    *   *Informe 2 (Patrimonio):* Reporte financiero con conversión matemática en tiempo real a dólares (tasa \$955) para clubes con patrimonios superiores a 200 millones cuyo nombre contiene la letra "A".

### Diagrama Entidad-Relación e Integridad (Fases 1 y 2)
*   `REGION` → Clave Foránea (`FK`) hacia → `COMUNA`
*   `ASOCIACION` (Control de ligas federativas)
*   `NACIONALIDAD` (Gestión autoincrementable de jugadores)
*   `CLUB_FUTBOL` (Centralización de patrimonios y ubicaciones)

---

## SECCIÓN I: Semanas Anteriores – Caso Taller Mecánico (Mikes Ltda.)
Solución inicial de base de datos relacional para el **Taller de mecánica Mikes Ltda.**, empresa con presencia en diversas ciudades del norte de Chile que ofrece servicios multimarca de vanguardia.

### Estructura del Script SQL
El guión está consolidado de manera estrictamente secuencial, respetando las dependencias e integridad referencial del modelo relacional normalizado:

*   **Caso 1 - Implementación del Modelo Relacional (DDL):** Creación de las tablas principales partiendo desde las entidades fuertes hacia las débiles. Uso de la sintaxis nativa `GENERATED ALWAYS AS IDENTITY` (tabla `PAIS` inicia en 9 e incrementa de 3 en 3; tabla `MECANICO` inicia en 460 e incrementa de 7 en 7).
*   **Caso 2 - Modificación del Modelo (ALTER TABLE):** Eliminación del atributo derivado `costo_total` de la tabla `MANTENCION` para calcular los costos en tiempo real. Reestructuración de la PK de `MANTENCION` a clave compuesta (`num_mantencion` + `cod_sucursal`), ajustando la FK en `DETALLE_SERVICIO`.
*   **Restricciones de Calidad de Datos:** `UNIQUE` en email de `CLIENTE`, `CHECK` para dígito verificador (0-9 y 'K'), `CHECK` de sueldo mínimo para mecánicos (\$510.000) y limitación de estados operativos (*Reserva, Ingresado, Entregado, Anulado*).
*   **Caso 3 - Poblamiento (DML) y Secuencias:** Creación de objetos `SEQUENCE` autónomos para el control numérico de servicios (`seq_servicio` desde 400 de 2 en 2) y ciudades (`seq_ciudad` desde 165 de 5 en 5).
*   **Caso 4 - Reportes Estadísticos (SELECT):** 
    *   *Informe 1 (Impuestos):* Consulta con ordenamiento específico que calcula una rebaja del 20% en los impuestos de mecánicos sin bono de jefatura e impuestos menores a \$40.000.
    *   *Informe 2 (Sueldos):* Consulta con operadores matemáticos y función `NVL2` que simula un aumento del 5% al personal con sueldos entre \$600.000 y \$900.000, o que carecen de supervisor.

### Diagrama Entidad-Relación Implementado
*   `PAIS` → `CIUDAD` → `SUCURSAL` → `MANTENCION`
*   `CLIENTE` → (`ESTANDAR` / `PREMIUM`)
*   `CLIENTE` → `AUTOMOVIL` → `MANTENCION`
*   `MARCA` → `MODELO` → `AUTOMOVIL`
*   `TIPO_AUTOMOVIL` → `AUTOMOVIL`
*   `MECANICO` → `MANTENCION` → `DETALLE_SERVICIO` ← `SERVICIO`

---

## Requisitos para la Ejecución General

1.  Contar con una conexión activa a **Oracle SQL Developer** conectada al entorno Cloud mediante las credenciales correspondientes (`PRY2204_S8` para el caso de estudio o **`PRY2204_S9`** para la EFT de la ANFP).
2.  Abrir el archivo `.sql` respectivo en una Hoja de Trabajo asignada al usuario.
3.  Presionar el botón **Ejecutar Script (F5)** para compilar la infraestructura, poblar las filas relacionales y desplegar las rejillas de datos de los informes analíticos.

---

## Autor
*   **Fabián Segura**
*   *Modelamiento de Bases de Datos - Duoc UC*
