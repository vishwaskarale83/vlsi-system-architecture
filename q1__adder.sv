//4 bit adder module 
module adder_4(
        input logic [3:0] x, y,
        input logic cin,
        output logic cout,
        output logic [3:0] sum
);

	//your code goes here

        logic [3:0] carry;

        // Generate sum and carry for each bit using full adder logic
        assign {carry[0], sum[0]} = x[0] + y[0] + cin;
        assign {carry[1], sum[1]} = x[1] + y[1] + carry[0];
        assign {carry[2], sum[2]} = x[2] + y[2] + carry[1];
        assign {carry[3], sum[3]} = x[3] + y[3] + carry[2];

        // The final carry out is the carry from the last addition
        assign cout = carry[3];

endmodule


//16 bit adder using the four 4-bit adder
module Adder(
input logic [15:0] X,Y,
input logic cin,
output logic cout,
output logic [15:0] S
);

        logic c1, c2, c3;

	//your logic code goes here
	//Initialize your sub module here
        adder_4 adder1(.x(X[3:0]), .y(Y[3:0]), .cin(cin), .cout(c1), .sum(S[3:0]));
        adder_4 adder2(.x(X[7:4]), .y(Y[7:4]), .cin(c1), .cout(c2), .sum(S[7:4]));
        adder_4 adder3(.x(X[11:8]), .y(Y[11:8]), .cin(c2), .cout(c3), .sum(S[11:8]));
        adder_4 adder4(.x(X[15:12]), .y(Y[15:12]), .cin(c3), .cout(cout), .sum(S[15:12]));

endmodule

