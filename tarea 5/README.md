# Tarea 5 — Calculadora con microcontrolador

Proyecto para **Velxio**, escrito en **MicroPython**, con una **Raspberry Pi Pico (RP2040)**, teclado matricial 4×4 y pantalla LCD 16×2 HD44780 en modo de cuatro bits. Realiza suma, resta, multiplicación, división y raíz cuadrada con números enteros y decimales.

## Abrir y ejecutar

1. Abre https://velxio.dev/editor/.
2. Pulsa **Open project (.vlx Velxio or .zip Wokwi)** y selecciona `calculadora.vlx` de esta carpeta. Confirma **Load**. Se reemplaza el circuito que tengas abierto: guarda primero cualquier trabajo previo.
3. El proyecto ya selecciona **MicroPython** y contiene ambos archivos Python, los componentes y sus conexiones.
4. Pulsa **Run MicroPython**. Espera a que la LCD muestre `Calculadora` y `0`.
5. Usa el teclado del circuito con el ratón. Pulsa y suelta cada tecla durante al menos 25 ms. Si la emulación va lenta, mantén la pulsación más tiempo y espera a que la LCD se actualice antes de introducir la siguiente tecla. Los resultados también aparecen en **Serial**. El arranque puede tardar aproximadamente un minuto o más según el rendimiento del navegador. Si al volver a importar un proyecto no arranca, recarga la página e importa de nuevo el archivo.

No se requiere iniciar sesión para importar el archivo local. Guardarlo en tu cuenta o generar un enlace compartido puede requerir iniciar sesión.

## Controles

| Tecla o botón | Función |
|---|---|
| `0` a `9` | Introducir cifras |
| `A` | Sumar |
| `B` | Restar; al comenzar un operando, introducir signo negativo |
| `C` | Multiplicar |
| `D` | Dividir |
| `*` | Punto decimal |
| `#` | Igual / resultado |
| Botón verde `RAIZ` | Raíz cuadrada del número mostrado |
| Botón rojo `BORRAR` | Borrar toda la operación y salir de un error |

Ejemplo: para `1.25 + 2.5`, pulsa `1 * 2 5 A 2 * 5 #`: aparece `3.75`.
Para √2.25, pulsa `2 * 2 5` y el botón **RAIZ**: aparece `1.5`.
Para −3 × 2, pulsa `B 3 C 2 #`: aparece `-6`.
Después de un resultado puedes elegir otra operación para reutilizarlo, o escribir cifras para empezar de nuevo.

Las operaciones se resuelven **de izquierda a derecha**, como en una calculadora básica: `2 + 3 × 4 = 20`. No hay paréntesis ni precedencia algebraica. La raíz se aplica al operando actual; `2 A 9 RAIZ #` da `5`. Si falta un operando, `#` no calcula.

## Conexiones

Los números GP son GPIO, no los números físicos del conector.

| Componente | Terminal | Pico |
|---|---|---|
| Teclado | R1, R2, R3, R4 | GP0, GP1, GP2, GP3 |
| Teclado | C1, C2, C3, C4 | GP4, GP5, GP6, GP7 |
| LCD | RS | GP8 |
| LCD | E | GP9 |
| LCD | D4, D5, D6, D7 | GP10, GP11, GP12, GP13 |
| LCD | VSS, V0, RW, K | GND |
| LCD | VDD | VBUS (5 V del USB) |
| LCD | A | VBUS mediante resistencia de 220 Ω |
| Botón RAIZ | 1.l / 2.l | GP14 / GND |
| Botón BORRAR | 1.l / 2.l | GP15 / GND |

D0–D3 de la LCD quedan sin conectar. Los botones y columnas usan resistencias pull-up internas. Se activa una fila por vez y se dejan las demás en alta impedancia. El programa filtra rebotes durante 25 ms y espera una nueva pulsación para repetir.

Para un montaje físico: verifica que la LCD acepte señales de 3.3 V o usa adaptación de nivel; nunca apliques 5 V a los GPIO de la Pico. Sustituye la conexión V0 a tierra por el cursor de un potenciómetro de 10 kΩ entre alimentación y tierra si necesitas ajustar contraste. El circuito entregado está destinado al simulador.

## Archivos y funcionamiento

- `calculadora.vlx`: proyecto completo que se importa en Velxio.
- `main.py`: lectura del teclado, botones, antirrebote y controlador LCD, sin bibliotecas externas.
- `calculadora.py`: lógica de entrada y operaciones; usa `math.sqrt`, sin `eval`.
- `test_calculadora.py`: comprobaciones de operaciones y casos de error con Python 3.
- `generar_proyecto.py`: vuelve a empaquetar los archivos fuente en `calculadora.vlx` después de modificarlos.

El programa escanea las entradas, actualiza el operando/operación y presenta el estado en la pantalla. Rechaza división por cero, raíces negativas y resultados no finitos. Después de un error se debe pulsar **BORRAR**.

Admite hasta 12 caracteres por operando y presenta resultados con 10 cifras significativas (puede usar notación científica). Usa punto flotante: los decimales son aproximados y la precisión real depende del firmware MicroPython de la placa. No es una calculadora de precisión arbitraria.

## Verificación local

Desde esta carpeta:

```bash
python3 test_calculadora.py
python3 generar_proyecto.py
```

| Operación | Enteros | Decimales |
|---|---|---|
| Suma | 12 + 8 = 20 | 1.25 + 2.5 = 3.75 |
| Resta | 9 − 14 = −5 | 5.5 − 2.25 = 3.25 |
| Multiplicación | 7 × 6 = 42 | 1.5 × 2.4 = 3.6 |
| División | 9 ÷ 2 = 4.5 | 7.5 ÷ 2.5 = 3 |
| Raíz cuadrada | √81 = 9 | √2.25 = 1.5 |

También se comprueban números negativos, decimales repetidos, operaciones encadenadas, reinicio tras un resultado, límite de entrada, división por cero y raíz negativa. Estas pruebas verifican la lógica con Python 3; la simulación verifica por separado la integración GPIO/LCD.

## Documentación de referencia

- [MicroPython en Velxio](https://velxio.dev/docs/programming/micropython/).
- [Abrir y guardar proyectos Velxio](https://velxio.dev/docs/getting-started/projects/).
- Formato `.vlx` contrastado con el [código oficial de Velxio](https://github.com/davidmonterocrespo24/velxio/blob/main/frontend/src/utils/vlxFile.ts).

### Resultado de la verificación

La lógica pasó las pruebas locales de las cinco operaciones y los casos de error. En Velxio se verificaron el arranque MicroPython, la entrada por teclado y la operación `2 + 3 = 5`, visible en LCD y monitor serial. La captura `velxio-prueba.jpg` registra esa prueba; corresponde al mismo circuito antes del último ajuste visual de un cable de retroiluminación. No se probó en una placa física.
