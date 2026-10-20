// File name: regfile.sv
// File description: Register file containing 32 registers for RISC-V

module regfile(
    input logic [4:0]  address_1,
    input logic [4:0]  address_2,
    input logic [4:0]  address_3,
    input logic [31:0] write_data,
    input logic        write_en,
    input logic        reset,
    input logic        clk,

    output logic [31:0] read_data_1,
    output logic [31:0] read_data_2
);

// Create the 32 registers of 32 bit lengths each
logic [31:0] registers[0:31];


// Describe clocking behavior
always_ff @(posedge clk) begin
    // Active high reset
    if (reset) begin
        // All registers get zero
        for (int i = 0; i < 32; i++) begin
            registers[i] <= 32'b0;
        end
    end
    // Write to the address specified, and cannot write to x0
    else if (write_en && address_3 != 0) begin
        registers[address_3] <= write_data;
    end
end


// Describe read behavior, which is completely combinational
always_comb begin
    if (address_1 != 5'b0)
        read_data_1 = registers[address_1];
    else
        read_data_1 = 32'b0;

    if (address_2 != 5'b0)
        read_data_2 = registers[address_2];
    else
        read_data_2 = 32'b0;
end

endmodule