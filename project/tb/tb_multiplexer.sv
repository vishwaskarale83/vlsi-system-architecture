//`timescale 1ns/1ps

module tb_multiplexer;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] normal_in, bist_in, out;
  logic NbarT;

  multiplexer #(.WIDTH(WIDTH)) uut (.normal_in(normal_in), .bist_in(bist_in), .NbarT(NbarT), .out(out));

  task check(string name, bit condition);
    if (condition) $display("PASS: %s", name);
    else $error("FAIL: %s", name);
  endtask

  initial begin
    normal_in = 8'h55; bist_in = 8'hAA;

    NbarT = 0; #1; check("Normal Mode Select", out == normal_in);
    NbarT = 1; #1; check("BIST Mode Select", out == bist_in);

    $finish;
  end
endmodule
