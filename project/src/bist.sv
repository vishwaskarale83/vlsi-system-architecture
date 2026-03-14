module bist #(parameter size = 6, length = 8) (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic csin,
    input  logic rwbarin,
    input  logic opr,
    input  logic [size-1:0] address,
    input  logic [length-1:0] datain,
    output logic [length-1:0] dataout,
    output logic fail
);
    logic NbarT, ld;
    logic [9:0] count;
    logic cout;
    logic [7:0] data_t;
    logic [7:0] ramout;
    logic gt, eq, lt;
    logic [size-1:0] addr_mux_out;
    logic [length-1:0] data_mux_out;
    logic rwbar_mux, cs_mux, test_rw;
    logic q6_input;

    controller u_ctrl (.start(start), .rst(rst), .clk(clk), .cout(cout), .NbarT(NbarT), .ld(ld));
    
    // Verify here if the u_d should be 1 & d_in should be 0
    counter #(10) u_cnt (.clk(clk), .ld(ld), .u_d(1'b1), .cen(1'b1), .d_in(10'b0), .q(count), .cout(cout));
    
    decoder u_dec (.q(count[9:7]), .data_t(data_t));
    
    comparator u_cmp (.data_t(data_t), .ramout(ramout), .gt(gt), .eq(eq), .lt(lt));
    
    multiplexer #(6) u_mux_addr (.normal_in(address), .bist_in(count[5:0]), .NbarT(NbarT), .out(addr_mux_out));
    multiplexer #(8) u_mux_data (.normal_in(datain), .bist_in(data_t), .NbarT(NbarT), .out(data_mux_out));

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q6_input <= 1'b0;
        else
            q6_input <= count[6];
    end

    assign rwbar_mux = (NbarT) ? count[6] : rwbarin;
    assign cs_mux    = (NbarT) ? 1'b1       : csin;
    assign test_rw   = (NbarT) ? q6_input : rwbarin;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            fail <= 0;
        else if (NbarT && opr && test_rw && ~eq)
            fail <= 1;
        else
            fail <= 0;
    end

    sram u_ram (
        .clk(clk),
        .cs(cs_mux),
        .rwbar(rwbar_mux),
        .ramaddr(addr_mux_out),
        .ramin(data_mux_out),
        .ramout(ramout)
    );

    assign dataout = ramout;
endmodule