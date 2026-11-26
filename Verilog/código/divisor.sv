`timescale 1ns/1ps

// Division entera a / b de 4 bits sin signo, sin reloj.
module divisor (
    input  logic a3, a2, a1, a0,
    input  logic b3, b2, b1, b0,
    output logic [3:0] cociente,
    output logic [3:0] residuo,
    output logic       division_por_cero
);
    logic [3:0] a, b;
    assign a = {a3, a2, a1, a0};
    assign b = {b3, b2, b1, b0};

    // Si b es cero, se indica el error y se conserva a como residuo.
    assign division_por_cero = (b == 4'b0000);
    assign cociente = division_por_cero ? 4'b0000 : a / b;
    assign residuo  = division_por_cero ? a : a % b;
endmodule
