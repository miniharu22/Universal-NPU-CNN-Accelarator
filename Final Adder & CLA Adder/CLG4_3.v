// 4bit Carry Look Ahead Adder variant (No carry-out output)
// Same as CLG4 but omit the carry-out signal
module CLG4_3(x1, y1, x2, y2, x3, y3, x4, y4, c1,
            s1, s2, s3, s4);

    input x1, y1, x2, y2, x3, y3, x4, y4, c1;           // two 4bit numbers & carry-out
    wire p1, p2, p3, p4, g1, g2, g3, g4, c2, c3, c4;
    output s1, s2, s3, s4;                              // 4 sum bits

    // Carry Propagation (p)
    assign p1 = x1 ^ y1;
    assign p2 = x2 ^ y2;
    assign p3 = x3 ^ y3;
    assign p4 = x4 ^ y4;
    // Carry Generator (g)
    assign g1 = x1 & y1;
    assign g2 = x2 & y2;
    assign g3 = x3 & y3;

    // Calculate carry bits for each stage
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & g1) | (p2 & p1 & c1);
    assign c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & c1);

    // Calculate sum bits
    assign s1 = c1 ^ p1;
    assign s2 = c2 ^ p2;
    assign s3 = c3 ^ p3;
    assign s4 = c4 ^ p4;

endmodule