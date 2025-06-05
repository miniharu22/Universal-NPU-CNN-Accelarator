`timescale 1ns / 1ps

// 7-to-3 Adder module
// Compress 7 input bits into 3 output bits
module adder_7to3(in, cout, carry, sum);

    input [6:0] in;     // 7bit input
    wire x1, x2, x3, x4, x5, x6, x7;
    output cout, carry, sum;

    assign {x1, x2, x3, x4, x5, x6, x7} = in;

    // Pairwise AND & XOR for the first three pairs
    wire and12, xor12, and34, xor34, and56, xor56;

    assign and12 = x1 & x2;    // AND of first pair
    assign xor12 = x1 ^ x2;    // XOR of first pair
    assign and34 = x3 & x4;    // AND of second pair
    assign xor34 = x3 ^ x4;    // XOR of second pair
    assign and56 = x5 & x6;    // AND of third pair
    assign xor56 = x5 ^ x6;    // XOR of third pair

    // Intermediate signals for compression logic
    wire  and4, xor4, and5, xor5, and6, xor6;

    assign and4 = and12 & and34;  // AND of two ANDs (first and second pairs)
    assign xor4 = and12 ^ and34;  // XOR of two ANDs
    assign and5 = xor12 & xor34;  // AND of two XORs (first and second pairs)
    assign xor5 = xor12 ^ xor34;  // XOR of two XORs
    assign and6 = x7 & xor56;     // AND of x7 and third pair XOR
    assign xor6 = x7 ^ xor56;     // XOR of x7 and third pair XOR

    // Further compression of intermediate results
    wire xor10, xor7;

    assign xor10 = xor4 ^ and5;   // XOR compression result
    assign xor7 = and56 ^ and6;   // XOR of ANDs from third pair and x7

    // Additional intermediate logic
    wire and8, xor8, and9, xor9;

    assign and8 = xor5 & xor6;    // AND of second stage XORs
    assign xor8 = xor5 ^ xor6;    // sum output
    assign and9 = xor10 & xor7;   // AND compression of intermediate XORs
    assign xor9 = xor10 ^ xor7;   // intermediate XOR compression

    // Final carry and carry-out calculations
    wire xor12_, and11, xor11, xor13;

    assign and11 = xor9 & and8;   // intermediate AND for carry
    assign xor12_ = and9 ^ and11; // XOR of intermediate ANDs
    assign xor11 = xor9 ^ and8;   // carry output
    assign xor13 = xor12_ ^ and4; // final carry-out output

    // Final outputs
    assign sum = xor8;            // sum output (LSB)
    assign carry = xor11;         // intermediate carry output
    assign cout = xor13;          // final carry-out output (MSB)

endmodule