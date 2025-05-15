`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 03:13:36 PM
// Design Name: 
// Module Name: ROM4
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


module ROM4 (
    input [1:0] rom_4_counter,
    output reg signed [8:0] w_r, 
    output reg signed [8:0] w_i
);

    // ROM lưu cos/sin quadrant I (0..7)
    reg signed [8:0] cos_q1 [0:1];
    reg signed [8:0] sin_q1 [0:1];


    initial begin
        // Q1: theta = -2*pi*k/32, k=0:7
        cos_q1[0] = 9'sd128; sin_q1[0] = 9'sd0;
        cos_q1[1] = 9'sd90;  sin_q1[1] = 9'sd90;
    end

    always @(*) begin
        case (rom_4_counter)
            4'd0: begin
                w_r = cos_q1[0];
                w_i = -sin_q1[0];
            end
            4'd1: begin
                w_r = cos_q1[1];
                w_i = -sin_q1[1];
            end
            4'd2: begin
                w_r = -sin_q1[0];
                w_i = -cos_q1[0];
            end
            4'd3: begin
                w_r = -sin_q1[1];
                w_i = -cos_q1[1];
            end
            default: begin
                w_r = 0;
                w_i = 0;
            end
        endcase
    end

endmodule
