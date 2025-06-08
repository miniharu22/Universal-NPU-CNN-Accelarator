// D Flip Flop module for 8bit data
module D_FF8 # (parameter port = 8) (d, q, clk, reset);

    input [port-1:0] d;
    input clk, reset;
    output reg [port-1:0] q;

    always @ (posedge clk)
    begin
        if(!reset)
            q <= 'd0;
        else
            q <= d; // On clk edge, capture input data
    end

endmodule