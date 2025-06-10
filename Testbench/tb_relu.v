`timescale 1ns/10ps

module tb_relu;

	reg clk, reset;

    reg [8-1:0] mat_in [0:59];
	
	reg [8-1:0] in;
	wire [8-1:0] out;
	reg en, en_mp;
	wire out_en;

	relu r0(in, en, out);
	
	initial
	begin
		clk = 1;
		reset = 0;
		en = 0;

		#12 reset = 1;
		#8 en = 1;
		#100 en = 0;
		#100 en = 1;
		#100 en = 0;

	end
	
	always #5 clk = ~clk;
	
    integer i=0;

	initial
	begin		
		$readmemh("C://MY/Vivado/UniNPU/UniNPU.srcs/data/input_mp.txt", mat_in);
		begin
			#(20);
			for (i=0; i<60; i=i+1)
			begin
				in = mat_in[i];

				#(10);
			end
		end
	end


endmodule