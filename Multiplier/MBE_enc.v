// Modified Booth Encoder
// Encodes a 3bit Booth window into sign, magnitude, and zero flags for partial product generation
module MBE_enc(A, B, C, S);

    input A, B, C;      // Three consecutive input bits (Booth Window)
    output [2:0] S;     // Output encoding  
                        // S[2] = sign (0: +, 1: -)
                        // S[1] = mult (0 : 0 or 2, 1: 1)
                        // S[0] = zero (0: not zero, 1: zero)

    // Determine sign of the partial product
    // Sign is determined by the most significant bit of the 3bit Booth window
    assign S[2] = A;    

    // Determine if the multiflier is 1 (mult=1) or 2 (mult=0)
    // If B and C differ, then multiplier is 1 (odd case); else it's 0 or 2
    assign S[1] = B ^ C;

    // Determine if the partial product is zero (zero = 1)
    // Partial product is zero if all 3bits are the same 
    assign S[0] = (A & B & C) | ((~A) & (~B) & (~C));

endmodule