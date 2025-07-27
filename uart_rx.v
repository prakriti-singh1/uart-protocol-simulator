
module uart_rx(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);
    parameter CLK_FREQ = 50000000;
    parameter BAUD_RATE = 9600;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    localparam IDLE = 0,
               START = 1,
               DATA = 2,
               STOP = 3;

    reg [1:0] state = IDLE;
    reg [12:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] shift_reg = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= 0;
            rx_data <= 0;
            rx_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;
                    if (rx == 0) begin
                        rx_done <= 0;
                        state <= START;
                    end
                end

                START: begin
                    if (clk_count == (CLKS_PER_BIT - 1)/2) begin
                        clk_count <= 0;
                        state <= DATA;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                DATA: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        shift_reg[bit_index] <= rx;
                        if (bit_index < 7)
                            bit_index <= bit_index + 1;
                        else
                            state <= STOP;
                    end
                end

                STOP: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        rx_data <= shift_reg;
                        rx_done <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
