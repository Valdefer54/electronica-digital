// Multiplicador sin signo de 4 por 4 bits.
module multiplicador (
    input  logic a3, a2, a1, a0,
    input  logic b3, b2, b1, b0,
    output logic [7:0] producto
);
    logic [3:0] a, b;
    logic [3:0] parcial0, parcial1, parcial2, parcial3;
    logic [5:0] suma01;
    logic [6:0] suma012;

    assign a = {a3, a2, a1, a0};
    assign b = {b3, b2, b1, b0};

    // Cada bit de b habilita una fila de cuatro compuertas AND.
    assign parcial0 = a & {4{b[0]}};
    assign parcial1 = a & {4{b[1]}};
    assign parcial2 = a & {4{b[2]}};
    assign parcial3 = a & {4{b[3]}};

    // Los ceros a la derecha desplazan cada fila a su posicion binaria.
    assign suma01   = {2'b00, parcial0} + {1'b0, parcial1, 1'b0};
    assign suma012  = {1'b0, suma01} + {1'b0, parcial2, 2'b00};
    assign producto = {1'b0, suma012} + {1'b0, parcial3, 3'b000};
endmodule
