// File name: cpu.sv
// File description: Top level file for the RISC-V cpu. Instantiating all the pieces and connecting them together.

module cpu (
    input logic clk,
    input logic rst
);


// ----------PROGRAM COUNTER----------
logic [31:0] pc;
logic [31:0] pc_next;

always_comb begin : increment_pc
    pc_next = pc + 4;
end

always_ff @(posedge clk) begin
    if (rst)
        pc <= 32'b0;
    else
        pc <= pc_next;
end

// -----------------------------------



// ----------INSTRUCTION MEMORY----------
logic [31:0] instruction;

memory #(
    .mem_init("./test_imemory.hex")
) instruction_memory (
    // Memory inputs
    .clk       (clk),
    .address   (pc),
    .write_data(32'b0),
    .write_en  (1'b0),
    .rst       (1'b0),

    // Memory outputs
    .read_data (instruction)
);

// -------------------------------------



// ----------CONTROLLER----------
// Inputs to controller. Most of them are slices of the 32 bit instruction
logic [6:0] op;
assign op = instruction[6:0];
logic [2:0] func3;
assign func3 = instruction[14:12];
logic alu_zero;

// Outputs from controller
logic [2:0] alu_control;
logic [1:0] imm_src;
logic       mem_write;
logic       reg_write;

controller ctrl_top(
    // Inputs to controller
    .op         (op),
    .func3      (func3),
    .func7      (7'b0),
    .alu_zero   (alu_zero),

    // Outputs from controller
    .alu_control(alu_control),
    .imm_src    (imm_src),
    .mem_write  (mem_write),
    .reg_write  (reg_write),
);

//-------------------------------


endmodule