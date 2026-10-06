# Sistema de Gestión de Mantenciones - Mikes Ltda.

Este repositorio contiene la solución completa de la base de datos relacional para el **Taller de mecánica Mikes Ltda.**, empresa con presencia en diversas ciudades del norte de Chile que ofrece servicios multimarca de vanguardia. 

El proyecto abarca el diseño del esquema físico (DDL), la alteración del modelo mediante reglas de negocio avanzadas, el poblamiento secuencial de datos (DML) y la generación de reportes estadísticos simulados mediante Oracle SQL Developer.

---

## Estructura del Script SQL

El script está consolidado en un único archivo estructurado de manera estrictamente secuencial, respetando las dependencias e integridad referencial del modelo relacional normalizado:

### 1. Caso 1: Implementación del Modelo Relacional (DDL)
*   Creación de las tablas principales partiendo desde las entidades fuertes (independientes) hacia las débiles (dependientes).
*   Configuración de restricciones de claves primarias (`PRIMARY KEY`), claves foráneas (`FOREIGN KEY`) y campos obligatorios (`NOT NULL`).
*   **Automatización de Identificadores:** Uso de la sintaxis nativa de Oracle `GENERATED ALWAYS AS IDENTITY` para la generación automática y secuencial de claves (la tabla `PAIS` inicia en 9 e incrementa de 3 en 3; la tabla `MECANICO` inicia en 460 e incrementa de 7 en 7).

### 2. Caso 2: Modificación del Modelo y Reglas de Negocio (ALTER TABLE)
*   **Optimización de Almacenamiento:** Eliminación del atributo derivado `costo_total` de la tabla `MANTENCION` para calcular los costos en tiempo real.
*   **Reestructuración de Identificación:** Modificación de la clave primaria de `MANTENCION` para convertirla en una clave compuesta (`num_mantencion` + `cod_sucursal`), ajustando en consecuencia la clave foránea en la tabla `DETALLE_SERVICIO`.
*   **Restricciones de Calidad de Datos:**
    *   Restricción de unicidad (`UNIQUE`) en el correo electrónico de la tabla `CLIENTE`.
    *   Validación por lista (`CHECK`) para el dígito verificador (`dv`) del RUT (valores del 0 al 9 y 'K').
    *   Validación de condiciones laborales (`CHECK`) para asegurar que ningún mecánico se registre con un sueldo inferior al mínimo ético establecido de \$510.000 pesos.
    *   Validación de flujo operativo (`CHECK`) para restringir los estados de mantención únicamente a: *Reserva, Ingresado, Entregado, Anulado*.

### 3. Caso 3: Poblamiento del Modelo (DML) y Secuencias
*   Creación de objetos `SEQUENCE` autónomos para el control numérico de servicios (`seq_servicio` iniciando en 400 con incrementos de 2) y ciudades (`seq_ciudad` iniciando en 165 con incrementos de 5).
*   Inserción de datos de prueba respetando el orden de dependencia jerárquica para evitar colisiones de llaves foráneas.

### 4. Caso 4: Recuperación de Datos y Reportes Estadísticos (SELECT)
*   **Informe 1 (Simulación de Rebaja de Impuestos):** Consulta estructurada con ordenamiento específico que calcula una rebaja del 20% en los impuestos de los mecánicos sin bono de jefatura y con impuestos menores a \$40.000 pesos.
*   **Informe 2 (Listado de Cálculo de Reajuste Salarial):** Consulta con operadores matemáticos y la función condicional `NVL2` que simula un aumento del 5% al personal que percibe sueldos entre \$600.000 y \$900.000 pesos, o que carecen de supervisor.

---

## Diagrama Entidad-Relación Implementado

El esquema físico de la base de datos enlaza de manera relacional las siguientes tablas principales:
*   `PAIS` → `CIUDAD` → `SUCURSAL` → `MANTENCION`
*   `CLIENTE` → (`ESTANDAR` / `PREMIUM`)
*   `CLIENTE` → `AUTOMOVIL` → `MANTENCION`
*   `MARCA` → `MODELO` → `AUTOMOVIL`
*   `TIPO_AUTOMOVIL` → `AUTOMOVIL`
*   `MECANICO` → `MANTENCION` → `DETALLE_SERVICIO` ← `SERVICIO`

---

## Requisitos para la Ejecución

1. Contar con una conexión activa a **Oracle SQL Developer** conectada con el usuario asignado (`PRY2204_S8`).
2. Abrir una nueva Hoja de Trabajo (SQL Worksheet).
3. Copiar el contenido del archivo `.sql` o abrir el archivo directamente en el IDE.
4. Presionar el botón **Ejecutar Script (F5)** para levantar la infraestructura, poblar los registros y visualizar los informes interactivos en los paneles de salida.

---

## Autor
*   **Fabián Segura**
*   *Modelamiento de Bases de Datos - Duoc UC*
