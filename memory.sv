// File name: memory.sv
// File description: Defines the behavior of the data memory for the RISC-V CPU

module memory#(
    parameter WORDS = 64,
    parameter mem_init = ""
)(
    
    input logic [31:0] address,
    input logic [31:0] write_data,
    input logic        clk,
    input logic        write_en,
    input logic        reset,

    output logic [31:0] read_data
);


// Declare 64 empty spots, each being 32 bits long, for the memory
logic [31:0] mem[0:WORDS-1];


// Memory behavior
always_ff @(posedge clk) begin
    // When reset goes high, all data in mem becomes zero
    if (reset) begin
        for (int i = 0; i < WORDS; i++) begin
            mem[i] <= 32'b0;
        end
    end
    else if (write_en) begin
        // Only write data to addresses not on word boundaries
        if (address[1:0] == 2'b00) begin
            mem[address[31:2]] <= write_data;              
        end      
    end
end

// Read logic
assign read_data = mem[address[31:2]];


endmodule