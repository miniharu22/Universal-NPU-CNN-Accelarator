// Entire NPU module including Arithmetic, Memory, Control Part
module npu (write_w, write_h, data_in, en_in, readi_w, readi_h, en_read, 
            en_bias, step, en_pe, bound_level, step_p, en_relu, en_mp, 
            out, out_en, clk, reset);

    parameter width = 80;
    parameter height = 8;

    parameter width_b = 7;
    parameter height_b = 3;

    input [width_b-1:0]  write_w;
    input [height_b-1:0]  write_h;
    input [width_b*9-1:0] readi_w;
    input [height_b*9-1:0]  readi_h;
    input [8*9-1:0] data_in;
    input [8:0] en_in, en_read;
    input en_bias, en_pe, en_relu, en_mp, clk, reset;
    input [2:0] step, step_p, bound_level;

    output [8*8-1:0] out;
    output [7:0] out_en;

    wire [8*9-1:0] fmaps, fmap;
    wire [8*9*8-1:0] weight;
    wire [16*8-1:0] biases, biasp;

    reg [2:0] step_d, bound_level_d;
    reg en_pe_d;


    always @(posedge clk) begin
        en_pe_d <= en_pe;
        step_d <= step_p;
        bound_level_d <= bound_level;
    end

    control_part #(width, height, width_b, height_b) control (en_read, en_bias, fmaps, biases, fmap, biasp, clk);

    memory_part #(width, height, width_b, height_b) memory (write_w, write_h, data_in, readi_w, readi_h, step, en_in, fmaps, biases, weight, clk);

    AP arithmetic (fmap, weight, biasp, bound_level_d, step_d, en_pe_d, en_relu, en_mp, out, out_en, clk, reset);

endmodule