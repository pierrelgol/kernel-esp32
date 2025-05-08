const std = @import("std");

pub export fn call_start_cpu0() void {
    const UART_FIFO: *volatile u32 = @ptrFromInt(0x3FF40000);
    UART_FIFO.* = 'H';
    UART_FIFO.* = 'i';
    UART_FIFO.* = '\n';

    while (true) {
        UART_FIFO.* = 'H';
        UART_FIFO.* = 'i';
        UART_FIFO.* = '\n';
    }
}
