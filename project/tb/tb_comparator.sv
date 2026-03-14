//`timescale 1ns/1ps

module tb_comparator;
  logic [7:0] data_t, ramout;
  logic gt, eq, lt;

  comparator uut (.data_t(data_t), .ramout(ramout), .gt(gt), .eq(eq), .lt(lt));

  task check(input string testname, input bit condition);
    if (condition) $display("PASS: %s", testname);
    else begin
      $error("FAIL: %s", testname);
    end
  endtask

  initial begin
    data_t = 8'd100; ramout = 8'd50; #1;
    check("GT Test", gt && !eq && !lt);

    data_t = 8'd50; ramout = 8'd50; #1;
    check("EQ Test", !gt && eq && !lt);

    data_t = 8'd10; ramout = 8'd20; #1;
    check("LT Test", !gt && !eq && lt);

    $finish;
  end
endmodule
