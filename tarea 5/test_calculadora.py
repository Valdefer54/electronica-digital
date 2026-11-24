"""Ejecutar con: python3 test_calculadora.py"""
from calculadora import Calculadora, calcular


def ingresar(teclas):
    c = Calculadora()
    for tecla in teclas:
        c.tecla(tecla)
    return c


casos = [
    ('12+8=', 20), ('1.25+2.5=', 3.75),
    ('9-14=', -5), ('5.5-2.25=', 3.25),
    ('7*6=', 42), ('1.5*2.4=', 3.6),
    ('9/2=', 4.5), ('7.5/2.5=', 3),
    ('-3*-2=', 6), ('2+-3=', -1), ('0.1+0.2=', 0.3),
    ('2+3*4=', 20), ('1..5+2=', 3.5),
]
for teclas, esperado in casos:
    c = ingresar(teclas)
    assert not c.error, (teclas, c.error)
    assert abs(float(c.entrada) - esperado) < 1e-8, (teclas, c.entrada)
for numero, esperado in [(81, 9), (2.25, 1.5), (0, 0), (2, 2**0.5)]:
    c = ingresar(str(numero))
    c.tecla('sqrt')
    assert abs(float(c.entrada) - esperado) < 1e-8
for teclas in ('5/0=', '0/0='):
    c = ingresar(teclas)
    assert c.error == 'Division por 0'
    c.tecla('CLEAR')
    assert c.lineas() == ('Calculadora', '0')
c = ingresar('-4')
c.tecla('sqrt')
assert c.error == 'Raiz negativa'
c = ingresar('2+3=')
c.tecla('4')
assert c.entrada == '4'
c = ingresar('2+3=')
for tecla in '*2=':
    c.tecla(tecla)
assert c.entrada == '10'
c = ingresar('2+9')
c.tecla('sqrt')
c.tecla('=')
assert c.entrada == '5'
assert len(ingresar('12345678901234567890').entrada) == 12
try:
    calcular(1e300, '*', 1e300)
    raise AssertionError('Debe rechazar infinito')
except ValueError:
    pass
print('OK: operaciones enteras y decimales, teclado, encadenamiento y errores.')
