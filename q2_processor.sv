//Top level modules (make use of submodules from bottom)
module processor
( input logic [31:0] data_in,
  input logic [31:0] i_data,
  input logic data_select,
  input logic clk,
  input logic rstN,
  input logic [15:0] status_flags,
  output logic [31:0] data_out,
  output logic [7:0] status,
  output logic [2:0] Q
);

  //your design code goes here

    // Instantiate the mux32 module
    mux32 mux1(.a(data_in), .b(i_data), .sel(data_select), .y(data_out));

    // Instantiate the status_reg module
    status_reg status_reg1(.clk(clk), 
                          .rstN(rstN), 
                          .int_en(status_flags[7]), 
                          .zero(status_flags[4]), 
                          .carry(status_flags[3]), 
                          .neg(status_flags[2]), 
                          .parity(status_flags[1:0]),
                          .status1(status));

    
    // Instantiate the Pri_En module
    Pri_En pri_en1(.D(status_flags[15:8]), .Q(Q));

endmodule

//multiplexer submodule
module mux32
( input logic [31:0] a,
  input logic [31:0] b,
  input logic sel,
  output logic [31:0] y
);

    always_comb begin
        if (sel) begin
            y = a;  // Select a if sel is high
        end else begin
            y = b;  // Select b if sel is low
        end
    end

endmodule


//status register submodule
module status_reg
( input logic clk,
  input logic rstN,
  input logic int_en,
  input logic zero,
  input logic carry,
  input logic neg,
  input logic [1:0] parity,
  output logic [7:0] status1
);

    always_ff @(posedge clk) begin
        if (!rstN) begin
            status1 <= 8'b0;
        end else begin
            // Assign values to the status register based on input flags
            status1[7] <= int_en;
            status1[6] <= 1'b1;  // Unused state
            status1[5] <= 1'b1;  // Unused state
            status1[4] <= zero;
            status1[3] <= carry;
            status1[2] <= neg;
            status1[1:0] <= parity;  
        end
    end

endmodule

//priority Encoder submodule
module Pri_En
( input logic [7:0] D,
  output logic [2:0] Q
);

    // Priority encoding logic using case statement
    always_comb begin
        casez (D)
            8'b1???????: Q = 3'b111;
            8'b01??????: Q = 3'b110;
            8'b001?????: Q = 3'b101;
            8'b0001????: Q = 3'b100;
            8'b00001???: Q = 3'b011;
            8'b000001??: Q = 3'b010;
            8'b0000001?: Q = 3'b001;
            8'b00000001: Q = 3'b000;
        endcase
    end

endmodule