`timescale 1ns/10ps

module tb_ap();

    parameter cell_bit = 8;
    parameter N_cell = 9;
    parameter biasport = 16;
    parameter N_core = 8;
    parameter outport = 8;

    reg [cell_bit*N_cell-1:0] in;               // 72bit Input feature map
    reg [cell_bit*N_cell*N_core-1:0] weight;    // 72bit weight x 8
    reg [biasport*N_core-1:0] bias;             // 16bit bias x 8 
    reg [2:0] bound_level;      
    reg [2:0] step;
    reg en, en_relu, en_mp;
    reg clk, reset;

    wire [outport*N_core-1:0] out;              // 8bit output x 8
    wire [N_core-1:0] out_en;

    always #5 clk <= ~clk;


    reg [223:0] mat_in[0:27];   // 28 rows of 224bit(28 x 8bit pixel) input feature map 
    reg [7:0] inp[0:27][0:27];  // 28x28 matrix with 8bit pixels from mat_in
      
    reg [7:0] weight0[0:15];    // 1st layer weight : 16rows of 8bit 
    reg [15:0] bias0[0:1];      // 1st layer bias : 2rows of 16bit
    reg [7:0] out0[0:143];      // 1st layer output : 144rows of 8bit

    reg [7:0] in2[0:143];
    reg [7:0] weight20[0:8], weight21[0:8], weight22[0:8], weight23[0:8], weight24[0:8], weight25[0:8], weight26[0:8], weight27[0:8]; // 2nd layer weight : 9rows of 8bit
    reg [15:0] bias2[0:7];      // 2nd layer bias : 8rows of 16bit

    reg signed [7:0] out20[0:24], out21[0:24], out22[0:24], out23[0:24], out24[0:24], out25[0:24], out26[0:24], out27[0:24];

    AP AP0(in, 
           weight, 
           bias, 
           bound_level, 
           step, 
           en, 
           en_relu, 
           en_mp, 
           out, 
           out_en, 
           clk, 
           reset);

    integer i=0, j=0, layer01 = 0, layer02 = 0, f, f0, f1, f2, f3, f4, f5, f6, f7, k;


    ///////////////////////////
    // Simulation Start
    ///////////////////////////

    initial 
        begin


            /////////////////////////////
            // Simulation Initialization
            /////////////////////////////

            clk = 1;
            reset = 0;
            en_relu = 0;
            en_mp = 0;
            en = 0;
            #12
            reset = 1;


            /////////////////////////////
            // Data Loader for 1st layer
            /////////////////////////////

            #9
            $readmemh("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/input_map_hex.txt", mat_in);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l0c0 weight.txt", weight0);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l0 bias.txt", bias0);

            en_relu = 1;            // Enable ReLU 
            en_mp = 1;              // Enable Maxpooling
            en = 1;
            bound_level = 3'b011;   // Clip to -64 ~ 63
            step = 3'b001;          // Multi-clk Accumulation


            /////////////////////////////
            // Convert : mat_in → inp
            /////////////////////////////

            for (i=0; i<28; i=i+1)
                begin
                    for (j=0; j<28; j=j+1)
                    begin
                        inp[i][j] = mat_in[i][223-8*j-:8];  // Extract each 8bit pixels
                        inp[i][j] = inp[i][j] >> 1;         // Right Shift by 1
                    end
                end


            ////////////////////////////////////////////////
            // 1st layer Convolution 
            // stride = 2
            // 28x28 → 12x12
            ////////////////////////////////////////////////

            for (i=0; i<24; i=i+2)  
                begin
                    for (j=0; j<24; j=j+2)  
                        begin
                            in = {inp[i][j], inp[i][j+1], inp[i][j+2], inp[i][j+3], 
                                  inp[i+1][j], inp[i+1][j+1], inp[i+1][j+2], inp[i+1][j+3], 
                                  8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[0], weight0[1], weight0[2], 
                                                                                  weight0[3], weight0[4], weight0[5], 
                                                                                  weight0[6], weight0[7], 8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell :0] = 0;
                            bias[biasport*N_core-1-:biasport] = bias0[0];
                            bias[biasport*N_core-1-biasport:0] = 0;


                            #10
                            in = {inp[i+2][j], inp[i+2][j+1], inp[i+2][j+2], inp[i+2][j+3], 
                                  inp[i+3][j], inp[i+3][j+3], inp[i+3][j+2], inp[i+3][j+3], 
                                  8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[8], weight0[9], weight0[10], 
                                                                                  weight0[11], weight0[12], weight0[13], 
                                                                                  weight0[14], weight0[15], 8'b0000_0000};                                                                                
                            bias[biasport*N_core-1-:biasport] = 0;
                            

                            #10;
                            in = {inp[i][j+1], inp[i][j+1+1], inp[i][j+1+2], inp[i][j+1+3], 
                                  inp[i+1][j+1], inp[i+1][j+1+1], inp[i+1][j+1+2], inp[i+1][j+1+3], 
                                  8'b0000_0000};

                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[0], weight0[1], weight0[2], 
                                                                                  weight0[3], weight0[4], weight0[5], 
                                                                                  weight0[6], weight0[7], 8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell :0] = 0;
                            bias[biasport*N_core-1-:biasport] = bias0[0];
                            bias[biasport*N_core-1-biasport:0] = 0;


                            #10
                            in = {inp[i+2][j+1], inp[i+2][j+1+1], inp[i+2][j+1+2], inp[i+2][j+1+3], 
                                  inp[i+3][j+1], inp[i+3][j+1+3], inp[i+3][j+1+2], inp[i+3][j+1+3], 
                                  8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[8], weight0[9], weight0[10], 
                                                                                  weight0[11], weight0[12], weight0[13], 
                                                                                  weight0[14], weight0[15], 8'b0000_0000};
                            bias[biasport*N_core-1-:biasport] = 0;
                            
                            
                            #10;
                            in = {inp[i+1][j], inp[i+1][j+1], inp[i+1][j+2], inp[i+1][j+3], 
                                  inp[i+1+1][j], inp[i+1+1][j+1], inp[i+1+1][j+2], inp[i+1+1][j+3], 
                                  8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[0], weight0[1], weight0[2], 
                                                                                  weight0[3], weight0[4], weight0[5], 
                                                                                  weight0[6], weight0[7], 8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell :0] = 0;
                            bias[biasport*N_core-1-:biasport] = bias0[0];
                            bias[biasport*N_core-1-biasport:0] = 0;


                            #10
                            in = {inp[i+1+2][j], inp[i+1+2][j+1], inp[i+1+2][j+2], inp[i+1+2][j+3], 
                                  inp[i+1+3][j], inp[i+1+3][j+3], inp[i+1+3][j+2], inp[i+1+3][j+3], 
                                  8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[8], weight0[9], weight0[10], 
                                                                                  weight0[11], weight0[12], weight0[13], 
                                                                                  weight0[14], weight0[15], 8'b0000_0000};
                            bias[biasport*N_core-1-:biasport] = 0;
                            
                            #10;
                            in = {inp[i+1][j+1], inp[i+1][j+1+1], inp[i+1][j+1+2], inp[i+1][j+1+3], 
                                  inp[i+1+1][j+1], inp[i+1+1][j+1+1], inp[i+1+1][j+1+2], inp[i+1+1][j+1+3], 
                                  8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[0], weight0[1], weight0[2], 
                                                                                  weight0[3], weight0[4], weight0[5], 
                                                                                  weight0[6], weight0[7], 8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell :0] = 0;
                            bias[biasport*N_core-1-:biasport] = bias0[0];
                            bias[biasport*N_core-1-biasport:0] = 0;

                            #10
                            in = {inp[i+1+2][j+1], inp[i+1+2][j+1+1], inp[i+1+2][j+1+2], inp[i+1+2][j+1+3], 
                                  inp[i+1+3][j+1], inp[i+1+3][j+1+3], inp[i+1+3][j+1+2], inp[i+1+3][j+1+3], 
                                  8'b0000_0000};
                            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight0[8], weight0[9], weight0[10], 
                                                                                  weight0[11], weight0[12], weight0[13], 
                                                                                  weight0[14], weight0[15], 8'b0000_0000};
                            bias[biasport*N_core-1-:biasport] = 0;
                            
                            #10;
                        end
                end

            en = 0;
            #100


            /////////////////////////////////////////
            // Data Loader for 1st layer
            // 1st layer output → 2nd layer input
            /////////////////////////////////////////

            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer01.txt", in2);
            for (i = 0; i < 12; i = i+1)
                begin
                    for (j = 0; j < 12; j = j+1)
                        begin
                            inp[i][j] = in2[i*12+j];
                        end
                end

            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c0 weight.txt", weight20);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c1 weight.txt", weight21);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c2 weight.txt", weight22);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c3 weight.txt", weight23);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c4 weight.txt", weight24);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c5 weight.txt", weight25);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c6 weight.txt", weight26);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2c7 weight.txt", weight27);
            $readmemb("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/l2 bias.txt", bias2);

            reset = 0;
            #10
            reset = 1;
            en = 1;
            bound_level = 3'b101;   // Clip to -4 ~ 63
            step = 3'b000;          // No multi-clk accumulation (3x3 Filter)


            /////////////////////////////////////////
            // Split weight data to eight 3x3 filter
            /////////////////////////////////////////

            weight[cell_bit*N_cell*N_core-1 -:cell_bit*N_cell] = {weight20[0], weight20[1], weight20[2], 
                                                                  weight20[3], weight20[4], weight20[5], 
                                                                  weight20[6], weight20[7], weight20[8]};

            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell*1 -:cell_bit*N_cell] = {weight21[0], weight21[1], weight21[2], 
                                                                                    weight21[3], weight21[4], weight21[5], 
                                                                                    weight21[6], weight21[7], weight21[8]};

            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell*2 -:cell_bit*N_cell] = {weight22[0], weight22[1], weight22[2], 
                                                                                    weight22[3], weight22[4], weight22[5], 
                                                                                    weight22[6], weight22[7], weight22[8]};

            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell*3 -:cell_bit*N_cell] = {weight23[0], weight23[1], weight23[2], 
                                                                                    weight23[3], weight23[4], weight23[5], 
                                                                                    weight23[6], weight23[7], weight23[8]};

            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell*4 -:cell_bit*N_cell] = {weight24[0], weight24[1], weight24[2], 
                                                                                    weight24[3], weight24[4], weight24[5], 
                                                                                    weight24[6], weight24[7], weight24[8]};

            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell*5 -:cell_bit*N_cell] = {weight25[0], weight25[1], weight25[2], 
                                                                                    weight25[3], weight25[4], weight25[5], 
                                                                                    weight25[6], weight25[7], weight25[8]};

            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell*6 -:cell_bit*N_cell] = {weight26[0], weight26[1], weight26[2], 
                                                                                    weight26[3], weight26[4], weight26[5], 
                                                                                    weight26[6], weight26[7], weight26[8]};

            weight[cell_bit*N_cell*N_core-1-cell_bit*N_cell*7 -:cell_bit*N_cell] = {weight27[0], weight27[1], weight27[2], 
                                                                                    weight27[3], weight27[4], weight27[5], 
                                                                                    weight27[6], weight27[7], weight27[8]};

            bias = {bias2[0], bias2[1], bias2[2], bias2[3], bias2[4], bias2[5], bias2[6], bias2[7]};


            ////////////////////////////////////////////////
            // 2st layer Convolution 
            // stride = 2
            // 12x12 → 5x5
            ////////////////////////////////////////////////

            for (i=0; i<10; i=i+2)
                begin
                    for (j=0; j<10; j=j+2)
                        begin
                            in = {inp[i][j], inp[i][j+1], inp[i][j+2], 
                                  inp[i+1][j], inp[i+1][j+1], inp[i+1][j+2],
                                  inp[i+2][j], inp[i+2][j+1], inp[i+2][j+2]};

                            #10
                            in = {inp[i][j+1], inp[i][j+1+1], inp[i][j+1+2], 
                                  inp[i+1][j+1], inp[i+1][j+1+1], inp[i+1][j+1+2],
                                  inp[i+2][j+1], inp[i+2][j+1+1], inp[i+2][j+1+2]};

                            #10
                            in = {inp[i+1][j], inp[i+1][j+1], inp[i+1][j+2], 
                                  inp[i+1+1][j], inp[i+1+1][j+1], inp[i+1+1][j+2],
                                  inp[i+1+2][j], inp[i+1+2][j+1], inp[i+1+2][j+2]};

                            #10
                            in = {inp[i+1][j+1], inp[i+1][j+1+1], inp[i+1][j+1+2], 
                                  inp[i+1+1][j+1], inp[i+1+1][j+1+1], inp[i+1+1][j+1+2],
                                  inp[i+1+2][j+1], inp[i+1+2][j+1+1], inp[i+1+2][j+1+2]};

                            #10;
                        end
                end
            
            en = 0;

        end



    ///////////////////////////////
    // Store 1st layer Output 
    ///////////////////////////////
    

    always @(posedge clk) begin
        if (layer01 < 144 & out_en[7] == 1) begin
            out0[layer01] <= out[outport*N_core-1-:8];
            layer01 <= layer01 + 1;
        end
        else if (layer01 == 144) begin
            f = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer01.txt", "w");
            for (k = 0; k < 144; k = k + 1) begin
                $fdisplay(f, "%b", out0[k]);
            end
            $fclose(f);
        end

        ///////////////////////////////
        // Store 2st layer Output 
        ///////////////////////////////

        if (layer01 == 144 & out_en == 8'b1111_1111 & layer02 < 25) begin
            out20[layer02] <= out[outport*N_core-1-:8];
            out21[layer02] <= out[outport*N_core-1-8*1-:8];
            out22[layer02] <= out[outport*N_core-1-8*2-:8];
            out23[layer02] <= out[outport*N_core-1-8*3-:8];
            out24[layer02] <= out[outport*N_core-1-8*4-:8];
            out25[layer02] <= out[outport*N_core-1-8*5-:8];
            out26[layer02] <= out[outport*N_core-1-8*6-:8];
            out27[layer02] <= out[outport*N_core-1-8*7-:8];

            layer02 <= layer02 + 1;
        end
        else if (layer02 == 25) begin
            //write
            f0 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer20.txt", "w");
            f1 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer21.txt", "w");
            f2 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer22.txt", "w");
            f3 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer23.txt", "w");
            f4 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer24.txt", "w");
            f5 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer25.txt", "w");
            f6 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer26.txt", "w");
            f7 = $fopen("C://MY/Vivado/UniNPU/UniNPU.srcs/data/AP_Data/output layer27.txt", "w");
            for (k = 0; k < 25; k = k + 1) begin
                $fdisplay(f0, "%d", out20[k]);
                $fdisplay(f1, "%d", out21[k]);
                $fdisplay(f2, "%d", out22[k]);
                $fdisplay(f3, "%d", out23[k]);
                $fdisplay(f4, "%d", out24[k]);
                $fdisplay(f5, "%d", out25[k]);
                $fdisplay(f6, "%d", out26[k]);
                $fdisplay(f7, "%d", out27[k]);
            end
            $fclose(f0);
            $fclose(f1);
            $fclose(f2);
            $fclose(f3);
            $fclose(f4);
            $fclose(f5);
            $fclose(f6);
            $fclose(f7);
        end
    end
    
endmodule
