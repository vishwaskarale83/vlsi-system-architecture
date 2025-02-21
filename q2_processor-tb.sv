`timescale 1ns / 1ps

module processor_tb;

    // Inputs
    logic [31:0] data_in;
    logic [31:0] i_data;
    logic data_select;
    logic clk;
    logic rstN;
    logic [15:0] status_flags;

    // Outputs
    logic [31:0] data_out;
    logic [7:0] status;
    logic [2:0] Q;

    // Instantiate the processor module
    processor uut (
        .data_in(data_in),
        .i_data(i_data),
        .data_select(data_select),
        .clk(clk),
        .rstN(rstN),
        .status_flags(status_flags),
        .data_out(data_out),
        .status(status),
        .Q(Q)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock

    // Test sequence
    initial begin
        // Initialize inputs
        data_in = 0;
        i_data = 0;
        data_select = 0;
        rstN = 0;
        status_flags = 0;

        // Test Case 1: Reset behavior
        #10 rstN = 1; // 
        #10 rstN = 0; // reset
        #10 rstN = 1; // 

        // Test Case 2: Data Select Edge Cases
        #10 data_select = 0;
        data_in = 32'hAAAA_AAAA;
        i_data = 32'hBBBB_BBBB;
        #10 data_select = 1;

        // Test Case 3: Status Flags Edge Cases
        #10 status_flags = 16'hFFFF; // All flags high
        #10 status_flags = 16'h0000; // All flags low
        #10 status_flags = 16'h8000; // Only int_en flag high
        #10 status_flags = 16'h0001; // Only parity flag high

        // Test Case 4: Priority Encoder Edge Cases
        #10 status_flags[15:8] = 8'b1111_1111; // All inputs high
        #10 status_flags[15:8] = 8'b0000_0001; // Only lowest priority input high
        #10 status_flags[15:8] = 8'b1000_0000; // Only highest priority input high
        #10 status_flags[15:8] = 8'b0101_0101; // Alternating inputs high

        // Test Case 5: Simultaneous Changes
        #10 data_select = 0;
        status_flags = 16'hAAAA;
        #10 data_select = 1;
        status_flags = 16'h5555;

        // End simulation
        #10 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time: %t, data_in: %h, i_data: %h, data_select: %b, clk: %b, rstN: %b, status_flags: %h, data_out: %h, status: %h, Q: %b",
                 $time, data_in, i_data, data_select, clk, rstN, status_flags, data_out, status, Q);
    end

endmodule