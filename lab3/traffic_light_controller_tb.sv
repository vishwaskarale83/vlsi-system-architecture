module traffic_light_controller_tb;
    logic clk, reset;
    logic [1:0] light_NS, light_EW;

    // Instantiate the traffic light controller
    traffic_light_controller DUT (.clk, .reset, .light_NS, .light_EW);

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test sequence
    initial begin
        $monitor($time, "ps: State=%b, NS=%b, EW=%b",
            DUT.current_state, light_NS, light_EW);

        // Initialize interface
        reset = 0;  // Active-low reset
        #10 reset = 1;  // Deassert reset
        #20;          // Wait for clock edges

        // Run simulation for multiple cycles
        repeat (20) @(posedge clk);
        $finish;
    end
endmodule