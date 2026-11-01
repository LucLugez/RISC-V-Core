// File name: cpu_tb.sv
// File description: Testbench for the full RISC-V cpu datapath

`timescale 1ns / 1ps

module cpu_tb;

// Inputs to DUT
logic clk;
logic rst;

// Instantiate the DUT
cpu cpu_test (
    .clk(clk),
    .rst(rst)
);

// Generate 100MHz clk (10ns period)
initial clk = 0;
always begin
#5 clk = ~clk;
end


// Tests
initial begin
    $display("Starting RISC-V CPU lw Testbench...");

    // Get waveforms
    $dumpfile("sim/cpu_tb.vcd");
    $dumpvars(0, cpu_tb);

    // Assert reset to initialize PC to 0
    rst = 1;
    @(posedge clk);
    #1; // Delay after clock edge
    rst = 0;

    // Step through several clock cycles
    repeat (5) begin
        #1; // Wait for combinational logic to settle after posedge
        $display("Time: %0t | PC: 0x%08h | Instr: 0x%08h | ALU Addr: 0x%08h | MemRead: 0x%08h | RegWrite: %b | DestReg: x%0d",
                    $time, cpu_test.pc, cpu_test.instruction, cpu_test.aluResult, cpu_test.mem_read, cpu_test.reg_write, cpu_test.dest_reg);
        @(posedge clk);
    end

    $display("Test Complete.");
    $finish;
end




endmodule