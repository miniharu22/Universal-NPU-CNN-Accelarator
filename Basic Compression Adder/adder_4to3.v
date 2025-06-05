`timescale 1ns / 1ps

// 4-to-3 Adder module
// Compress 4 input bits into 3 output bits
module adder_4to3(in, cout, carry, sum);

    input [3:0] in;             // 4bit input
    wire x0, x1, x2, x3;        // individual input bits
    output cout, carry, sum;    // output bits : final carry out, intermediate carry, sum

    // Assign input bits to individual wires
    assign {x0, x1, x2, x3} = in;

    wire s0, c0, c1;    // intermediate signals


    FA FA0(x0, x1, x2, s0, c0); // 1st stage : Full Adder for x0, x1, x2
    HA HA0(x3, s0, sum, c1);    // 2nd stage : Half Adder for x3 and sum from first stage
    HA HA1(c0, c1, carry, cout);// 3rd stage : Half Adder for carries from first & second stages

endmodule