
`timescale 1ns/1ps

module tb_i2s_rx_final;

    reg clk = 0;
    reg rst_n = 0;
    reg sd = 0;

    wire bclk, ws;
    wire signed [23:0] sample_data;
    wire sample_valid;

    reg [23:0] audio_sample = 24'h123456;
    integer bit_index;
    integer pass_count = 0;
    integer fail_count = 0;
    integer valid_count = 0;

    reg [23:0] last_data = 0;
    reg previous_valid = 0;

    always #18.5185 clk = ~clk;

    i2s_clock_gen clock_gen (
        .clk(clk), .rst_n(rst_n),
        .bclk(bclk), .ws(ws)
    );

    i2s_rx receiver (
        .clk(clk), .rst_n(rst_n),
        .bclk(bclk), .ws(ws), .sd(sd),
        .sample_data(sample_data),
        .sample_valid(sample_valid)
    );

    always @(negedge bclk) begin
        if (!rst_n)
            sd = 0;
        else if (!ws) begin
            bit_index = clock_gen.bit_count;
            if (bit_index >= 1 && bit_index <= 24)
                sd = audio_sample[24-bit_index];
            else
                sd = 0;
        end
        else
            sd = 0;
    end

    always @(posedge clk) begin
        if (rst_n) begin
            if (sample_valid) begin
                valid_count = valid_count + 1;

                if (previous_valid) begin
                    $display("FAIL: valid too long");
                    fail_count = fail_count + 1;
                end

                if (sample_data !== audio_sample) begin
                    $display("FAIL: expected=%h got=%h",
                             audio_sample, sample_data);
                    fail_count = fail_count + 1;
                end
                else begin
                    $display("PASS: %h", sample_data);
                    pass_count = pass_count + 1;
                end
            end
            else if (sample_data !== last_data) begin
                $display("FAIL: data changed without valid");
                fail_count = fail_count + 1;
            end

            previous_valid = sample_valid;
            last_data = sample_data;
        end
    end

    task send_sample;
        input [23:0] value;
        begin
            @(posedge ws);
            audio_sample = value;
            @(posedge ws);
        end
    endtask

    initial begin
        #200;
        rst_n = 1;

        send_sample(24'h000000);
        send_sample(24'h7FFFFF);
        send_sample(24'h800000);
        send_sample(24'hFFFFFF);
        send_sample(24'h555555);
        send_sample(24'hAAAAAA);

        #50000;

        $display("==========================");
        $display("PASS = %0d", pass_count);
        $display("FAIL = %0d", fail_count);
        $display("VALID PULSES = %0d", valid_count);
        $display("==========================");

        $stop;
    end

endmodule
