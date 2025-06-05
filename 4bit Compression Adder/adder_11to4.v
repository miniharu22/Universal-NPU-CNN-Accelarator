`timescale 1ns / 1ps

// 11-to-4 Adder module
// Compress 11 input bits into 4 output bits
module adder_11to4(in, O3, O2, O1, O0);

    input [10:0] in;        // 11bit input
    wire x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10;
    output O3, O2, O1, O0;  // 4bit output (sum)

    // Assign input bits to individual wires
    assign {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10} = in;

    // Intermediate partial sum & carry outputs from compressors
    wire A[2:0];    // Partial sum & carry outputs for upper 5-to-3 adder
    wire B[2:0];    // Partial sum & carry outputs for lower 6-to-3 adder

    // Fisrt compressor : Compress lower 6bits
    adder_6to3 A630({x0, x1, x2, x3, x4, x5}, 
                     B[2],   // most significant carry out
                     B[1],  // intermediate carry
                     B[0]); // partial sum

    // Second compressor : Compress upper 5bits
    adder_5to3 A531({x6, x7, x8, x9, x10}, 
                     A[2],  // most significant carry out
                     A[1],  // intermediate carry
                     A[0]); // partial sum

    // Intermediate carries for final adders
    wire C1, C2;

    // Final stage : Add partial sums & carries to produce 4bit output
    HA HA0(A[0], 
           B[0], 
           O0,  // output bit 0 (LSB)
           C1); // carry out

    FA FA0(A[1], 
           B[1], 
           C1, 
           O1,  // output bit 1
           C2); // carry out

    FA FA1(A[2], 
           B[2], 
           C2, 
           O2,  // output bit 2
           O3); // output bit 3 (MSB)

endmodule