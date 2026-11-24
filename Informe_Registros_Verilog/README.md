# Registros SISO, SIPO, PISO y PIPO

Autor: Juan Fernando Zapata Valderrama.
Correo: fernando.zapata@utp.edu.co.

Informe de Electrónica Digital basado en la plantilla institucional `replab`
suministrada. Conserva la clase, los colores y los logos; adapta el título,
la numeración y las referencias a convenciones IEEE en dos columnas.
No corresponde a la clase oficial IEEEtran de una publicación específica.

Los circuitos de la práctica se ejecutaron en DigitalJS y las cuatro capturas
proceden de ese entorno. Los 6304 ciclos corresponden a una verificación
adicional realizada con Icarus Verilog; no son un conteo de DigitalJS.

## Archivos

- `main.tex`: fuente principal del informe.
- `replab.cls`: clase adaptada de la plantilla del usuario. Se usa bibliografía
  manual numerada para evitar la dependencia de biber. El título y encabezados
  se configuran en main.tex para evitar datos personales de ejemplo.
- `imagenes/`: cuatro capturas originales del usuario y dos logos de la plantilla.
- `codigo/`: módulos Verilog de cuatro bits y banco de pruebas autocontrolado.
- `evidencia/simulacion.txt`: resultado real de 6304 ciclos con Icarus Verilog 13.
- `main.pdf`: informe compilado, si se incluye en esta entrega.

## Compilar el informe

Desde esta carpeta, en un entorno con Tectonic:

```sh
tectonic main.tex
```

También puede subirse el contenido de esta carpeta a Overleaf y seleccionar
`main.tex` como documento principal. No se requiere biber.

## Repetir la verificación adicional con Icarus Verilog

Con Icarus Verilog instalado, desde esta carpeta:

```sh
iverilog -g2012 -s registros_tb -o /tmp/registros_tb codigo/siso.v codigo/sipo.v codigo/piso.v codigo/pipo.v codigo/registros_tb.v
vvp /tmp/registros_tb
```

Resultado esperado: `OK: SISO, SIPO, PISO y PIPO; 6304 ciclos verificados`.
La opción -g2012 permite usar las comprobaciones $fatal del banco de pruebas;
los módulos de diseño usan sintaxis Verilog-2001.

Todos los módulos usan reset síncrono activo en uno y flanco de subida.
PISO carga con cargar=1 y desplaza con cargar=0; reset tiene prioridad.
El primer bit serie de PISO está disponible tras el flanco de carga.
La simulación no sustituye mediciones de tiempos ni pruebas en FPGA.

## Procedimiento pendiente en Quartus Prime

Quartus no está instalado en el entorno de esta entrega. No se ha ejecutado
una compilación ni se ha generado un informe de síntesis con Quartus.

1. Crear un proyecto con New Project Wizard y seleccionar el dispositivo de la placa.
2. Agregar uno de los archivos de diseño de codigo/ y establecer su módulo
   (siso, sipo, piso o pipo) como Top-Level Entity.
3. Ejecutar Processing > Start > Start Analysis & Synthesis.
4. Revisar los errores y guardar el informe generado. Repetir para cada módulo.
5. Para una compilación completa destinada a hardware, configurar los pines
   y las restricciones de reloj según la placa y ejecutar Start Compilation.

El banco registros_tb.v corresponde a simulación y no debe sintetizarse
como entidad principal. La compilación no sustituye las pruebas funcionales.
