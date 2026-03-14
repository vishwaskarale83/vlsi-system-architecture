//`timescale 1ns/1ps

module tb_controller;
  logic start, rst, clk, cout;
  logic NbarT, ld;

  controller uut (.start(start), .rst(rst), .clk(clk), .cout(cout), .NbarT(NbarT), .ld(ld));

  task check(string name, bit condition);
    if (condition) $display("PASS: %s", name);
    else $error("FAIL: %s", name);
  endtask

  always #5 clk = ~clk;

  initial begin
    clk = 0; rst = 1; start = 0; cout = 0; #10;
    rst = 0; start = 1; #10;
    check("Transition to TEST", NbarT == 1 && ld == 0);

    cout = 1; @(posedge clk);
    check("Back to RESET", NbarT == 0 && ld == 1);

    $finish;
  end
endmodule
