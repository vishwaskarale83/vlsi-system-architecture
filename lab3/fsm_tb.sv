module fsm_tb;

    // Import the package
    import fsm10_pkg::*;

    // Testbench signals
    logic rst_n, clk, jmp, go;
    logic y1;

    // Instantiate the Design Under Test (DUT)
    fsm dut (
        .rst_n(rst_n),
        .clk(clk),
        .jmp(jmp),
        .go(go),
        .y1(y1)
    );

    // Testbench variables
    state_e expected_state;
    int fail_count = 0;
    string test_case_name;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Task to run a test case
    task automatic run_test(input string name, input logic go_val, jmp_val);
        state_e expected_next_state;
        logic expected_y1;

        test_case_name = name;
        go = go_val;
        jmp = jmp_val;

        // Calculate expected next state and y1 based on current expected_state
        case (expected_state)
            S0: begin 
                if (!go_val) begin
                    expected_next_state = S0;
                end else begin
                    if (jmp_val) begin
                        expected_next_state = S3;
                    end else begin
                        expected_next_state = S1;
                    end
                end
                expected_y1 = 1'b0;
            end 
            S1: begin
                if (jmp_val) expected_next_state = S3;
                else expected_next_state = S2;
                expected_y1 = 1'b0;
            end
            S2: begin 
                expected_next_state = S3;
                expected_y1 = 1'b0;
            end
            S3: begin
                if (jmp_val) expected_next_state = S3;
                else expected_next_state = S4;
                expected_y1 = 1'b1;
            end
            S4: begin
                if (jmp_val) expected_next_state = S3; 
                else expected_next_state = S5;
                expected_y1 = 1'b0;
            end
            S5: begin 
                if (jmp_val) expected_next_state = S3; 
                else expected_next_state = S6;
                expected_y1 = 1'b0;
            end
            S6: begin 
                if (jmp_val) expected_next_state = S3; 
                else expected_next_state = S7;
                expected_y1 = 1'b0;
            end
            S7: begin 
                if (jmp_val) expected_next_state = S3; 
                else expected_next_state = S8;
                expected_y1 = 1'b0;
            end
            S8: begin 
                if (jmp_val) expected_next_state = S3; 
                else expected_next_state = S9;
                expected_y1 = 1'b0;
            end
            S9: begin 
                if (jmp_val) expected_next_state = S3; 
                else expected_next_state = S0;
                expected_y1 = 1'b0;
            end
        endcase

        #10; // Wait for clk edge

        if(y1 !== expected_y1) begin
            $display("FAIL %s: Expected y1=%b, got y1=%b", name, expected_y1, y1);
            fail_count++;
        end else begin
            $display("PASS %s", name);
        end

        // Update expected_state
        expected_state = expected_next_state;
    endtask

    initial begin
        // Initialize
        rst_n = 0;
        go = 0;
        jmp = 0;
        expected_state = S0;
        #20;
        rst_n = 1;

        // Test all transitions
        // S0 transitions
        run_test("S0-go0", 0, 0);
        run_test("S0-go1-jmp0", 1, 0);
        run_test("S0-go1-jmp1", 1, 1);

        // S1 transitions
        run_test("S1-jmp0", 0, 0);
        run_test("S1-jmp1", 0, 1);

        // S2 transition
        run_test("S2", 0, 0);

        // S3 transitions
        run_test("S3-jmp0", 0, 0);
        run_test("S3-jmp1", 0, 1);

        // S4 transitions
        run_test("S4-jmp0", 0, 0);
        run_test("S4-jmp1", 0, 1);

        // S5 transitions
        run_test("S5-jmp0", 0, 0);
        run_test("S5-jmp1", 0, 1);

        // S6 transitions
        run_test("S6-jmp0", 0, 0);
        run_test("S6-jmp1", 0, 1);

        // S7 transitions
        run_test("S7-jmp0", 0, 0);
        run_test("S7-jmp1", 0, 1);

        // S8 transitions
        run_test("S8-jmp0", 0, 0);
        run_test("S8-jmp1", 0, 1);

        // S9 transitions
        run_test("S9-jmp0", 0, 0);
        run_test("S9-jmp1", 0, 1);

        // Final result
        #20;
        if(fail_count == 0) begin
            $display("PASS All Tests Passed");
        end else begin
            $display("FAIL %0d Tests Failed", fail_count);
        end
        $finish;
    end

endmodule