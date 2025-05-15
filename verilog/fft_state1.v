`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 03:41:20 PM
// Design Name: 
// Module Name: fft_state1
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


module fft_state1 #(
    parameter WIDTH = 9
) (
    input clk,
    input rst_n,
    input [4:0] state_com_mode,
    input       butter_mode,
    input       mul_mode,
    input [6:0] state_code,
    input [3:0] rom_16_counter,

    input signed [WIDTH-1:0] state1_inLI_re,
    input signed [WIDTH-1:0] state1_inLI_im,
    
    output signed [WIDTH-1:0] state1_outUp_re,
    output signed [WIDTH-1:0] state1_outUp_im,
    output signed [WIDTH-1:0] state1_outL_re,
    output signed [WIDTH-1:0] state1_outL_im
);

    wire signed [8:0] state1_comUp_re;
    wire signed [8:0] state1_comUp_im;
    wire signed [8:0] state1_comL_re;
    wire signed [8:0] state1_comL_im;

    wire signed [8:0] state1_shift_re;
    wire signed [8:0] state1_shift_im;

    wire signed [9:0] state1_butter_up_re;
    wire signed [9:0] state1_butter_up_im;
    wire signed [9:0] state1_butter_l_re;
    wire signed [9:0] state1_butter_l_im;

    wire signed [8:0] rom16_re;
    wire signed [8:0] rom16_im;

    wire signed [18:0] state1_mul_l_re;
    wire signed [18:0] state1_mul_l_im;


    commutator_state1#(9) state1_com (state_com_mode, 
                            state_code,
                            state1_inLI_re, 
                            state1_inLI_im, 
                            state1_comUp_re, 
                            state1_comUp_im, 
                            state1_comL_re, 
                            state1_comL_im
    );

    shift#(16, 9) state1_shift_1(clk, 
                                rst_n, 
                                state1_comUp_re, 
                                state1_comUp_im, 
                                state1_shift_re, 
                                state1_shift_im
    );

    butterfly#(10) state1_butter(butter_mode, 
                                state1_shift_re, 
                                state1_shift_im, 
                                state1_comL_re, 
                                state1_comL_im, 
                                state1_butter_up_re, 
                                state1_butter_up_im, 
                                state1_butter_l_re, 
                                state1_butter_l_im
    );

    ROM16 rom_16(rom_16_counter, 
                rom16_re, 
                rom16_im
    );

    multiply#(10) state1_mul(mul_mode, 
                            state1_butter_l_re, 
                            state1_butter_l_im, 
                            rom16_re, rom16_im, 
                            state1_mul_l_re, 
                            state1_mul_l_im
    );

    assign state1_outUp_re = state1_butter_up_re[8:0];
    assign state1_outUp_im = state1_butter_up_im[8:0];
    assign state1_outL_re = state1_mul_l_re[15:7];
    assign state1_outL_im = state1_mul_l_im[15:7];

endmodule
