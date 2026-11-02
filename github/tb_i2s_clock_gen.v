
`timescale 1ns/1ps

module tb_i2s_clock_gen;

    reg clk = 0;
    reg rst_n = 0;
    wire bclk;
    wire ws;

    // Clock 27 MHz, chu ky ~37.037 ns
    always #18.5185 clk = ~clk;

    i2s_clock_gen uut (
        .clk(clk),
        .rst_n(rst_n),
        .bclk(bclk),
        .ws(ws)
    );

    initial begin
        #200;
        rst_n = 1;

        // Mo phong 1 ms
        #1000000;

        $stop;
    end

endmodule
