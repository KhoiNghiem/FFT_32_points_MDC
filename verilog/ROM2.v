module ROM2 (
    input reg rom_2_counter,
    output reg signed [8:0] w_r, 
    output reg signed [8:0] w_i
);

    // ROM lưu cos/sin quadrant I (0..7)
    reg signed [8:0] cos_q1;
    reg signed [8:0] sin_q1;


    initial begin
        // Q1: theta = -2*pi*k/32, k=0:7
        cos_q1 = 9'sd128; sin_q1 = 9'sd0;
    end

    always @(*) begin
        case (rom_2_counter)
            4'd0: begin
                w_r = cos_q1;
                w_i = -sin_q1;
            end
            4'd1: begin
                w_r = -sin_q1;
                w_i = -cos_q1;
            end
            default: begin
                w_r = 0;
                w_i = 0;
            end
        endcase
    end

endmodule