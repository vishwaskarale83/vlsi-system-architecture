`timescale 1ns / 1ps

module processor_tb;

    // Inputs
    reg [31:0] data_in;
    reg [31:0] i_data;
    reg data_select;
    reg clk;
    reg rstN;
    reg [15:0] status_flags;

    // Outputs
    wire [31:0] data_out;
    wire [7:0] status;
    wire [2:0] Q;

    // Instantiate the Unit Under Test (UUT)
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
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Generate a clock with a period of 10ns
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        data_in = 0;
        i_data = 0;
        data_select = 0;
        rstN = 0;
        status_flags = 0;

        // Wait for global reset
        #100;
        rstN = 1;  // Release reset

        // Test Case 1: Basic functionality with data_select = 0
        data_select = 0;
        data_in = 32'hAAAA_AAAA;
        i_data = 32'hBBBB_BBBB;
        status_flags = 16'hFFFF;  // All flags set
        #10;

        // Test Case 2: Basic functionality with data_select = 1
        data_select = 1;
        data_in = 32'hCCCC_CCCC;
        i_data = 32'hDDDD_DDDD;
        status_flags = 16'h0000;  // All flags reset
        #10;

        // Test Case 3: Edge case with status_flags
        data_select = 0;
        data_in = 32'hEEEE_EEEE;
        i_data = 32'hFFFF_FFFF;
        status_flags = 16'h8000;  // Only the highest bit set
        #10;

        // Test Case 4: Another edge case with status_flags
        data_select = 1;
        data_in = 32'h1111_1111;
        i_data = 32'h2222_2222;
        status_flags = 16'h0001;  // Only the lowest bit set
        #10;

        // Test Case 5: Random values
        data_select = 0;
        data_in = 32'h3333_3333;
        i_data = 32'h4444_4444;
        status_flags = 16'hABCD;  // Random flags
        #10;

        // Test Case 6: Random values
        data_select = 1;
        data_in = 32'h5555_5555;
        i_data = 32'h6666_6666;
        status_flags = 16'hDCBA;  // Random flags
        #10;

        // Finish simulation
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, data_in = %h, i_data = %h, data_select = %b, status_flags = %h, data_out = %h, status = %h, Q = %b",
                 $time, data_in, i_data, data_select, status_flags, data_out, status, Q);
    end

endmodule