`timescale 1ns / 1ps

// 8-to-4 Adder module
// Compress 8 input bits into 4 output bits
module adder_8to4(in, O3, O2, O1, O0);

    input [7:0] in;         // 8bit input
    wire x0, x1, x2, x3, x4, x5, x6, x7;
    output O3, O2, O1, O0;  // 4bit output

    // Assign input bits to individual wires
    assign {x0, x1, x2, x3, x4, x5, x6, x7} = in;

    // Intermediate signals for partial sums and carries
    wire s00, s01, s10, s11, s2, c0, c1; 

    // First stage : Compress the top 3bits using a Full Adder
    FA FA0(x5, 
           x6, 
           x7, 
           s00,     // partial sum output
           s10);    // partial carry output

    // First stage : Compress the lower 5bits using a 5-to-3 compressor adder
    adder_5to3 A530( {x0, x1, x2, x3, x4}, 
                      s2,   // most significant carry-out
                      s11,  // intermediate carry
                      s01); // partial sum

    // Second stage : Add partial sums from first stage
    HA HA0(s00, 
           s01, 
           O0,  // output bit 0 (LSB)
           c0); // carry out

    // Second stage : Add intermediate carries & carry out
    FA FA1(s10, 
           s11, 
           c0, 
           O1,  // output bit 1
           c1); // carry out

    // Final stage : Add most significant carry & carry out  
    HA HA1(s2, 
           c1, 
           O2,  // output bit 2
           O3); // output bit 3 (MSB)

endmodule