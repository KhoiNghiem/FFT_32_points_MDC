module ROM8 (
    input reg [2:0] rom_8_counter,
    output reg signed [8:0] w_r, 
    output reg signed [8:0] w_i
);

    // ROM lưu cos/sin quadrant I (0..7)
    reg signed [8:0] cos_q1 [0:3];
    reg signed [8:0] sin_q1 [0:3];


    initial begin
        // Q1: theta = -2*pi*k/32, k=0:7
        cos_q1[0] = 9'sd128; sin_q1[0] = 9'sd0;
        cos_q1[1] = 9'sd118; sin_q1[1] = 9'sd48;
        cos_q1[2] = 9'sd90;  sin_q1[2] = 9'sd90;
        cos_q1[3] = 9'sd48;  sin_q1[3] = 9'sd118;
    end

    always @(*) begin
        case (rom_8_counter)
            4'd0: begin
                w_r = cos_q1[0];
                w_i = -sin_q1[0];
            end
            4'd1: begin
                w_r = cos_q1[1];
                w_i = -sin_q1[1];
            end
            4'd2: begin
                w_r = cos_q1[2];
                w_i = -sin_q1[2];
            end
            4'd3: begin
                w_r = cos_q1[3];
                w_i = -sin_q1[3];
            end
            4'd4: begin
                w_r = -sin_q1[0];
                w_i = -cos_q1[0];
            end
            4'd5: begin
                w_r = -sin_q1[1];
                w_i = -cos_q1[1];
            end
            4'd6: begin
                w_r = -sin_q1[2];
                w_i = -cos_q1[2];
            end
            4'd7: begin
                w_r = -sin_q1[3];
                w_i = -cos_q1[3];
            end
            default: begin
                w_r = 0;
                w_i = 0;
            end
        endcase
    end

endmodule