//`timescale 1ns/1ps

module tb_decoder;
  logic [2:0] q;
  logic [7:0] data_t;

  decoder uut (.q(q), .data_t(data_t));

  task check(string name, bit condition);
    if (condition) $display("PASS: %s", name);
    else $error("FAIL: %s", name);
  endtask

  initial begin
    q = 3'b000; #1; check("Pattern 000", data_t == 8'b10101010);
    q = 3'b001; #1; check("Pattern 001", data_t == 8'b01010101);
    q = 3'b010; #1; check("Pattern 010", data_t == 8'b11110000);
    q = 3'b011; #1; check("Pattern 011", data_t == 8'b00001111);
    q = 3'b100; #1; check("Pattern 100", data_t == 8'b00000000);
    q = 3'b101; #1; check("Pattern 101", data_t == 8'b11111111);
    q = 3'b110; #1; check("Invalid Pattern", data_t === 8'bxxxxxxxx);
    $finish;
  end
endmodule
