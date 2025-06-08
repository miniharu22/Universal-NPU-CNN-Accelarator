// 2bit Carry Look Ahead Adder     
// Calculate fast carry propagation for 2bit addition     
module CLG2(x1, y1, x2, y2, c1,
            s1, s2, c3);

    input x1, y1, x2, y2, c1;   // two 2bit numbers & carry-in
    wire p1, c2, p2, g1, g2;    
    output s1, s2, c3;          // two sum bits & carry out

    // Carry Propagation (p)
    assign p1 = x1 ^ y1;        
    assign p2 = x2 ^ y2;
    // Carry Generator (g)
    assign g1 = x1 & y1;
    assign g2 = x2 & y2;

    // Calculate carry bits
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & g1) | (p2 & p1 & c1);

    // Calculate sum bits
    assign s1 = c1 ^ p1;
    assign s2 = c2 ^ p2;

endmodule