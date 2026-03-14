//`timescale 1ns/1ps

module tb_bist;
  logic clk, rst, start, csin, rwbarin, opr;
  logic [5:0] address;
  logic [7:0] datain, dataout;
  logic fail;

  bist uut (
    .clk(clk), .rst(rst), .start(start),
    .csin(csin), .rwbarin(rwbarin), .opr(opr),
    .address(address), .datain(datain), .dataout(dataout), .fail(fail)
  );

  task check(string name, bit condition);
    if (condition) $display("PASS: %s", name);
    else $error("FAIL: %s", name);
  endtask

  always #5 clk = ~clk;

  initial begin
    clk = 0;

    // === Normal Mode Write ===
    rst = 1; start = 0; opr = 0; csin = 1; rwbarin = 0;
    address = 6'd12;
    datain = 8'hF0;
    @(posedge clk); rst = 0;
    @(posedge clk); // write

    // === Normal Mode Read (Confirm Write) ===
    rwbarin = 1;
    @(posedge clk);
    #1;
    check("Normal Read Confirm", dataout == 8'hF0);

    // === Test Mode: Clean BIST run ===
    start = 1; opr = 1;
    @(posedge clk); start = 0;
    repeat (70) @(posedge clk); // let BIST run full cycle
    check("No Fault During BIST", fail == 0);

    // === Fault Injection ===
    // Overwrite a location that BIST will read later
    opr = 0; rwbarin = 0;
    address = 6'd5;
    datain = 8'hAA; // corrupt data
    @(posedge clk); // inject fault

    // === Fault Detection in BIST ===
    opr = 1; start = 1;
    @(posedge clk); start = 0;
    repeat (70) @(posedge clk);
    check("Detect Fault via BIST", fail == 1);

    $finish;
  end
endmodule
