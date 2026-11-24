`timescale 1ns/1ps

module demux_tb;
    logic dato, sel1, sel0;
    wire salida0, salida1, salida2, salida3;
    wire [3:0] salidas = {salida3, salida2, salida1, salida0};
    logic [3:0] esperado;
    integer i;

    demux dut (.*);

    initial begin
        $display("dato sel1 sel0 | salida3 salida2 salida1 salida0");
        for (i = 0; i < 8; i = i + 1) begin
            {dato, sel1, sel0} = i[2:0];
            // Tabla de verdad independiente de las ecuaciones del circuito.
            case ({dato, sel1, sel0})
                3'b100: esperado = 4'b0001;
                3'b101: esperado = 4'b0010;
                3'b110: esperado = 4'b0100;
                3'b111: esperado = 4'b1000;
                default: esperado = 4'b0000;
            endcase
            #1;
            if (salidas !== esperado)
                $fatal(1, "FALLO: entrada=%b%b%b obtenido=%b esperado=%b",
                       dato, sel1, sel0, salidas, esperado);
            $display("  %b    %b    %b  | %b", dato, sel1, sel0, salidas);
        end

        // Repetir en orden inverso comprueba transiciones y ausencia de memoria.
        for (i = 7; i >= 0; i = i - 1) begin
            {dato, sel1, sel0} = i[2:0];
            case (i)
                4: esperado = 4'b0001;
                5: esperado = 4'b0010;
                6: esperado = 4'b0100;
                7: esperado = 4'b1000;
                default: esperado = 4'b0000;
            endcase
            #1;
            if (salidas !== esperado)
                $fatal(1, "FALLO en recorrido inverso: entrada=%b%b%b obtenido=%b esperado=%b",
                       dato, sel1, sel0, salidas, esperado);
        end
        $display("PASS: 8/8 combinaciones, 16 comprobaciones sin errores.");
        $finish;
    end
endmodule
