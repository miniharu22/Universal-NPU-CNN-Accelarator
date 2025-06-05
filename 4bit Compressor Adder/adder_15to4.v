// 15-to-4 Adder module
// Compress 15 input bits into 4 output bits
module adder_15to4(in, O3, O2, O1, O0);

    input [14:0] in;        // 15bit input
    wire x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14;
    output O3, O2, O1, O0;  // 4bit output (sum)

    // Assign input bits to individual wires
    assign {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14} = in;

    // Intermediate wires for partial sums & carries of each 3bit group
    wire cout[0:4], sum[0:4];

    // Stage 1 : Compress each group of three input bits using Full Adders
    FA F0(x0, 
          x1, 
          x2, 
          sum[0],   // partial sum
          cout[0]); // carry out

    FA F1(x3, 
          x4, 
          x5, 
          sum[1],   // partial sum
          cout[1]); // carry out

    FA F2(x6, 
          x7, 
          x8, 
          sum[2],   // partial sum
          cout[2]); // carry out

    FA F3(x9, 
          x10, 
          x11, 
          sum[3],   // partial sum
          cout[3]); // carry out

    FA F4(x12, 
          x13, 
          x14, 
          sum[4],   // partial sum
          cout[4]); // carry out

    // Intermediate wires for next stage
    wire A[3:1];    // carries from carry compressor
    wire B[2:0];    // partial sums from sum compressor

    // Stage 2 : Compress partial sums using 5-to-3 compressor
    adder_5to3 A530({sum[0], sum[1], sum[2], sum[3], sum[4]}, 
                     B[2],  // mist significant carry out
                     B[1],  // intermediate carry
                     B[0]); // partial sum

    // Stage 2 : Compress carries using 5-to-3 compressor 
    adder_5to3 A531({cout[0], cout[1], cout[2], cout[3], cout[4]}, 
                     A[3],  // most significant carry out
                     A[2],  // intermediate carry
                     A[1]); // partial sum

    // Final outputs & intermediate carries
    assign O0 = B[0];   // output bit 0 (LSB)

    wire C1, C2;

    // Final stage : Combine intermediate sums & carries
    HA HA0(A[1], 
           B[1], 
           O1,  // output bit 1
           C1); // carry out

    FA FA5(A[2], 
           B[2], 
           C1, 
           O2,  // output bit 2
           C2); // carry out

    // Final output bit (MSB)
    assign O3 = A[3] ^ C2;

endmodule
