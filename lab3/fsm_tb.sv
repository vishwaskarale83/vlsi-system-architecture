module fsm_tb;

    import fsm10_pkg::*;

    logic rst_n, clk, jmp, go;
    logic y1;

    fsm dut (
        .rst_n(rst_n),
        .clk(clk),
        .jmp(jmp),
        .go(go),
        .y1(y1)
    );

    state_e expected_state;
    int fail_count = 0;
    string test_case_name;

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    task automatic reset_dut();
        rst_n = 0;
        go = 0;
        jmp = 0;
        #20;
        rst_n = 1;
        @(posedge clk);
    endtask

    task automatic run_test(input string name, input logic go_val, jmp_val, state_e start_state);
        state_e expected_next_state;
        logic expected_y1;

        test_case_name = name;
        go = go_val;
        jmp = jmp_val;

        case (start_state)
            S0: begin 
                if (!go_val) expected_next_state = S0;
                else if (jmp_val) expected_next_state = S3;
                else expected_next_state = S1;
                expected_y1 = 1'b0;
            end 
            S1: begin
                expected_next_state = jmp_val ? S3 : S2;
                expected_y1 = 1'b0;
            end
            S2: begin 
                expected_next_state = S3;
                expected_y1 = 1'b0;
            end
            S3: begin
                expected_next_state = jmp_val ? S3 : S4;
                expected_y1 = 1'b1;
            end
            S4: begin
                expected_next_state = jmp_val ? S3 : S5;
                expected_y1 = 1'b0;
            end
            S5: begin 
                expected_next_state = jmp_val ? S3 : S6;
                expected_y1 = 1'b0;
            end
            S6: begin 
                expected_next_state = jmp_val ? S3 : S7;
                expected_y1 = 1'b0;
            end
            S7: begin 
                expected_next_state = jmp_val ? S3 : S8;
                expected_y1 = 1'b0;
            end
            S8: begin 
                expected_next_state = jmp_val ? S3 : S9;
                expected_y1 = 1'b0;
            end
            S9: begin 
                expected_next_state = jmp_val ? S3 : S0;
                expected_y1 = 1'b0;
            end
        endcase

        @(posedge clk);

        if(y1 !== expected_y1) begin
            $display("FAIL %s: Expected y1=%b, got y1=%b", name, expected_y1, y1);
            fail_count++;
        end else begin
            $display("PASS %s", name);
        end
    endtask

    initial begin
        // Test S0 transitions
        reset_dut();
        run_test("S0-go0", 0, 0, S0);
        reset_dut();
        run_test("S0-go1-jmp0", 1, 0, S0);
        reset_dut();
        run_test("S0-go1-jmp1", 1, 1, S0);

        // Test S1 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        run_test("S1-jmp0", 0, 0, S1);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        run_test("S1-jmp1", 0, 1, S1);

        // Test S2 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        run_test("S2", 0, 0, S2);

        // Test S3 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S3-jmp0", 0, 0, S3);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S3-jmp1", 0, 1, S3);

        // Test S4 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S4-jmp0", 0, 0, S4);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S4-jmp1", 0, 1, S4);

        // Test S5 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S5-jmp0", 0, 0, S5);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S5-jmp1", 0, 1, S5);

        // Test S6 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S6-jmp0", 0, 0, S6);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S6-jmp1", 0, 1, S6);

        // Test S7 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S7-jmp0", 0, 0, S7);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S7-jmp1", 0, 1, S7);

        // Test S8 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S8-jmp0", 0, 0, S8);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S8-jmp1", 0, 1, S8);

        // Test S9 transitions
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S9-jmp0", 0, 0, S9);
        reset_dut();
        go = 1; jmp = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        run_test("S9-jmp1", 0, 1, S9);

        // Final result
        #20;
        if(fail_count == 0) begin
            $display("FINAL RESULT: ALL TESTS PASSED");
        end else begin
            $display("FINAL RESULT: %0d TESTS FAILED", fail_count);
        end
        $finish;
    end

endmodule