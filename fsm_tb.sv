module fsm_tb;
    logic rst_n, clk, jmp, go;
    logic y1;
    
    // Instantiate FSM design
    fsm DUT(.rst_n, .clk, .jmp, .go, .y1);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = !clk;
    end

    // Test sequence
    initial begin
        $monitor("T=%0t: State=%s, y1=%b\n", $time, DUT.state, y1);
        
        // Reset FSM to S0
        $display("Resetting FSM");
        rst_n = 1'b0;
        jmp = 0;
        go = 0;
        #10;
        rst_n = 1'b1;
        #10;
        
        // Test normal progression with go=1
        $display("Normal progression with go=1");
        go = 1'b1;
        jmp = 0;
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
        end
        go = 0;
        #10;
        
        // Test jmp in S0
        $display("Testing jmp in S0");
        @(posedge clk);
        go = 1;
        jmp = 1;
        @(posedge clk);
        jmp = 0;
        #10;
        
        // Test jmp in S1
        $display("Testing jmp in S1");
        @(posedge clk);
        go = 1;
        @(posedge clk);
        jmp = 1;
        @(posedge clk);
        jmp = 0;
        #10;
        
        // Test jmp in S3
        $display("Testing jmp in S3");
        @(posedge clk);
        jmp = 1;
        @(posedge clk);
        @(posedge clk);
        jmp = 0;
        #10;
        
        // Test jmp in S4
        $display("Testing jmp in S4");
        @(posedge clk);
        @(posedge clk);
        jmp = 1;
        @(posedge clk);
        jmp = 0;
        #10;
        
        // Test all input combinations
        $display("Testing all input combinations");
        rst_n = 1'b0;
        #10;
        rst_n = 1'b1;
        #10;
        for (int go_val = 0; go_val <= 1; go_val++) begin
            go = go_val;
            for (int jmp_val = 0; jmp_val <= 1; jmp_val++) begin
                jmp = jmp_val;
                @(posedge clk);
                $display("go=%b, jmp=%b: y1=%b", go, jmp, y1);
            end
        end
        #10;
        
        // Asynchronous reset test
        $display("Testing reset during operation");
        @(posedge clk);
        rst_n = 1'b0;
        #5;
        rst_n = 1'b1;
        #10;
        
        $display("Simulation complete");
        $finish;
    end
    
    // Dump waveforms
    initial begin
        $dumpfile("fsm_tb.vcd");
        $dumpvars(0, fsm_tb);
    end
endmodule