// Suma dos numeros de 4 bits sin signo. El quinto bit es el acarreo.
module sumador (
    input  logic a3, a2, a1, a0,
    input  logic b3, b2, b1, b0,
    output logic [3:0] suma,
    output logic       acarreo
);
    logic [3:0] a;
    assign a = {a3, a2, a1, a0};
    logic [3:0] b;
    assign b = {b3, b2, b1, b0};

    assign {acarreo, suma} = {1'b0, a} + {1'b0, b};
endmodule
