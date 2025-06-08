// Fianl adder module based on CLA Generators
// Take in multiple pairs of 2bit inputs from previous adder stages
// Combine them to produce the final 14bit output    
module adder_final(i19, i18, i17, i16, i15, i14, i13, i12, i11, i10, i9, i8, i7, i6,
                    out);

    // 2bits wide-input : partial sums from the previous adder stage
    input [1:0] i19, i18, i17, i16, i15, i14, i13, i12, i11, i10, i9, i8, i7, i6;
    wire c0, c1, c2, c3, c4;
    output [13:0] out;  // Final output sum (14bit)

    // Sum i6, producing output bit [0] & carry(c0)
    HA HA0(i6[0], i6[1], out[0], c0);

    // Sum i7 with carry-in c0, producing output bit [1] & carry(c1)
    FA FA0(i7[0], i7[1], c0, out[1], c1);

    // Sum i8 ~ i9 with carry-in c1, producing output bits [2:3] & carry(c2)
    CLG2 C0(i8[0], i8[1], i9[0], i9[1], c1, out[2], out[3], c2);

    // Sum i10 ~ i11 with carry-in c2, producing output bits [4:5] & carry(c3)
    CLG2 C1(i10[0], i10[1], i11[0], i11[1], c2, out[4], out[5], c3);

    // Sum i12 ~ i15 with carry-in c3, producing output bits [6:9] & carry(c4)
    CLG4 C2(i12[0], i12[1], i13[0], i13[1], i14[0], i14[1], i15[0], i15[1], c3, out[6], out[7], out[8], out[9], c4);

    // Sum i16 ~ i19 with carry-in c4, producing output bits [10:13]
    CLG4_3 C3(i16[0], i16[1], i17[0], i17[1], i18[0], i18[1], i19[0], i19[1], c4, out[10], out[11], out[12], out[13]);

endmodule