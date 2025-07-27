module uart_tx(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    parameter CLK_FREQ = 50000000;
    parameter BAUD_RATE = 9600;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [3:0] bit_index = 0;
    reg [12:0] clk_count = 0;
    reg [7:0] shift_reg;
    reg [2:0] state = 0;

    localparam IDLE = 0,
               START = 1,
               DATA = 2,
               STOP = 3,
               CLEANUP = 4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 0;
            clk_count <= 0;
            bit_index <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 0;
                    clk_count <= 0;
                    bit_index <= 0;
                    if (tx_start) begin
                        tx_busy <= 1;
                        shift_reg <= tx_data;
                        state <= START;
                    end
                end
                START: begin
                    tx <= 0;
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= DATA;
                    end
                end
                DATA: begin
                    tx <= shift_reg[bit_index];
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        if (bit_index < 7)
                            bit_index <= bit_index + 1;
                        else
                            state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1;
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= CLEANUP;
                    end
                end
                CLEANUP: begin
                    tx_busy <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

