// Entrada serie, salida paralela. El bit nuevo entra por salida[0].
// reset sincrono activo en 1; actualizacion en el flanco de subida.
module sipo (
    input wire clk,
    input wire reset,
    input wire entrada,
    output reg [3:0] salida
);
    always @(posedge clk) begin
        if (reset)
            salida <= 4'b0000;
        else
            salida <= {salida[2:0], entrada};
    end
endmodule
