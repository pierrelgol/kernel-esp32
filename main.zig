const std = @import("std");

fn uart_print(msg: []const u8) void {
    const UART_FIFO: *volatile u8 = @ptrFromInt(0x3FF40000);
    for (msg) |c| {
        UART_FIFO.* = c;
    }
}

pub export fn call_start_cpu0() void {
    uart_print("Booting microkernel...\n");

    while (true) {
        uart_print("hi\n");
    }
}
