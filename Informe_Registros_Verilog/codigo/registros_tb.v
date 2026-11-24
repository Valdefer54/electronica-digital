`timescale 1ns/1ps
// iverilog -g2012 -s registros_tb -o /tmp/registros_tb siso.v sipo.v piso.v pipo.v registros_tb.v
// vvp /tmp/registros_tb
module registros_tb;
    reg clk = 0;
    reg reset = 1;
    reg serie = 0;
    reg cargar = 0;
    reg [3:0] paralelo = 0;
    wire salida_siso, salida_piso;
    wire [3:0] salida_sipo, salida_pipo;
    integer esperado_serie = 0;
    integer esperado_piso = 0;
    integer esperado_pipo = 0;
    integer ciclos = 0;
    integer patron, bit_n, estado, dato, r, c;
    reg [31:0] aleatorio = 32'h12345678;
    reg [9:0] anterior;

    siso u_siso(.clk(clk), .reset(reset), .entrada(serie), .salida(salida_siso));
    sipo u_sipo(.clk(clk), .reset(reset), .entrada(serie), .salida(salida_sipo));
    piso u_piso(.clk(clk), .reset(reset), .cargar(cargar), .entrada(paralelo), .salida(salida_piso));
    pipo u_pipo(.clk(clk), .reset(reset), .entrada(paralelo), .salida(salida_pipo));

    always #5 clk = ~clk;

    task verificar;
        begin
            if (salida_siso !== (esperado_serie >= 8) ||
                salida_sipo !== esperado_serie[3:0] ||
                salida_piso !== (esperado_piso >= 8) ||
                salida_pipo !== esperado_pipo[3:0]) begin
                $display("Ciclo %0d: reset=%b cargar=%b serie=%b paralelo=%b",
                         ciclos, reset, cargar, serie, paralelo);
                $display("Actual SISO=%b SIPO=%b PISO=%b PIPO=%b",
                         salida_siso, salida_sipo, salida_piso, salida_pipo);
                $display("Esperado SISO=%b SIPO=%b PISO=%b PIPO=%b",
                         (esperado_serie >= 8), esperado_serie[3:0],
                         (esperado_piso >= 8), esperado_pipo[3:0]);
                $fatal(1, "Salida incorrecta o desconocida");
            end
        end
    endtask

    task paso;
        input nuevo_reset, nueva_carga, nuevo_serie;
        input [3:0] nuevo_paralelo;
        begin
            @(negedge clk);
            anterior = {salida_siso, salida_sipo, salida_piso, salida_pipo};
            reset = nuevo_reset;
            cargar = nueva_carga;
            serie = nuevo_serie;
            paralelo = nuevo_paralelo;
            #1;
            if ({salida_siso, salida_sipo, salida_piso, salida_pipo} !== anterior)
                $fatal(1, "Las salidas cambiaron sin flanco de subida");
            @(posedge clk);
            if (reset) begin
                esperado_serie = 0;
                esperado_piso = 0;
                esperado_pipo = 0;
            end else begin
                esperado_serie = (esperado_serie * 2 + serie) % 16;
                if (cargar)
                    esperado_piso = paralelo;
                else
                    esperado_piso = (esperado_piso * 2) % 16;
                esperado_pipo = paralelo;
            end
            ciclos = ciclos + 1;
            #1;
            verificar;
        end
    endtask

    initial begin
        // El primer flanco de reset elimina los valores de encendido desconocidos.
        @(posedge clk);
        #1;
        verificar;

        // Todas las palabras: entrada serie, salida serie y vaciado con ceros.
        for (patron = 0; patron < 16; patron = patron + 1) begin
            paso(1, 1, 1, 15);
            paso(0, 1, 0, patron);
            for (bit_n = 3; bit_n >= 0; bit_n = bit_n - 1)
                paso(0, 0, (patron >> bit_n) & 1, patron);
            for (bit_n = 0; bit_n < 4; bit_n = bit_n + 1)
                paso(0, 0, 0, 0);
        end

        // Todas las transiciones PISO: estado, reset, carga y dato.
        for (estado = 0; estado < 16; estado = estado + 1)
            for (r = 0; r < 2; r = r + 1)
                for (c = 0; c < 2; c = c + 1)
                    for (dato = 0; dato < 16; dato = dato + 1) begin
                        paso(0, 1, 1, estado);
                        paso(r, c, dato & 1, dato);
                    end

        // Secuencia reproducible con cargas, resets y entradas mezcladas.
        for (bit_n = 0; bit_n < 4096; bit_n = bit_n + 1) begin
            aleatorio = aleatorio * 32'd1664525 + 32'd1013904223;
            paso(aleatorio[31:28] == 0, aleatorio[20],
                 aleatorio[16], aleatorio[11:8]);
        end
        $display("OK: SISO, SIPO, PISO y PIPO; %0d ciclos verificados", ciclos);
        $finish;
    end

    initial begin
        #100000;
        $fatal(1, "Tiempo de simulacion agotado");
    end
endmodule
