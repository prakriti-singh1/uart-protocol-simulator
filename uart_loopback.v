module uart_loopback(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output wire tx,
    output wire [7:0] rx_data,
    output wire rx_done
);
    wire internal_tx;

    uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(internal_tx),
        .tx_busy()
    );

    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .rx(internal_tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    assign tx = internal_tx;
endmodule

