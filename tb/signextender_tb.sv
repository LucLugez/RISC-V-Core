// File name: signextender_tb.sv
// File description: Testbench for the signextender module for RISC_v

module signextender_tb;
// Inputs to the DUT
logic [24:0] raw_src;
logic        imm_src;

// Outputs from the DUT
logic [31:0] imm_ext;


// Instantiate the DUT
signextender signext_test(
    .raw_src(raw_src),
    .imm_src(imm_src),
    .imm_ext(imm_ext)
);


// Test the DUT
initial begin
    // Test where immediate is in the first 12 bits of the instruction
    $display("-----TEST 1----- imm_src = 0, lw instruction. Expected output is sign extended input");
    imm_src = 0;  raw_src = 25'b1111111111001101000110111;  // Only the first 12 bits (-4) of raw_src are the immediate value
    #10 // Wait for output to propagate
    $display("SignExtender output with -4 as input: %b", imm_ext);


    // Test where the immediate is positive, so should be zero extended
    $display("-----TEST 2----- imm_src = 0, lw instruction. Expected output is sign extended input");
    imm_src = 0;  raw_src = 25'b0000111100101111111100000;  // Only the first 12 bits (242) of raw_src are the immediate value
    #10 // Wait for output to propagate
    $display("SignExtender output with 242 as input: %b", imm_ext);


    // Test where immediate is scrambled in the 25 bits from the instruction
    $display("-----TEST 3----- imm_src = 1, sw instruction. Expected output is sign extended input");
    imm_src = 1;  raw_src = 25'b0000000001100100101001000;  // The immediate is 000000001000 = 8. Bits 24-18, 4-0.
    #10 // Wait for output to propagate
    $display("SignExtender output with 8 as input: %b", imm_ext);

    $finish;
end


endmodule