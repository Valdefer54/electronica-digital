// Demultiplexor 1 a 4. sel1 sel0 elige la salida que recibe dato.
module demux (
    input  logic dato,
    input  logic sel1, sel0,
    output logic salida0, salida1, salida2, salida3
);
    assign salida0 = dato & ~sel1 & ~sel0; // 00
    assign salida1 = dato & ~sel1 &  sel0; // 01
    assign salida2 = dato &  sel1 & ~sel0; // 10
    assign salida3 = dato &  sel1 &  sel0; // 11
endmodule
