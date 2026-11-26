// Multiplexor 2 a 1 de 4 bits. sel = 0 elige a; sel = 1 elige b.
module mux (
    input  logic a3, a2, a1, a0,
    input  logic b3, b2, b1, b0,
    input  logic       sel,
    output logic [3:0] salida
);
    logic [3:0] a;
    assign a = {a3, a2, a1, a0};
    logic [3:0] b;
    assign b = {b3, b2, b1, b0};

    assign salida = sel ? b : a;
endmodule
