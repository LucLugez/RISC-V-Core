// File name: regfile_tb.sv
// File description: Testbench for register file module for RISC-V

module regfile_tb;
// Inputs to DUT
logic [4:0]  address_1;
logic [4:0]  address_2;
logic [4:0]  address_3;
logic [31:0] write_data;
logic        write_en;
logic        reset;
logic        clk;

// Outputs from DUT
logic [31:0] read_data_1;
logic [31:0] read_data_2;


// Instantiate the DUT
regfile regfile_test(
    .address_1  (address_1),
    .address_2  (address_2),
    .address_3  (address_3),
    .write_data (write_data),
    .write_en   (write_en),
    .reset      (reset),
    .clk        (clk),
    .read_data_1(read_data_1),
    .read_data_2(read_data_2)
);

// Generate clock
initial begin
    clk = 0;
end
always begin
    #5 clk = !clk;
end

// Test the DUT
initial begin
   
    // Try writing when write_en is not high
    reset = 1;
    #20 $display("-----TEST 1-----");
    $display("Writing when write_en is not high. Expected output is all zeros in register file");
    write_en = 0;  reset = 0;  address_3 = 0;  write_data = 32'hAABBCCDD;  #10  // Wait for signals to propagate
    
    // Check all registers with address_1
    for (int i = 0; i < 32; i++) begin
        address_1 = i; #10 // Wait for updated address_1 to reflect in read_data_1
        $display("From address_1, data in x%0d: %b", i, read_data_1);
    end

    // Check all registers with address_2
    for (int i = 0; i < 32; i++) begin
        address_2 = i; #10 // Wait for updated address_2 to reflect in read_data_2
        $display("From address_2, data in x%0d: %b", i, read_data_2);
    end

    // Normal write and check
    #20 $display("-----TEST 2-----");
    $display(" Writing to every register. Expected output is the correct values in each register after writing");
    write_en = 1;  reset = 0;
    // Writing to each register, including x0 to ensure nothing gets written to it
    for (int i = 0; i < 32; i++) begin
        @(negedge clk) address_3 = i;  write_data = i;
    end
    #20 write_en = 0;// Check all register values with address 1 and 2
    for (int i = 0; i < 32; i++) begin
        address_1 = i;  address_2 = i; #20
        $display("From address_1, data in x%0d: %b  |  From address_2, data in x%0d: %b", i, read_data_1, i, read_data_2);
    end

    $finish;
end

endmodule