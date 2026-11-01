// File name: controller_tb.sv
// File description: Testbench for RISC-V controller module

module controller_tb;

// Inputs to DUT
logic [6:0] op;
logic [2:0] func3;
logic       func7;
logic       alu_zero;

// Outputs from DUT
logic [2:0] alu_control;
logic [1:0] imm_src;
logic       mem_write;
logic       reg_write;


// Instantiate the DUT
controller ctrl_test (
    .op         (op),
    .func3      (func3),
    .func7      (func7),
    .alu_zero   (alu_zero),
    .alu_control(alu_control),
    .imm_src    (imm_src),
    .mem_write  (mem_write),
    .reg_write  (reg_write)
);


// Begin test
initial begin
    // Test lw instruction
    $display("-----TEST 1----- op = 0000011 -> lw instruction. reg_write should = 1, alu_control = 000, rest 0");
    op = 7'b0000011;  // func3 and func7 don't matter in this case
    #2 // Wait for combinational logic to propagate
    $display("reg_write = %b  |  alu_control = %b  |  imm_src = %b  |  mem_write = %b", reg_write, alu_control, imm_src, mem_write);


    // Test default behavior
    $display("-----TEST 2----- op != 0000011 -> for now all outputs should be zero");
    op = 7'b1110000;  func3 = 3'b101;  func7 = 0;  // Put func3 and func7 just for testing purposes, even though they're not important here
    #2 
    $display("reg_write = %b  |  alu_control = %b  |  imm_src = %b  |  mem_write = %b", reg_write, alu_control, imm_src, mem_write);


    $finish;
end

endmodule