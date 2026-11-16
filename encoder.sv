// Codificador de prioridad 4 a 2. Gana la entrada activa de mayor indice.
// valido indica si hay al menos una entrada activa.
module encoder (
    input  logic entrada3, entrada2, entrada1, entrada0,
    output logic [1:0] codigo,
    output logic       valido
);
    logic [3:0] entrada;
    assign entrada = {entrada3, entrada2, entrada1, entrada0};

    assign valido = |entrada;
    assign codigo = entrada[3] ? 2'd3 :
                    entrada[2] ? 2'd2 :
                    entrada[1] ? 2'd1 : 2'd0;
endmodule
