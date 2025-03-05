package fsm10_pkg;
    //declare your enum here, enum name should be "state_e"
    typedef enum logic [3:0] { S0=0, S1=1, S2=2, S3=3, 
                            S4=4, S5=5, S6=6, S7=7, 
                            S8=8, S9=9 } state_e;
endpackage

module fsm(
    input logic rst_n, clk, jmp, go,
    output logic y1
);
    //import the package
    import fsm10_pkg::*;

    //create two variables called "state" and "next" of enum type
    state_e state, next;

    //Start your procedural blocks from here
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) state <= S0;
        else state <= next;
    end

    always_comb begin
        
        next = S0;
        y1 = 1'b0;

        case (state)
            S0: begin 
                    if (!go) begin
                        next = S0;
                    end else begin
                        if (jmp) begin
                            next = S3;
                        end else begin
                            next = S1;
                        end
                    end
                    y1 = 1'b0;
                end 
            S1: begin
                    if (jmp) next = S3;
                    else next = S2;
                    y1 = 1'b0;
                end
            S2: begin 
                    next = S3;
                    y1 = 1'b0;
                end
            S3: begin
                    if (jmp) next = S3;
                    else next = S4;
                    y1 = 1'b1;
                end
            S4: begin
                    if (jmp) next = S3; 
                    else next = S5;
                    y1 = 1'b0;
                end
            S5: begin 
                    if (jmp) next = S3; 
                    else next = S6;
                    y1 = 1'b0;
                end
            S6: begin 
                    if (jmp) next = S3; 
                    else next = S7;
                    y1 = 1'b0;
                end
            S7: begin 
                    if (jmp) next = S3; 
                    else next = S8;
                    y1 = 1'b0;
                end
            S8: begin 
                    if (jmp) next = S3; 
                    else next = S9;
                    y1 = 1'b0;
                end
            S9: begin 
                    if (jmp) next = S3; 
                    else next = S0;
                    y1 = 1'b0;
                end
        endcase
    end

endmodule
