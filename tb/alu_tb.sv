// File name: alu_tb.sv
// File description: Testbench for RISC-V ALU

module alu_tb;
// Inputs to the DUT
logic [31:0] srcA;
logic [31:0] srcB;
logic [2:0]  aluControl;

// Outputs from the DUT
logic [31:0] aluResult;


// Instantiate the DUT
alu alu_test(
    .srcA      (srcA),
    .srcB      (srcB),
    .aluControl(aluControl),
    .aluResult (aluResult)
);


// Test the DUT
initial begin
    // Test to make sure that, currently, only the control signal 000 allows anything to happen
    $display("-----TEST 1----- aluControl that's not 000. Expected output is all 0s");
    aluControl = 3'b001;  srcA = 200;  srcB = 300;
    
    #10 // Lets result propagate combinationally
    $display("ALU Result: %b", aluResult);


    // Test to make sure addition works
    $display("-----TEST 2----- aluControl = 000, addition. Expected output is the sum of srcA and srcB");
    aluControl = 3'b000;  srcA = 1000;  srcB = 2000;
    #10 $display("ALU Result (%0d + %0d): %0d", srcA, srcB, aluResult);

end

endmodule