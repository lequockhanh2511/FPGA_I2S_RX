
`timescale 1ns/1ps

module tb_i2s_rx;

    reg clk = 0;
    reg rst_n = 0;
    reg sd = 0;

    wire bclk;
    wire ws;
    wire signed [23:0] sample_data;
    wire sample_valid;

    // Clock he thong 27 MHz
    always #18.5185 clk = ~clk;

    // Bo tao clock I2S
    i2s_clock_gen clock_gen (
        .clk(clk),
        .rst_n(rst_n),
        .bclk(bclk),
        .ws(ws)
    );

    // Bo thu I2S
    i2s_rx receiver (
        .clk(clk),
        .rst_n(rst_n),
        .bclk(bclk),
        .ws(ws),
        .sd(sd),
        .sample_data(sample_data),
        .sample_valid(sample_valid)
    );

    // Mau du lieu microphone gia lap
    reg [23:0] audio_sample = 24'h800000;

    integer bit_index;

    // Microphone thay doi SD tren canh xuong BCLK
    // FPGA thu du lieu tren canh len BCLK
    always @(negedge bclk) begin
        if (!rst_n) begin
            sd = 0;
        end
        else if (ws == 0) begin
            bit_index = clock_gen.bit_count;

            if (bit_index >= 1 && bit_index <= 24)
                sd = audio_sample[24-bit_index];
            else
                sd = 0;
        end
        else begin
            sd = 0;
        end
    end

    initial begin
        #200;
        rst_n = 1;

        // Chay trong 200 us
        #200000;

        $stop;
    end

endmodule
