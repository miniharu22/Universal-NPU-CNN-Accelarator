// 9-to-4 Adder module   
// Compress 9 input bits into 4 output bits
module adder_9to4(in, O3, O2, O1, O0);

    input [8:0] in;         // 9bit input
    wire x0, x1, x2, x3, x4, x5, x6, x7, x8;
    output O3, O2, O1, O0;  // 4bit output

    // Assign input bits to individual wires
    assign {x0, x1, x2, x3, x4, x5, x6, x7, x8} = in;

    // Intermediate signals for partial sums & carries
    wire s00, s01, s10, s11, s2, c0, c1; 

    // First stage : Compress the top 2bit using a Half adder
    HA HA0(x7, 
           x8, 
           s00,     // partial sum output
           s10);    // partial carry output

    // First stage : Compress the lower 7bits using a 7-to-3 compressor 
    adder_7to3 A730( {x0, x1, x2, x3, x4, x5, x6}, 
                      s2,   // most significant carry out
                      s11,  // intermediate carry
                      s01); // partial sum

    // Second stage : Add partial sums from first stage
    HA HA1(s00, 
           s01, 
           O0,  // output bit 0 (LSB)
           c0); // carry out
    
    // Second stage : Add intermediate carries & carry out
    FA FA0(s10, 
           s11, 
           c0,  
           O1,  // output bit 1
           c1); // carry out

    // Final stage : Add most significant carry & carry out
    HA HA2(s2, 
           c1, 
           O2,  // output bit 2
           O3); // output bit 3 (MSB)

endmodule
