`timescale 1ns/1ps

// Contador ascendente de 4 bits: 0 a 15 y vuelve a 0.
// Reset sincrono activo en 1; cuenta en el flanco de subida.
module contador (
    input logic clk,
    input logic reset,
    input logic habilitar,
    output logic [3:0] cuenta
);
    always_ff @(posedge clk) begin
        if (reset)
            cuenta <= 4'b0000;
        else if (habilitar)
            cuenta <= cuenta + 4'b0001;
    end
endmodule
