// 5-to-3 Adder module
// Compress 5 input bits into 3 output bits
module adder_5to3(in, cout, carry, sum);

    input [4:0] in;             // 5bit input
    wire x0, x1, x2, x3, x4;
    output cout, carry, sum;

    assign {x0, x1, x2, x3, x4} = in;

    // Intermediate OR/AND calculations for pairs
    wire y0, y1, y2, y3;

    assign y0 = x4 | x3;    // OR of top two bits
    assign y1 = x4 & x3;    // AND of top two bits
    assign y2 = x2 | x1;    // OR of next two bits
    assign y3 = x2 & x1;    // AND of next two bits

    // Intermediate signals for compressing logic
    wire sand0, sand1, sxor0;

    assign sand0 = y2 & (~y3);      // AND of y2 & ~y3
    assign sand1 = y0 & (~y1);      // AND of y0 & ~y1
    assign sxor0 = sand0 ^ sand1;   // XOR of intermediate signals
    assign sum = sxor0 ^ x0;        // sum output : final XOR with lowest bit

    // Multiplexer-like selection based on sxor0
    wire mux0;
    assign mux0 = sxor0 ? x0 : y3;  // if sxor0 == 1, x0; else y3

    // Final carry and carry-out calculations
    wire cor0, cand0;
    assign cor0 = y1 | y2;      // OR of y1 & y2
    assign cand0 = y0 & cor0;   // AND of y0 & cor0

    assign carry = mux0 ^ cand0;    // intermediate carry output
    assign cout = mux0 & cand0;     // final carry-out output

endmodule
