// 13-to-4 Adder module
// Compress 13 input bits into 4 output bits
module adder_13to4(in, O3, O2, O1, O0);

    input [12:0] in;        // 13bit input
    wire x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12;
    output O3, O2, O1, O0;  // 4bit output (sum)

    // Assign input bits to individual wires
    assign {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12} = in;

    // Intermediate partial sums & carries outputs from compressors
    wire A[2:0];    // Partial sum & carry outputs for upper 6-to-3 adder
    wire B[2:0];    // Partial sum & carry outputs for lower 6-to-3 adder

    // First compressor : Compress lower 7bits
    adder_7to3 A730({x0, x1, x2, x3, x4, x5, x6}, 
                     B[2],  // most significant carry out
                     B[1],  // intermediate carry
                     B[0]); // partial sum

    // Second compressor : Compress upper 6bits
    adder_6to3 A630({x7, x8, x9, x10, x11, x12}, 
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
