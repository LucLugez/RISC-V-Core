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



// ----------REGFILE----------
// Inputs to regfile
logic [4:0] source_reg1;
assign source_reg1 = instruction[19:15];
logic source_reg2;
assign source_reg2 = instruction[24:20];
logic [4:0] dest_reg;
assign dest_reg = instruction[11:7];

// Outputs from regfile
logic [31:0] read_reg1;
logic [31:0] read_reg2;

// Write back to regfile
logic [31:0] mem_read;
logic [31:0] write_back_data; 

always_comb begin : write_back_select
    // Need to add more features depending on instruction
    write_back_data = mem_read;
end

regfile regfile_top(
    // Clock and reset
    .clk(clk),
    .rst(rst),

    // Read input
    .address_1(source_reg1),
    .address_2(source_reg2),
    // Read output
    .read_data_1(read_reg1),
    .read_data_2(read_reg2),

    // Write input
    .write_en(reg_write), // From controller
    .address3(dest_reg),
    .write_data(write_back_data) // Depends on instruction
);

//-----------------------------



//----------SIGN EXTENDER----------
// Inputs to signextender
logic [24:0] raw_src;
assign raw_src = instruction[31:7]; // First 24 bits of instruction

// Outputs from signextender
logic imm_ext;

signextender sign_ex_top(
    // Inputs
    .imm_src(imm_src), // From controller
    .raw_src(raw_src),
    // Outputs
    .imm_ext(imm_ext)
);

//---------------------------------


endmodule