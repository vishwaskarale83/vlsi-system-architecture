//`timescale 1ns/1ps

module tb_counter;
  parameter length = 10;
  logic clk, ld, u_d, cen;
  logic [length-1:0] d_in, q;
  logic cout;

  counter #(.length(length)) uut (
    .clk(clk), .ld(ld), .u_d(u_d), .cen(cen),
    .d_in(d_in), .q(q), .cout(cout)
  );

  task check(string name, bit condition);
    if (condition) $display("PASS: %s", name);
    else $error("FAIL: %s", name);
  endtask

  always #5 clk = ~clk;

  initial begin
    clk = 0; cen = 1;

    // Load test
    d_in = 10'd5; ld = 1; u_d = 1; @(posedge clk);
    ld = 0;
    check("Load Test", q == 10'd5);

    // Up count test
    repeat (10) @(posedge clk);
    check("Count Up to 15", q == 10'd15);

    // Overflow test
    d_in = 10'b1111111110; ld = 1; u_d = 1; @(posedge clk); // Load to max-1
    ld = 0;
    @(posedge clk); // Now q == max
    check("Overflow Detected", cout == 1);

    // Down count test
    d_in = 10'd3; ld = 1; u_d = 0; @(posedge clk); // Load to 3
    ld = 0;
    @(posedge clk); // q = 2
    @(posedge clk); // q = 1
    @(posedge clk); // q = 0
    check("Underflow Not Yet", cout == 0);
    @(posedge clk); // q = max -> underflow
    check("Underflow Detected", cout == 1);

    $finish;
  end
endmodule