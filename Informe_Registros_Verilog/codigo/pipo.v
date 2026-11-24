// Entrada paralela, salida paralela. Registro de 4 bits.
// reset sincrono activo en 1; actualizacion en el flanco de subida.
module pipo (
    input wire clk,
    input wire reset,
    input wire [3:0] entrada,
    output reg [3:0] salida
);
    always @(posedge clk) begin
        if (reset)
            salida <= 4'b0000;
        else
            salida <= entrada;
    end
endmodule
