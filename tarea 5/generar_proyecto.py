"""Regenera el archivo Velxio despues de editar main.py o calculadora.py."""
import json
from pathlib import Path
from datetime import datetime, timezone

carpeta = Path(__file__).resolve().parent
placa = 'raspberry-pi-pico'
grupo = 'group-' + placa
componentes = [
    dict(id='lcd', metadataId='lcd1602', x=370, y=40, properties={'pins': 'full'}),
    dict(id='teclado', metadataId='membrane-keypad', x=400, y=230, properties={}),
    dict(id='raiz', metadataId='pushbutton', x=690, y=270,
         properties={'color': 'green', 'label': 'RAIZ'}),
    dict(id='borrar', metadataId='pushbutton', x=690, y=380,
         properties={'color': 'red', 'label': 'BORRAR'}),
    dict(id='luz', metadataId='resistor', x=720, y=100, properties={'value': '220'}),
]
cables = []


def conectar(origen, pin, destino, terminal, color):
    cables.append(dict(id='w' + str(len(cables) + 1),
                       start=dict(componentId=origen, pinName=pin, x=0, y=0),
                       end=dict(componentId=destino, pinName=terminal, x=0, y=0),
                       color=color, waypoints=[]))


for i in range(4):
    conectar(placa, 'GP' + str(i), 'teclado', 'R' + str(i + 1), '#a855f7')
    conectar(placa, 'GP' + str(i + 4), 'teclado', 'C' + str(i + 1), '#22c55e')
for i, pin in enumerate(('RS', 'E', 'D4', 'D5', 'D6', 'D7')):
    conectar(placa, 'GP' + str(i + 8), 'lcd', pin, '#38bdf8')
for pin in ('VSS', 'V0', 'RW', 'K'):
    conectar(placa, 'GND.1', 'lcd', pin, '#555555')
conectar(placa, 'VBUS', 'lcd', 'VDD', '#ef4444')
conectar(placa, 'VBUS', 'luz', '1', '#ef4444')
conectar('luz', '2', 'lcd', 'A', '#ef4444')
for pin, boton in ((14, 'raiz'), (15, 'borrar')):
    conectar(placa, 'GP' + str(pin), boton, '1.l', '#f59e0b')
    conectar(boton, '2.l', placa, 'GND.1', '#555555')
# Llevar cables por los bordes para dejar libres pantalla y teclas.
for cable in cables:
    a, b = cable['start'], cable['end']
    destino = b['componentId']
    if destino == 'teclado':
        indice = int(a['pinName'][2:])
        x = 230 + indice * 10
        y = 550 + indice * 9
        cable['waypoints'] = [dict(x=x, y=120 + indice * 10),
                             dict(x=x, y=y),
                             dict(x=495 + indice * 9.6, y=y)]
    elif destino == 'lcd':
        pin = b['pinName']
        orden = ['VSS', 'VDD', 'V0', 'RS', 'RW', 'E', 'D0', 'D1',
                 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'A', 'K']
        x = 400 + orden.index(pin) * 9.6
        y = 195 + orden.index(pin) * 2
        cable['waypoints'] = [dict(x=800 if a['componentId'] == 'luz' else 310, y=y),
                             dict(x=x, y=y)]
    elif destino in ('raiz', 'borrar'):
        y = 240 if destino == 'raiz' else 250
        cable['waypoints'] = [dict(x=320, y=y), dict(x=670, y=y),
                             dict(x=670, y=290 if destino == 'raiz' else 400)]
    elif a['componentId'] in ('raiz', 'borrar'):
        cable['waypoints'] = [dict(x=790, y=610), dict(x=200, y=610),
                             dict(x=200, y=170)]
    elif destino == 'luz':
        cable['waypoints'] = [dict(x=290, y=10), dict(x=720, y=10)]
proyecto = dict(
    format='velxio-project', version=1,
    exportedAt=datetime.now(timezone.utc).isoformat(),
    name='Tarea 5 - Calculadora MicroPython',
    boards=[dict(id=placa, name='Calculadora - Pico', boardKind=placa,
                 x=80, y=100, activeFileGroupId=grupo,
                 languageMode='micropython', serialBaudRate=115200)],
    fileGroups={grupo: [dict(name=n, content=(carpeta / n).read_text())
                        for n in ('main.py', 'calculadora.py')]},
    components=componentes, wires=cables, activeBoardId=placa,
)
archivo = carpeta / 'calculadora.vlx'
archivo.write_text(json.dumps(proyecto, ensure_ascii=False, indent=2) + '\n')
print('Generado:', archivo)
