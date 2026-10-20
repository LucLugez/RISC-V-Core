// File name: signextender.sv
// File description: This module sign extends immediate values used in instructions

module signextender(
    input logic [24:0] raw_src,
    input logic imm_src,

    output logic [31:0] imm_ext
); 

logic [11:0] immediate;

// Describe how to get the immediate
always_comb begin
    case (imm_src)
        0       :   immediate = raw_src[24:13];
        
        1       :   immediate = {raw_src[24:18], raw_src[4:0]};

        default :   immediate = 12'b0;
    endcase
end

// Sign extend the immediate
assign imm_ext = { {20{immediate[11]}}, immediate }; // Copies the msb of immediate 20 times and concatanates

endmodule