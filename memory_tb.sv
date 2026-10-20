// File name: memory_tb.sv
// File description: Testbench for data memory module for RISC-V CPU

module memory_tb;

// Declare test signals
// Inputs to DUT
logic [31:0] address;
logic [31:0] write_data;
logic reset;
logic clk;
logic write_en;

// Outputs to DUT
logic [31:0] read_data;

// Instantiate DUT
memory mem_test(
    .address    (address),
    .write_data (write_data),
    .reset      (reset),
    .clk        (clk),
    .write_en   (write_en),
    .read_data  (read_data)
);

// Generate clock
initial clk = 0;
always begin
#1 clk = !clk;
end


// Test the DUT
initial begin

// Test reset
reset = 1;
write_data = 32'b0;
write_en = 0;

#5
for (int i = 0; i < 255; i += 4) begin // Wait a clock cycle
    address = i;
    #5
    $display("While reset, read_data: %b", read_data);
end

// Test write
write_en = 1;
reset = 0;

for (int i = 0; i < 255; i += 4) begin
    address = i;
    write_data = 32'hFEFAAAAA;
    #5
    $display("Data after being written:  %b", read_data);
end
$finish;

end



endmodule