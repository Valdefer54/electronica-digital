// iverilog -g2012 -Wall -s prueba_exhaustiva -o /tmp/prueba_exhaustiva *.sv tests/prueba_exhaustiva.sv
// vvp /tmp/prueba_exhaustiva
module prueba_exhaustiva;
    logic [3:0] a, b, entrada;
    logic [1:0] codigo_decoder;
    logic sel;

    wire [3:0] salida_decoder, salida_mux;
    wire [1:0] codigo_encoder;
    wire valido;
    wire [3:0] suma, suma_mux, diferencia, producto_2bits;
    wire acarreo, acarreo_mux, prestamo, suma_media, acarreo_medio;
    wire [7:0] producto;

    decoder decodificador (
        .codigo1(codigo_decoder[1]), .codigo0(codigo_decoder[0]), .salida(salida_decoder)
    );
    encoder codificador (
        .entrada3(entrada[3]), .entrada2(entrada[2]), .entrada1(entrada[1]), .entrada0(entrada[0]),
        .codigo(codigo_encoder), .valido(valido)
    );
    mux multiplexor (
        .a3(a[3]), .a2(a[2]), .a1(a[1]), .a0(a[0]),
        .b3(b[3]), .b2(b[2]), .b1(b[1]), .b0(b[0]),
        .sel(sel), .salida(salida_mux)
    );
    sumador suma_directa (
        .a3(a[3]), .a2(a[2]), .a1(a[1]), .a0(a[0]),
        .b3(b[3]), .b2(b[2]), .b1(b[1]), .b0(b[0]),
        .suma(suma), .acarreo(acarreo)
    );
    sumador_con_mux suma_con_mux (
        .a3(a[3]), .a2(a[2]), .a1(a[1]), .a0(a[0]),
        .b3(b[3]), .b2(b[2]), .b1(b[1]), .b0(b[0]),
        .suma(suma_mux), .acarreo(acarreo_mux)
    );
    restador resta (
        .a3(a[3]), .a2(a[2]), .a1(a[1]), .a0(a[0]),
        .b3(b[3]), .b2(b[2]), .b1(b[1]), .b0(b[0]),
        .diferencia(diferencia), .prestamo(prestamo)
    );
    multiplicador mult_4bits (
        .a3(a[3]), .a2(a[2]), .a1(a[1]), .a0(a[0]),
        .b3(b[3]), .b2(b[2]), .b1(b[1]), .b0(b[0]), .producto(producto)
    );
    multiplicador_2bits_en_papel mult_2bits (
        .a1(a[1]), .a0(a[0]), .b1(b[1]), .b0(b[0]), .producto(producto_2bits)
    );
    multiplicador_2bits_medio_sumador medio_sumador (
        .a(a[0]), .b(b[0]), .suma(suma_media), .acarreo(acarreo_medio)
    );

    initial begin
        int casos;
        logic [3:0] salida_esperada;
        logic [1:0] codigo_esperado;
        casos = 0;

        for (int i = 0; i < 4; i++) begin
            codigo_decoder = 2'(i);
            salida_esperada = 4'b0000;
            salida_esperada[i] = 1'b1;
            #1;
            if (salida_decoder !== salida_esperada)
                $fatal(1, "decoder codigo=%0d: esperado=%b obtenido=%b", i, salida_esperada, salida_decoder);
            casos++;
        end

        for (int i = 0; i < 16; i++) begin
            entrada = 4'(i);
            codigo_esperado = 2'd0;
            for (int bit_activo = 0; bit_activo < 4; bit_activo++) begin
                if (entrada[bit_activo])
                    codigo_esperado = 2'(bit_activo);
            end
            #1;
            if ({valido, codigo_encoder} !== {(i != 0), codigo_esperado})
                $fatal(1, "encoder entrada=%b: esperado=%b/%b obtenido=%b/%b",
                       entrada, (i != 0), codigo_esperado, valido, codigo_encoder);
            casos++;
        end

        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                a = 4'(i);
                b = 4'(j);
                sel = 1'b0;
                #1;
                if ({acarreo, suma} !== 5'(i + j))
                    $fatal(1, "sumador a=%0d b=%0d: esperado=%0d obtenido=%0d",
                           i, j, i + j, {acarreo, suma});
                if ({acarreo_mux, suma_mux} !== 5'(i + j))
                    $fatal(1, "sumador_con_mux a=%0d b=%0d: esperado=%0d obtenido=%0d",
                           i, j, i + j, {acarreo_mux, suma_mux});
                if ({prestamo, diferencia} !== {(i < j), 4'(i - j)})
                    $fatal(1, "restador a=%0d b=%0d: esperado=%b/%b obtenido=%b/%b",
                           i, j, (i < j), 4'(i - j), prestamo, diferencia);
                if (producto !== 8'(i * j))
                    $fatal(1, "multiplicador a=%0d b=%0d: esperado=%0d obtenido=%0d",
                           i, j, i * j, producto);
                if (salida_mux !== a)
                    $fatal(1, "mux sel=0 a=%0d b=%0d: esperado=%0d obtenido=%0d", i, j, a, salida_mux);
                sel = 1'b1;
                #1;
                if (salida_mux !== b)
                    $fatal(1, "mux sel=1 a=%0d b=%0d: esperado=%0d obtenido=%0d", i, j, b, salida_mux);
                casos += 6;
            end
        end

        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 4; j++) begin
                a = 4'(i);
                b = 4'(j);
                #1;
                if (producto_2bits !== 4'(i * j))
                    $fatal(1, "multiplicador_2bits_en_papel a=%0d b=%0d: esperado=%0d obtenido=%0d",
                           i, j, i * j, producto_2bits);
                casos++;
                if (i < 2 && j < 2) begin
                    if ({acarreo_medio, suma_media} !== 2'(i + j))
                        $fatal(1, "medio sumador a=%0d b=%0d: esperado=%0d obtenido=%0d",
                               i, j, i + j, {acarreo_medio, suma_media});
                    casos++;
                end
            end
        end

        $display("OK: %0d casos aprobados", casos);
        $finish;
    end
endmodule
