# Create a clock named 'clk' with 6ns period
create_clock -period 6 -name clk [get_ports clk]

# Input and output delays
set_input_delay 0.1 -clock clk [all_inputs]
set_output_delay 0.15 -clock clk [all_outputs]

# Output load and fanout limits
set_load 0.1 [all_outputs]
set_max_fanout 1 [all_inputs]
set_fanout_load 8 [all_outputs]

# Clock uncertainty and latency
set_clock_uncertainty 0.01 [all_clocks]
set_clock_latency 0.01 -source [get_ports clk]
