module sram (
    input  logic clk,
    input  logic cs,
    input  logic rwbar,
    input  logic [5:0] ramaddr,
    input  logic [7:0] ramin,
    output logic [7:0] ramout
);
    logic [7:0] ram [0:63];
    logic [5:0] addr_reg;

    always_ff @(posedge clk) begin
        if (cs) begin
            addr_reg <= ramaddr;
            if (!rwbar) begin
                ram[ramaddr] <= ramin; // write
            end
        end
    end

    always_comb begin
        if (cs && rwbar)
            ramout = ram[addr_reg];
        else
            ramout = 8'b0;
    end
endmodule