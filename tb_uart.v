`timescale 1ns / 1ps

module tb_uart;
    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    reg [7:0] tx_data = 8'h00;
    wire tx;
    wire [7:0] rx_data;
    wire rx_done;

    uart_loopback uut (
        .clk(clk),
        .rst(rst),
        .tx_start(start),
        .tx_data(tx_data),
        .tx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    always #10 clk = ~clk; // 50 MHz clock

    initial begin
        $display("---- UART Loopback Simulation ----");
        rst = 1;
        #100;
        rst = 0;
        #100;

        tx_data = 8'h41; // ASCII 'A'
        start = 1;
        #20;
        start = 0;
        $display("TX Started at time %0t", $time);

        wait (rx_done);
        #100;
        $display(" RX Completed at %0t. Data received: %h", $time, rx_data);
        $finish;
    end

    initial begin
        $monitor("Time: %0t | tx: %b | rx_data: %h | rx_done: %b", 
                  $time, tx, rx_data, rx_done);
    end

    initial begin
        #2000000;
        $display(" Timeout. RX data: %h | rx_done: %b", rx_data, rx_done);
        $finish;
    end
endmodule
