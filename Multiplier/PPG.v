// Partial Product Generator module
// Generates partial products based on Modified Booth Encoding   
module PPG(multiplicand, multiplier, pp0,  pp1,  pp2,  pp3, neg0, neg1, neg2, neg3);

    // 8bit signed multiplicand & multiplier
    input signed [7:0] multiplicand, multiplier;    
    
    // Array of 3bit signals to store the Booth-encoded controls for each partial product
    wire [2:0] S[0:3];

    // Line 0 : Booth encoding for 4 partial product groups using MBE_enc
    wire [2:0] S0;

    MBE_enc Me0(multiplier[1], multiplier[0], 1'b0, S[0]);          // 1st 3bit window (LSB Side)
    MBE_enc Me1(multiplier[3], multiplier[2], multiplier[1], S[1]); // 2nd 3bit window
    MBE_enc Me2(multiplier[5], multiplier[4], multiplier[3], S[2]); // 3rd 3bit window
    MBE_enc Me3(multiplier[7], multiplier[6], multiplier[5], S[3]); // 4th 3bit window (MSB Side)

    // Array of 8bit signals for signed correction (Two's complement if negative)
    wire [7:0] sign[0:3];

    // Generate sign-adjusted multiplicand for each partial product
    genvar i;
    generate
    for(i=0; i<4; i=i+1) begin : signa
        // If partial product is negative, compute two's complement of multiplicand
        // Equivalent to XOR with sign bit replicated 8 times (same as sign extension)
        assign sign[i] = multiplicand ^ {S[i][2], S[i][2], S[i][2], S[i][2], S[i][2], S[i][2], S[i][2], S[i][2]};
    end
    endgenerate

    // Array of 9bit partial product results
    wire [8:0] m[0:3];

    genvar j;
    generate
    for(j=0; j<4; j=j+1) begin : multia // Determine partial product based on Booth encoding
        assign m[j] = S[j][0] ? 9'b0_0000_0000 :        // If S[j][0] is 1, output zero
                      S[j][1] ? {sign[j][7],sign[j]} :  // If S[j][i] is 1, output 1xmultiplicand
                                {sign[j], S[j][2]};     // Else, output shifted multiplicand for 2x (same as sign-extended form)

    end
    endgenerate

    // Outputs for partial products
    output [10:0] pp0;
    output [8:0] pp1, pp2, pp3;

    // Adjust the sign & format of each partial product for the next stage of multiplication
    assign pp0 = {~m[0][8], m[0][8], m[0]}; // 11bit output : sign correction + 9bit partial product
    assign pp1 = {~m[1][8], m[1][7-:8]};    // 9bit output : sign correction + 8bits
    assign pp2 = {~m[2][8], m[2][7-:8]};    // 9bit output
    assign pp3 = {~m[3][8], m[3][7-:8]};    // 9bit output

    // Flags indicating if the partial product is negative
    output neg0, neg1, neg2, neg3;

    // Determine if the partial product is negative (sign bit 1 and zero flag 0)
    assign neg0 = (S[0][2]) & (~S[0][0]);
    assign neg1 = (S[1][2]) & (~S[1][0]);
    assign neg2 = (S[2][2]) & (~S[2][0]);
    assign neg3 = (S[3][2]) & (~S[3][0]);

endmodule