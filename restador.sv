// Resta a - b en 4 bits. prestamo vale 1 cuando a es menor que b.
module restador (
    input  logic a3, a2, a1, a0,
    input  logic b3, b2, b1, b0,
    output logic [3:0] diferencia,
    output logic       prestamo
);
    logic [3:0] a;
    assign a = {a3, a2, a1, a0};
    logic [3:0] b;
    assign b = {b3, b2, b1, b0};

    assign {prestamo, diferencia} = {1'b0, a} - {1'b0, b};
endmodule
