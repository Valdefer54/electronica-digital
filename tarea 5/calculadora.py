"""Logica de calculadora compatible con MicroPython y Python 3."""
import math


def calcular(a, operacion, b=None):
    if operacion == 'sqrt':
        if a < 0:
            raise ValueError('Raiz negativa')
        resultado = math.sqrt(a)
    elif operacion == '+':
        resultado = a + b
    elif operacion == '-':
        resultado = a - b
    elif operacion == '*':
        resultado = a * b
    elif operacion == '/':
        if b == 0:
            raise ValueError('Division por 0')
        resultado = a / b
    else:
        raise ValueError('Operacion invalida')
    if not math.isfinite(resultado):
        raise ValueError('Fuera de rango')
    return resultado


def formato(numero):
    return '{:.10g}'.format(numero) if numero != 0 else '0'


class Calculadora:
    def __init__(self):
        self.limpiar()

    def limpiar(self):
        self.entrada = ''
        self.anterior = None
        self.operacion = None
        self.terminado = False
        self.error = ''
        self.titulo = 'Calculadora'

    def lineas(self):
        if self.error:
            return self.error, 'BORRAR: reinicia'
        titulo = self.titulo
        if self.operacion:
            titulo = formato(self.anterior) + ' ' + self.operacion
        return titulo[:16], (self.entrada or '0')[:16]

    def tecla(self, tecla):
        if tecla == 'CLEAR':
            self.limpiar()
            return
        if self.error:
            return
        try:
            self._tecla(tecla)
        except (ValueError, OverflowError, ZeroDivisionError) as exc:
            self.error = str(exc)[:16]

    def _tecla(self, tecla):
        if tecla in '0123456789.':
            if self.terminado:
                self.limpiar()
            if tecla == '.' and '.' in self.entrada:
                return
            if len(self.entrada) >= 12:
                return
            if tecla == '.' and self.entrada in ('', '-'):
                self.entrada += '0'
            self.entrada += tecla
            return
        if tecla == '-' and self.entrada in ('', '-'):
            self.entrada = '' if self.entrada == '-' else '-'
            return
        if tecla == 'sqrt':
            if self.entrada in ('', '-'):
                return
            self.entrada = formato(calcular(float(self.entrada), 'sqrt'))
            self.titulo = 'Raiz cuadrada'
            self.terminado = self.operacion is None
            return
        if tecla not in ('+', '-', '*', '/', '='):
            return
        if self.entrada in ('', '-'):
            if self.operacion and tecla != '=':
                self.operacion = tecla
            return
        valor = float(self.entrada)
        if self.operacion:
            valor = calcular(self.anterior, self.operacion, valor)
        if tecla == '=':
            self.entrada = formato(valor)
            self.anterior = None
            self.operacion = None
            self.terminado = True
            self.titulo = 'Resultado'
        else:
            self.anterior = valor
            self.operacion = tecla
            self.entrada = ''
            self.terminado = False
