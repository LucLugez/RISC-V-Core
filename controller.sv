// File name: controller.sv
// File description: Logic describing the controller which outputs control bits for the RISC-V processor

module controller (
    input logic [6:0] op,
    input logic [2:0] func3,
    input logic       func7,
    input logic       alu_zero,

    output logic [2:0] alu_control,
    output logic [1:0] imm_src,
    output logic       mem_write,
    output logic       reg_write
);


// Input to the alu decoder
logic [1:0] alu_op;

// Main decoder logic
always_comb begin
    case (op)
        // lw instruction
        7'b0000011 : begin
            reg_write = 1'b1;
            imm_src = 2'b00;
            mem_write = 1'b0;
            alu_op = 2'b00;
        end
        
        default : begin
            reg_write = 1'b0;
            imm_src = 2'b00;
            mem_write = 1'b0;
            alu_op = 2'b00;
        end
    endcase
end 


// ALU Decoder Logic
always_comb begin
    case (alu_op)
        // lw, sw instruction
        2'b00 : alu_control = 3'b000; // 3'b000 means add

        default : alu_control = 3'b111;
    endcase
end

endmodule