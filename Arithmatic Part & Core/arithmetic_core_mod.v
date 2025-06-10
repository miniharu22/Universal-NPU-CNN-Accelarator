module arithmetic_core_mod (in, weight, bias, bound_level, step, en,
                            en_relu, en_mp, 
                            out, out_en,
                            clk, reset);
    parameter cell_bit = 8;
    parameter N_cell = 9;
    parameter biasport = 16;
    parameter outport = 8;

    input clk, reset;



    ////////////////////////////////////
    // Processing Element
    // → Convolution Computation
    ////////////////////////////////////

    input [cell_bit*N_cell-1:0] in;
    input [cell_bit*N_cell-1:0] weight;
    input signed [biasport-1:0] bias;
    input [2:0] bound_level;
    input [2:0] step;
    input en;

    wire signed [outport-1:0] out_pe;
    wire out_en_pe;

    PE_m P0(in, weight, bias, bound_level, step, en, out_pe, out_en_pe, clk, reset);



    ////////////////////////////////////
    // ReLU & Maxpooling Enable Signal
    // → clk+2 with D-Flip Flop
    ////////////////////////////////////

    input en_relu, en_mp;

    wire en_relu_d, en_relu_d2;

    D_FF1 D_en_relu0(en_relu, en_relu_d, clk, reset);
    D_FF1 D_en_relu1(en_relu_d, en_relu_d2, clk, reset);

    wire en_mp_d, en_mp_d2;

    D_FF1 D_en_mp0(en_mp, en_mp_d, clk, reset);
    D_FF1 D_en_mp1(en_mp_d, en_mp_d2, clk, reset);



    ////////////////////////////////////
    // ReLU : Activation Function
    ////////////////////////////////////

    wire signed [outport-1:0] out_relu;
    relu r0(out_pe, en_relu_d2, out_relu);



    ////////////////////////////////////
    // Maxpooling 
    ////////////////////////////////////

    output signed [outport-1:0] out;
    output out_en;

    maxpooling m0(out_relu, out_en_pe, en_mp_d2, out, out_en, clk, reset);


endmodule