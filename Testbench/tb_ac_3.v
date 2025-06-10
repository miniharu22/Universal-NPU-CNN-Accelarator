`timescale 1ns/10ps

module tb_ac_3;

	reg clk, reset;

    reg [8*9-1:0] mat_in [0:63];        
	reg [8*9-1:0] in;
    
    reg signed [8-1:0] weight[0:8];     // 3x3 Filter
    wire [8*9-1:0] weightin;
    assign weightin = {weight[0], weight[1], weight[2], weight[3], weight[4], weight[5], weight[6], weight[7], weight[8]}; 

    reg signed [16-1:0] bias;
    reg [2:0] bound_level;
    reg [2:0] step;
    reg en, en_relu, en_mp;

    wire out_en;
	wire signed [8-1:0] out;
	
    arithmetic_core_mod A0 (in, weightin, bias, bound_level, step, en,
                            en_relu, en_mp, 
                            out, out_en,
                            clk, reset);
    
    reg signed [8-1:0] mat_out [0:7];
    reg signed [8-1:0] p_out;

	
	initial
	begin
		clk <= 1;
		reset <= 0;
        en_relu <= 0;
        en_mp <= 0;
		en <= 0;

		#12 reset <= 1;
        #8
        #10
		#1  bias <= 16'b0000_0000_0000_0000;
            en_relu <= 1;           // Enable ReLU
            en_mp <= 1;             // Enable Maxpooling
            bound_level <= 3'b000;  
            step <= 3'b001;         // Multi-clk Acuumulation
	end
	
	always #5 clk <= ~clk;

	
    integer i=0, j=0;

	initial
	begin		
		$readmemh("C://MY/Vivado/UniNPU/UniNPU.srcs/data/input_pe.txt", mat_in);
		$readmemh("C://MY/Vivado/UniNPU/UniNPU.srcs/data/input_pe_wi.txt", weight);
		begin
			
			#(31);
			for (i=0; i<64; i=i+1)
			begin
				in <= mat_in[i];
				en <= 1;
				#(10);
			end
            en <= 0;    // Disable after Input
		end
	end

	
	integer err = 0, err1 = 0;
	initial
	begin		
		$readmemh("C://MY/Vivado/UniNPU/UniNPU.srcs/data/output_ac2.txt", mat_out);
		begin
			#(60); 
			for (j=0; j<8; j=j+1)
			begin
                p_out = mat_out[j];
                #(79);
				if (out_en != 1) err = err + 1;  // Computation Fail error
				if (out != p_out) err = err + 1; // Output Exact match error
				if (out - p_out > 'sd1 | out - p_out < -'sd1) err1 = err1 + 1;  // ±1 Differenece Error    
				#(1);
			end
		end

	end

endmodule