// Entrada paralela, salida serie. Transmite primero entrada[3].
// cargar=1 carga el dato; cargar=0 desplaza e introduce un cero.
// reset sincrono activo en 1 tiene prioridad sobre cargar.
module piso (
    input wire clk,
    input wire reset,
    input wire cargar,
    input wire [3:0] entrada,
    output wire salida
);
    reg [3:0] registro;

    always @(posedge clk) begin
        if (reset)
            registro <= 4'b0000;
        else if (cargar)
            registro <= entrada;
        else
            registro <= {registro[2:0], 1'b0};
    end

    assign salida = registro[3];
endmodule
