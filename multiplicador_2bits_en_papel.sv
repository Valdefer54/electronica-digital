// Multiplicacion binaria de dos numeros de 2 bits sin signo.
module multiplicador_2bits_en_papel (
    input  logic a1, a0,
    input  logic b1, b0,
    output wire  [3:0] producto
);
    wire a1b0, a0b1, a1b1;
    logic acarreo_columna1;

    // Primera fila de productos parciales.
    and (producto[0], a0, b0);
    and (a1b0, a1, b0);

    // Segunda fila, desplazada una columna a la izquierda.
    and (a0b1, a0, b1);
    and (a1b1, a1, b1);

    multiplicador_2bits_medio_sumador columna1 (
        .a(a1b0), .b(a0b1), .suma(producto[1]), .acarreo(acarreo_columna1)
    );
    multiplicador_2bits_medio_sumador columna2 (
        .a(a1b1), .b(acarreo_columna1), .suma(producto[2]), .acarreo(producto[3])
    );
endmodule

module multiplicador_2bits_medio_sumador (
    input  logic a, b,
    output logic suma, acarreo
);
    assign suma = a ^ b;
    assign acarreo = a & b;
endmodule
