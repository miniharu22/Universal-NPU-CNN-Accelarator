`timescale 1ns/10ps

// Final Adder Testbench
module tb_adderfinal;

	reg clk, reset;

    // 2bit carry-save input vectors for adder_final input
    wire [1:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13;
    // 14bit output of adder_final module & expected output
    wire [13:0] out, p_out;
	
	// Instantiate the adder_final module
    adder_final A0(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13,
                    out);

    // 14bit input operands for testing
    reg [13:0] in0, in1;

    // assign the LSB of carry-save inputs to in0
    assign {x0[0], x1[0], x2[0], x3[0], x4[0], x5[0], x6[0], x7[0], x8[0], x9[0], x10[0], x11[0], x12[0], x13[0]} = in0;
    // assign the MSB of carry-save inputs to in1
    assign {x0[1], x1[1], x2[1], x3[1], x4[1], x5[1], x6[1], x7[1], x8[1], x9[1], x10[1], x11[1], x12[1], x13[1]} = in1;

    // Compute the expected output   
    wire [14:0] outb;           // 15bit to capture possible carry-out
    assign outb = in0 + in1;    
    assign p_out = outb[13:0];  // Expected 14bit sum

    integer err = 0, i = 0, j = 0;

	initial
	begin
    // Initialize onputs
    in0 = 14'b00_0000_0000_0000;
    in1 = 14'b00_0000_0000_0000;		
    #10
            // Test loop : 14bit input combinations
			for (i=0; i<16384; i=i+1)
			begin
                in0 = in0 + 1;
                for (j=0; j<16384; j=j+1)
                begin
                    in1 = in1 + 1;
                    #(1);
                    if (out != p_out) err = err + 1;
                    #(9);
                end
			end
		end

endmodule