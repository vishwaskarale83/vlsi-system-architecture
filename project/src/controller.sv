module controller (
    input  logic start,
    input  logic rst,
    input  logic clk,
    input  logic cout,
    output logic NbarT,
    output logic ld
);
    typedef enum logic {RESET, TEST} state_t;
    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= RESET;
        else begin
            case (state)
                RESET: if (start) state <= TEST;
                TEST: if (cout) state <= RESET;
            endcase
        end
    end

    assign NbarT = (state == TEST);
    assign ld = (state == RESET);
endmodule