# UART Protocol Simulator (Verilog)

This project implements a **Universal Asynchronous Receiver Transmitter (UART)** protocol in Verilog, simulating both the **transmitter (TX)** and **receiver (RX)** modules with loopback testing. It is designed as a **core ECE project**, demonstrating digital communication principles, finite state machines (FSM), and timing-based serial protocols.

>  Verified using Vivado 2025.1  
>  Suitable for FPGA implementation or behavioral simulation

---

##  Features

- ✔ FSM-based UART Transmitter
- ✔ FSM-based UART Receiver with mid-bit sampling
- ✔ Baud rate and clock frequency parameterization
- ✔ Loopback module for internal TX → RX connection
- ✔ Testbench with monitoring, timeout handling, and waveform-friendly structure

---

##  Project Structure

| File              | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `uart_tx.v`       | UART transmitter: sends 8-bit data with START and STOP bits using FSM      |
| `uart_rx.v`       | UART receiver: detects start bit, samples incoming bits at mid-bit timing  |
| `uart_loopback.v` | Top-level module connecting TX and RX internally for simulation            |
| `tb_uart.v`       | Testbench for simulating UART loopback with output display and timeout     |
| `README.md`       | Project documentation (you are here!)                                      |

---

##  Simulation Details

- **Clock Frequency:** 50 MHz  
- **Baud Rate:** 9600  
- **Bit Format:** 1 Start bit, 8 Data bits, 1 Stop bit  
- **Loopback Mode:** Transmitted byte is internally routed to receiver for validation.


