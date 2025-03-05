module traffic_light_controller (
    input logic clk, reset,
    output logic [1:0] light_NS, light_EW  // 00=Red, 01=Yellow, 10=Green
);

    //declare your enum here, enum name should be "state_e"
    typedef enum logic [2:0] {
        RED_RED = 3'b000,
        NS_GR   = 3'b001,
        NS_YE   = 3'b010,
        EW_GR   = 3'b011,
        EW_YE   = 3'b100
    } state_e;

    //create two variables called "state" and "next" of enumeration type
    state_e state, next;

    //start your procedural blocks from here
    
    // Sequential logic for state updates and asynchronous reset
    always_ff @(posedge clk, negedge reset) begin
        if (!reset)       // Asynchronous reset
            state <= RED_RED;
        else
            state <= next;
    end

    // Combinational logic for next state determination and output assignment
    always_comb begin
        next = state;  // Default: no state change

        // State transition logic
        case (state)
            RED_RED: next = NS_GR;
            NS_GR:   next = NS_YE;
            NS_YE:   next = EW_GR;
            EW_GR:   next = EW_YE;
            EW_YE:   next = RED_RED;
            default: next = RED_RED;
        endcase

        // Traffic light output control based on state state
        case (state)
            NS_GR: begin
                light_NS = 2'b10; // NS Green
                light_EW = 2'b00; // EW Red
            end
            NS_YE: begin
                light_NS = 2'b01; // NS Yellow
                light_EW = 2'b00; // EW Red
            end
            EW_GR: begin
                light_NS = 2'b00; // NS Red
                light_EW = 2'b10; // EW Green
            end
            EW_YE: begin
                light_NS = 2'b00; // NS Red
                light_EW = 2'b01; // EW Yellow
            end
            default: begin
                light_NS = 2'b00; // Default: Red
                light_EW = 2'b00; // Default: Red
            end
        endcase
    end

endmodule