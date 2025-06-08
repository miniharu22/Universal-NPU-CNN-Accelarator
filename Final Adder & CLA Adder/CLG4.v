// 4bit Carry Look Ahead Adder
// Calculate fast carry propagation for 4bit addition
module CLG4(x1, y1, x2, y2, x3, y3, x4, y4, c1,
            s1, s2, s3, s4, c5);

    input x1, y1, x2, y2, x3, y3, x4, y4, c1;           // two 4bit numbers & carry-in
    wire p1, p2, p3, p4, g1, g2, g3, g4, c2, c3, c4;  
    output s1, s2, s3, s4, c5;                          // four sum bits & carry-out

    // Carry Propagation (p)
    assign p1 = x1 ^ y1;
    assign p2 = x2 ^ y2;
    assign p3 = x3 ^ y3;
    assign p4 = x4 ^ y4;
    // Carry Generator (g)
    assign g1 = x1 & y1;
    assign g2 = x2 & y2;
    assign g3 = x3 & y3;
    assign g4 = x4 & y4;

    // Calculate carry bits for each stage
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & g1) | (p2 & p1 & c1);
    assign c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & c1);
    assign c5 = g4 | (p4 & g3) | (p4 & p3 & g2) | (p4 & p3 & p2 & g1) | (p4 & p3 & p2 & p1 & c1);

    // Calculate sum bits
    assign s1 = c1 ^ p1;
    assign s2 = c2 ^ p2;
    assign s3 = c3 ^ p3;
    assign s4 = c4 ^ p4;

endmodule