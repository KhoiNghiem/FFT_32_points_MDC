`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 03:41:20 PM
// Design Name: 
// Module Name: ROM16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ROM16 (
    input [3:0]     rom_16_counter,
    output reg signed [8:0] w_r, // cosine part (real)
    output reg signed [8:0] w_i  // sine part (imag)
);

    // ROM lưu cos/sin quadrant I (0..7)
    reg signed [8:0] cos_q1 [0:7];
    reg signed [8:0] sin_q1 [0:7];

    initial begin
        // Q1: theta = -2*pi*k/32, k=0:7
        cos_q1[0] = 9'sd128; sin_q1[0] = 9'sd0;
        cos_q1[1] = 9'sd125; sin_q1[1] = 9'sd24;
        cos_q1[2] = 9'sd118; sin_q1[2] = 9'sd48;
        cos_q1[3] = 9'sd106; sin_q1[3] = 9'sd71;
        cos_q1[4] = 9'sd90;  sin_q1[4] = 9'sd90;
        cos_q1[5] = 9'sd71;  sin_q1[5] = 9'sd106;
        cos_q1[6] = 9'sd48;  sin_q1[6] = 9'sd118;
        cos_q1[7] = 9'sd24;  sin_q1[7] = 9'sd125;
    end

    always @(*) begin
        case (rom_16_counter)
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
                w_r = cos_q1[4];
                w_i = -sin_q1[4];
            end
            4'd5: begin
                w_r = cos_q1[5];
                w_i = -sin_q1[5];
            end
            4'd6: begin
                w_r = cos_q1[6];
                w_i = -sin_q1[6];
            end
            4'd7: begin
                w_r = cos_q1[7];
                w_i = -sin_q1[7];
            end
            4'd8: begin
                w_r = -sin_q1[0];
                w_i = -cos_q1[0];
            end
            4'd9: begin
                w_r = -sin_q1[1];
                w_i = -cos_q1[1];
            end
            4'd10: begin
                w_r = -sin_q1[2];
                w_i = -cos_q1[2];
            end
            4'd11: begin
                w_r = -sin_q1[3];
                w_i = -cos_q1[3];
            end
            4'd12: begin
                w_r = -sin_q1[4];
                w_i = -cos_q1[4];
            end
            4'd13: begin
                w_r = -sin_q1[5];
                w_i = -cos_q1[5];
            end
            4'd14: begin
                w_r = -sin_q1[6];
                w_i = -cos_q1[6];
            end
            4'd15: begin
                w_r = -sin_q1[7];
                w_i = -cos_q1[7];
            end
            default: begin
                w_r = 0;
                w_i = 0;
            end
        endcase
    end

endmodule
