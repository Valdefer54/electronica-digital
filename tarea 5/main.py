"""Tarea 5: Raspberry Pi Pico + teclado 4x4 + LCD HD44780."""
from machine import Pin
from time import sleep_ms, sleep_us, ticks_ms, ticks_diff
from calculadora import Calculadora


class LCD:
    def __init__(self):
        self.rs = Pin(8, Pin.OUT, value=0)
        self.en = Pin(9, Pin.OUT, value=0)
        self.datos = [Pin(n, Pin.OUT, value=0) for n in (10, 11, 12, 13)]
        sleep_ms(50)
        for valor in (3, 3, 3, 2):
            self.nibble(valor)
            sleep_ms(5)
        for comando in (0x28, 0x0C, 0x06, 0x01):
            self.enviar(comando)
            sleep_ms(2)

    def nibble(self, valor):
        for bit, pin in enumerate(self.datos):
            pin.value((valor >> bit) & 1)
        sleep_us(2)
        self.en.on()
        sleep_us(2)
        self.en.off()
        sleep_us(50)

    def enviar(self, valor, texto=False):
        self.rs.value(texto)
        self.nibble(valor >> 4)
        self.nibble(valor & 15)

    def mostrar(self, lineas):
        for direccion, texto in zip((0x80, 0xC0), lineas):
            self.enviar(direccion)
            for caracter in (texto + ' ' * 16)[:16]:
                self.enviar(ord(caracter), True)


# Una fila activa a la vez; las otras quedan en alta impedancia.
filas = [Pin(n, Pin.IN) for n in (0, 1, 2, 3)]
columnas = [Pin(n, Pin.IN, Pin.PULL_UP) for n in (4, 5, 6, 7)]
mapa = (('1', '2', '3', '+'), ('4', '5', '6', '-'),
        ('7', '8', '9', '*'), ('.', '0', '=', '/'))
raiz = Pin(14, Pin.IN, Pin.PULL_UP)
borrar = Pin(15, Pin.IN, Pin.PULL_UP)


def leer_tecla():
    if not borrar.value():
        return 'CLEAR'
    if not raiz.value():
        return 'sqrt'
    for indice, fila in enumerate(filas):
        fila.init(Pin.OUT, value=0)
        sleep_us(30)
        pulsadas = [j for j, col in enumerate(columnas) if not col.value()]
        fila.init(Pin.IN)
        if pulsadas:
            return mapa[indice][pulsadas[0]]
    return None


def main():
    lcd = LCD()
    calculadora = Calculadora()
    lcd.mostrar(calculadora.lineas())
    print('Calculadora lista. A:+ B:- C:* D:/ *:decimal #:=')
    print('Boton verde: raiz. Boton rojo: borrar. B al iniciar: negativo.')
    candidata = None
    estable = None
    cambio = ticks_ms()
    while True:
        tecla = leer_tecla()
        ahora = ticks_ms()
        if tecla != candidata:
            candidata = tecla
            cambio = ahora
        if ticks_diff(ahora, cambio) >= 25 and estable != candidata:
            estable = candidata
            if estable is not None:
                calculadora.tecla(estable)
                lineas = calculadora.lineas()
                lcd.mostrar(lineas)
                print(lineas[0], '|', lineas[1])
        sleep_ms(5)


main()
