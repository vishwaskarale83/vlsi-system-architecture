module counter #(parameter length = 10) (
    input  logic clk,
    input  logic ld,
    input  logic u_d,
    input  logic cen,
    input  logic [length-1:0] d_in,
    output logic [length-1:0] q,
    output logic cout
);
    always_ff @(posedge clk) begin
        cout <= 0; // Default
        if (cen) begin
            if (ld) begin
                q <= d_in;
            end else if (u_d) begin
                if (q == {length{1'b1}}) begin
                    cout <= 1;
                    q <= q; // hold
                end else begin
                    q <= q + 1;
                end
            end else begin
                if (q == {length{1'b0}}) begin
                    cout <= 1;
                    q <= q; // hold
                end else begin
                    q <= q - 1;
                end
            end
        end
    end
endmodule