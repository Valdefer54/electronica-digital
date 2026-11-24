// Entrada serie, salida serie. Registro de 4 bits, salida por el MSB.
// reset sincrono activo en 1; actualizacion en el flanco de subida.
module siso (
    input wire clk,
    input wire reset,
    input wire entrada,
    output wire salida
);
    reg [3:0] registro;

    always @(posedge clk) begin
        if (reset)
            registro <= 4'b0000;
        else
            registro <= {registro[2:0], entrada};
    end

    assign salida = registro[3];
endmodule
