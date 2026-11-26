// Decodificador 2 a 4. Activa el bit de salida indicado por codigo.
module decoder (
    input  logic codigo1, codigo0,
    output logic [3:0] salida
);
    logic [1:0] codigo;
    assign codigo = {codigo1, codigo0};

    assign salida = 4'b0001 << codigo;
endmodule
