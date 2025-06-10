module maxpooling(in, en, en_mp, out, out_en, clk, reset);

    input signed [7:0] in;
    input en, en_mp;                // en : PE output valid signal
                                    // en_mp : Maxpooling enable signal
    input clk, reset;
    output reg signed [7:0] out;
    output reg out_en;              // Output valid signal

    // Enable signals for counting and bypass mode
    wire en_count, en2;
    assign en_count = en & en_mp;    // max pooling mode
    assign en2 = en & (~en_mp);      // bypass mode

    // Max value register (internal register to hold the max value during pooling window)
    reg signed [7:0] max_val;

    // Pooling window counter
    reg [1:0] count;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            count <= 0;
            max_val <= -128;        // Initialize max_val to smallest value
            out <= 0;
            out_en <= 0;
        end
        else if (en_count) begin    // max pooling mode
            // Update max_val if current input is larger
            if (in > max_val)
                max_val <= in;

            // Counter for 4 samples (2x2 window)
            if (count == 2'b11) begin
                count <= 0;
                out <= max_val;     // output the final max value
                out_en <= 1;
                max_val <= -128;    // reset max_val for next window
            end
            else begin
                count <= count + 1;
                out_en <= 0;        // no valid output until window done
            end
        end
        else if (en2) begin         // bypass mode: output input directly
            out <= in;
            out_en <= 1;
            count <= 0;
            max_val <= -128;
        end
        else begin                  // if no enable signals, keep output stable
            out_en <= 0;
        end
    end

endmodule