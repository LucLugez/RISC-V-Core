// File name: alu.sv
// File description: ALU for RISC-V Processor, capable of various operations

module alu(
    input logic [31:0]  srcA,
    input logic [31:0]  srcB,
    input logic [2:0]   aluControl,

    output logic [31:0] aluResult
    output logic        zero_flag
);

// Describe ALU combinational logic
always_comb begin
    case (aluControl)
        3'b000   :   aluResult = srcA + srcB;

        default  :   aluResult = 32'b0;

    endcase
end

assign zero_flag = aluResult == 32'b0;

endmodule