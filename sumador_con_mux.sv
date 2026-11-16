// Sumador de 4 bits sin signo con propagacion de acarreo.
module sumador_con_mux (
    input  logic a3, a2, a1, a0,
    input  logic b3, b2, b1, b0,
    output logic [3:0] suma,
    output logic       acarreo
);
    logic [3:0] a;
    assign a = {a3, a2, a1, a0};
    logic [3:0] b;
    assign b = {b3, b2, b1, b0};

    logic [4:0] c;
    assign c[0] = 1'b0;
    assign acarreo = c[4];

    for (genvar i = 0; i < 4; i++) begin : etapa
        logic distintos;
        assign distintos = a[i] ^ b[i];

        // Si los operandos difieren, invierte el acarreo para formar la suma
        // y propaga el acarreo a la siguiente etapa.
        assign suma[i] = distintos ? ~c[i] : c[i];
        assign c[i+1] = distintos ? c[i] : a[i];
    end
endmodule
