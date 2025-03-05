`timescale 1ns / 1ps

module Adder_tb;

    // Inputs
    logic [15:0] X, Y;
    logic cin;

    // Outputs
    logic cout;
    logic [15:0] S;

    // Instantiate the Adder module
    Adder uut (
        .X(X),
        .Y(Y),
        .cin(cin),
        .cout(cout),
        .S(S)
    );

    // Test sequence
    initial begin
        // Initialize inputs
        X = 0;
        Y = 0;
        cin = 0;

        // Test Case 1: Basic Addition
        #10 X = 16'hAAAA; // 43650
        Y = 16'h5555; // 21845
        cin = 0;

        // Test Case 2: Carry Propagation
        #10 X = 16'hFFFF; // 65535
        Y = 16'h0001; // 1
        cin = 0;

        // Test Case 3: Boundary Conditions
        #10 X = 16'h7FFF; // 32767 (max positive value for 16-bit signed)
        Y = 16'h8001; // 32769
        cin = 0;

        // Test Case 4: Edge Cases
        #10 X = 16'h0000; // 0
        Y = 16'h0000; // 0
        cin = 0;

        #10 X = 16'hFFFF; // 65535
        Y = 16'hFFFF; // 65535
        cin = 1;

        #10 X = 16'hAAAA; // 43650
        Y = 16'h5555; // 21845
        cin = 1;

        // Test Case 5: Random Values
        #10 X = 16'h1234; // 4660
        Y = 16'hABCD; // 44045
        cin = 0;

        #10 X = 16'hFEDC; // 65244
        Y = 16'hBA98; // 48280
        cin = 1;

        // End simulation
        #10 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time: %t, X: %h, Y: %h, cin: %b, cout: %b, S: %h",
                 $time, X, Y, cin, cout, S);
    end

endmodule