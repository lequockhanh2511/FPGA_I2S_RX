
`timescale 1ns/1ps

module tb_i2s_rx_auto;

    reg clk = 0;
    reg rst_n = 0;
    reg sd = 0;

    wire bclk, ws;
    wire signed [23:0] sample_data;
    wire sample_valid;

    reg [23:0] audio_sample = 24'h123456;
    reg [23:0] expected_data;

    integer bit_index;
    integer pass_count = 0;
    integer fail_count = 0;

    // Clock 27 MHz
    always #18.5185 clk = ~clk;

    i2s_clock_gen clock_gen (
        .clk(clk),
        .rst_n(rst_n),
        .bclk(bclk),
        .ws(ws)
    );

    i2s_rx receiver (
        .clk(clk),
        .rst_n(rst_n),
        .bclk(bclk),
        .ws(ws),
        .sd(sd),
        .sample_data(sample_data),
        .sample_valid(sample_valid)
    );

    // Gia lap microphone INMP441
    always @(negedge bclk) begin
        if (!rst_n)
            sd = 0;
        else if (ws == 0) begin
            bit_index = clock_gen.bit_count;

            if (bit_index >= 1 && bit_index <= 24)
                sd = audio_sample[24-bit_index];
            else
                sd = 0;
        end
        else
            sd = 0;
    end

    // Tu dong kiem tra khi nhan du mau
    always @(posedge clk) begin
        if (rst_n && sample_valid) begin
            if (sample_data === expected_data) begin
                $display("PASS: Received %h", sample_data);
                pass_count = pass_count + 1;
            end
            else begin
                $display("FAIL: Expected %h, Got %h",
                         expected_data, sample_data);
                fail_count = fail_count + 1;
            end
        end
    end

    // Thay doi mau khi ket thuc moi khung
    task test_sample;
        input [23:0] value;
        begin
            @(posedge ws);
            audio_sample = value;
            expected_data = value;

            // Cho khung Left tiep theo
            @(posedge ws);
        end
    endtask

    initial begin
        expected_data = 24'h123456;

        #200;
        rst_n = 1;

        test_sample(24'h000000);
        test_sample(24'h7FFFFF);
        test_sample(24'h800000);
        test_sample(24'hFFFFFF);
        test_sample(24'h555555);
        test_sample(24'hAAAAAA);

        #50000;

        $display("-------------------------");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);
        $display("-------------------------");

        $stop;
    end

endmodule
