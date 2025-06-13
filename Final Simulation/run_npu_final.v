`timescale 1ns / 1ps

module run_npu_final;

    parameter width = 80;
    parameter height = 8;

    parameter width_b = 7;
    parameter height_b = 3;

    parameter input_width = 128;
    parameter input_height = 128;

    parameter step0 = width - 9;
    parameter step1 = width - 18;
    parameter step2 = width - 27;
    parameter step3 = width - 36;
    parameter step4 = width - 45;
    parameter step5 = width - 54;


    reg [8-1:0] mat_in [0:128*128-1];
    reg signed [8-1:0] weight [0:8];
    reg signed [16-1:0] bias [0:8];
    reg [8-1:0] mat_out [0:128*128-1];


    reg [width_b-1:0]  write_w0;
    reg [height_b-1:0]  write_h0;
    reg [width_b*9-1:0] readi_w0;
    reg [height_b*9-1:0]  readi_h0;
    reg [8*9-1:0] data_in0;
    reg [8:0] en_in0, en_read0;
    reg en_bias0;
    reg [2:0] step00;
    reg en_pe0;


    wire [width_b-1:0]  write_w[1:5];
    wire [height_b-1:0]  write_h[1:5];
    wire [width_b*9-1:0] readi_w[1:5];
    wire [height_b*9-1:0]  readi_h[1:5];
    wire [8*9-1:0] data_in[1:5];
    wire [8:0] en_in[1:5], en_read[1:5];
    wire en_bias[1:5];
    wire [2:0] step[1:5];
    wire en_pe[1:5];

    reg [2:0] step_p, bound_level;
    reg en_relu, en_mp;
    reg clk, reset;

    wire [8*8-1:0] out;
    wire [7:0] out_en;

    reg [width_b-1:0] readi_w_each[0:8];
    reg [height_b-1:0] readi_h_each;

    npu_simple npu (write_w0, write_h0, data_in0, en_in0, readi_w0, readi_h0, en_read0, en_bias0, step00, en_pe0, bound_level, step_p,
                        en_relu, en_mp, 
                        out, out_en, clk, reset);

    always #5 clk <= ~clk;

    integer i=0, j=0, k=0, select=0;


    wire [7:0] out_1;
    assign out_1 = out[8*8-1-:8];

    always @(*) begin
        write_w0 = write_w[select+1];
        write_h0 = write_h[select+1];
        data_in0 = data_in[select+1];
        en_in0 = en_in[select+1];
        readi_w0 = readi_w[select+1];
        readi_h0 = readi_h[select+1];
        en_read0 = en_read[select+1];
        en_bias0 = en_bias[select+1];
        step00 = step[select+1];
        en_pe0 = en_pe[select+1];
    end


    initial
    begin
        clk <= 1;
        reset <= 0;
        en_relu <= 1;
        en_mp <= 1;
        bound_level <= 3'b011;
        #12
        reset <= 1;
        step_p <= 3'b000;

        #(9500-12);
        reset <= 0;
        bound_level <= 3'b101;
        #12
        reset <= 1;
        select <= 1;
        step_p <= 3'b001;


    end



    run_33 #( .input_width(28), .input_height(28), .write_delay(31), .read_delay(881), .save_delay(941),
        .input_file("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Input/input_npu.txt"), 
        .weight_file("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Input/l0 weight.txt"), 
        .bias_file ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Input/l0 bias.txt"), 
        .output_file0 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c0.txt"), 
        .output_file1 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c1.txt"), 
        .output_file2 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c2.txt"), 
        .output_file3 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c3.txt"),
        .output_file4 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c4.txt"), 
        .output_file5 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c5.txt"), 
        .output_file6 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c6.txt"), 
        .output_file7 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c7.txt"))
            layer0 (write_w[1], write_h[1], data_in[1], en_in[1], readi_w[1], readi_h[1], en_read[1], step[1], en_bias[1], en_pe[1], out, out_en, clk);


    run_44 #( .input_width(14), .input_height(14), .write_delay(31+9500), .read_delay(881+9500), .save_delay(951+9500),
        .input_file("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l0c0.txt"), 
        .weight_file("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Input/l2 weight.txt"), 
        .bias_file ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Input/l2 bias.txt"), 
        .output_file0 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c00.txt"), 
        .output_file1 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c01.txt"), 
        .output_file2 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c02.txt"), 
        .output_file3 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c03.txt"),
        .output_file4 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c04.txt"), 
        .output_file5 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c05.txt"), 
        .output_file6 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c06.txt"), 
        .output_file7 ("C://MY/Vivado/UniNPU/UniNPU.srcs/data/NPU_Run_Data/Output/output_npu_l2c07.txt"))
            layer20 (write_w[2], write_h[2], data_in[2], en_in[2], readi_w[2], readi_h[2], en_read[2], step[2], en_bias[2], en_pe[2], out, out_en, clk);




endmodule