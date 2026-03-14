//`timescale 1ns/1ps

module tb_sram;
  logic clk, cs, rwbar;
  logic [5:0] ramaddr;
  logic [7:0] ramin, ramout;
  logic [7:0] golden_ram [0:63]; // reference memory for checking

  sram uut (
    .clk(clk),
    .cs(cs),
    .rwbar(rwbar),
    .ramaddr(ramaddr),
    .ramin(ramin),
    .ramout(ramout)
  );

  task check(string name, bit condition);
    if (condition) $display("PASS: %s", name);
    else $error("FAIL: %s", name);
  endtask

  always #5 clk = ~clk;

  initial begin
    clk = 0;

    // === STEP 1: Random write to ALL locations ===
    cs = 1; rwbar = 0;
    for (int i = 0; i < 64; i++) begin
      ramaddr = i;
      ramin = $urandom_range(0, 255); // random data
      golden_ram[i] = ramin;           // store expected value
      @(posedge clk);
    end

    // === STEP 2: Read and check all locations ===
    rwbar = 1; // read mode
    for (int i = 0; i < 64; i++) begin
      ramaddr = i;
      @(posedge clk);
      #1; // allow small combinational delay
      check($sformatf("Read Address %0d", i), ramout == golden_ram[i]);
    end

    // === STEP 3: Chip select disabled - read should give 0 ===
    cs = 0;
    ramaddr = 6'd10;
    @(posedge clk);
    #1;
    check("Read with CS=0 gives 0", ramout == 8'h00);

    // === STEP 4: Write without CS active (should NOT overwrite) ===
    cs = 0; rwbar = 0;
    ramaddr = 6'd20;
    ramin = 8'h55;
    @(posedge clk);

    // Now check if old value is preserved
    cs = 1; rwbar = 1;
    ramaddr = 6'd20;
    @(posedge clk);
    #1;
    check("Write Blocked when CS=0", ramout == golden_ram[20]);

    $finish;
  end
endmodule
