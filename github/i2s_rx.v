
module i2s_rx (
    input  wire              clk,
    input  wire              rst_n,
    input  wire              bclk,
    input  wire              ws,
    input  wire              sd,

    output reg signed [23:0] sample_data,
    output reg               sample_valid
);

    reg bclk_d;
    reg ws_d;

    reg [5:0] bit_count;
    reg [23:0] shift_reg;

    wire bclk_rise = bclk & ~bclk_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bclk_d       <= 1'b0;
            ws_d         <= 1'b0;
            bit_count    <= 6'd0;
            shift_reg    <= 24'd0;
            sample_data  <= 24'sd0;
            sample_valid <= 1'b0;
        end
        else begin
            bclk_d       <= bclk;
            ws_d         <= ws;
            sample_valid <= 1'b0;

            if (bclk_rise) begin

                // Bat dau mot slot I2S moi
                if (ws != ws_d) begin
                    bit_count <= 6'd0;
                end
                else if (bit_count < 6'd31) begin
                    bit_count <= bit_count + 1'b1;
                end

                // Chi thu kenh Left (WS = 0)
                // Bo qua 1 bit dau theo chuan I2S
                if (ws == 1'b0 &&
                    ws == ws_d &&
                    bit_count >= 6'd1 &&
                    bit_count <= 6'd24) begin

                    shift_reg <= {shift_reg[22:0], sd};

                    // Hoan thanh mau 24-bit
                    if (bit_count == 6'd24) begin
                        sample_data <= {shift_reg[22:0], sd};
                        sample_valid <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
