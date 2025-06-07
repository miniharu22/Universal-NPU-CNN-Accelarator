// Adder Tree Stage 2 Module
// Combine the intermediate partial sums & previous output(clipped data) for next stage
module addertree_stage2(x18, x17, x16, x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, x3,
                        pre_output,
                        o19, o18, o17, o16, o15, o14, o13, o12, o11, o10, o9, o8, o7, o6, o5, o4, o3
                        );

    // Partial sums from previous stage
    input x18;
    input [1:0] x17;
    input [2:0] x16;
    input [4:0] x15, x14;
    input [6:0] x13;
    input [8:0] x12;
    input [9:0] x11;
    input [10:0] x10;
    input [11:0] x9;
    input [10:0] x8;
    input [9:0] x7;
    input [9:0] x6;
    input [8:0] x5;
    input [7:0] x4;
    input [5:0] x3;

    // Clipped data from previous cycle    
    input [13:1] pre_output;

    // Output of 2nd stage
    wire p19;   // Carry out bit from x18 addition
    output o19;
    output [2:0] o18, o17;
    output [3:0] o16, o15, o14, o13, o12, o11, o10, o9, o8, o7;
    output [2:0] o6, o5;
    output [1:0] o4;
    output o3;

    // Half Adder to compute carry out for x18 additon with 
    assign o19 = ~(p19 ^ pre_output[13]);
    HA A180(x18, pre_output[13], o18[0], p19);

    // Full Adder for x17 inputs & previous data
    FA A170(x17[0], x17[1], pre_output[12], o17[0], o18[1]);

    // 4-to-3 adder for x16 & previous data
    adder_4to3 A160({x16, pre_output[11]}, o18[2], o17[1], o16[0]);

    // 6-to-3 adder for x15 & previous data
    adder_6to3 A150({x15, pre_output[10]}, o17[2], o16[1], o15[0]);

    // 6-to-3 adder for x14 & previous data
    adder_6to3 A140({x14, pre_output[9]}, o16[2], o15[1], o14[0]);

    // 8-to-4 adder for x13 & previous data
    adder_8to4 A130({x13, pre_output[8]}, o16[3], o15[2], o14[1], o13[0]);

    // 10-to-4 adder for x12 & previous data
    adder_10to4 A120({x12, pre_output[7]}, o15[3], o14[2], o13[1], o12[0]);

    // 11-to-4 adder for x11 & previous data
    adder_11to4 A110({x11, pre_output[6]}, o14[3], o13[2], o12[1], o11[0]);

    // 12-to-4 adder for x10 & previous data
    adder_12to4 A100({x10, pre_output[5]}, o13[3], o12[2], o11[1], o10[0]);

    // 13-to-4 adder for x9 & previous data
    adder_13to4 A90({x9, pre_output[4]}, o12[3], o11[2], o10[1], o9[0]);

    // 12-to-4 adder for x8 & previous data
    adder_12to4 A80({x8, pre_output[3]}, o11[3], o10[2], o9[1], o8[0]);

    // 11-to-4 adder for x7 & previous data
    adder_11to4 A70({x7, pre_output[2]}, o10[3], o9[2], o8[1], o7[0]);

    // 11-to-4 adder for x6 & previous data
    adder_11to4 A60({x6, pre_output[1]}, o9[3], o8[2], o7[1], o6[0]);

    // 9-to-4 adder for x5 
    adder_9to4 A50(x5, o8[3], o7[2], o6[1], o5[0]);

    // 8-to-4 adder for x4
    adder_8to4 A40(x4, o7[3], o6[2], o5[1], o4[0]);

    // 6-to-4 adder for x3
    adder_6to3 A30(x3, o5[2], o4[1], o3);                                                                                                                                       

endmodule