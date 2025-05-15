`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 03:04:46 PM
// Design Name: 
// Module Name: fft_state5
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


module fft_state5 #(
    parameter WIDTH = 9
) (
    input clk,
    input rst_n,
    input [4:0] state_com_mode,
    input butter_mode,
    input state5_com_flag,
    input signed [WIDTH-1:0] state4_outUp_re,
    input signed [WIDTH-1:0] state4_outUp_im,
    input signed [WIDTH-1:0] state4_outL_re,
    input signed [WIDTH-1:0] state4_outL_im,
    
    output signed [WIDTH-1:0] state5_outUp_re,
    output signed [WIDTH-1:0] state5_outUp_im,
    output signed [WIDTH-1:0] state5_outL_re,
    output signed [WIDTH-1:0] state5_outL_im
);

    wire signed [8:0] state5_shift1_re;
    wire signed [8:0] state5_shift1_im;

    wire signed [8:0] state5_comUp_re;
    wire signed [8:0] state5_comUp_im;
    wire signed [8:0] state5_comL_re;
    wire signed [8:0] state5_comL_im;

    wire signed [8:0] state5_shift2_re;
    wire signed [8:0] state5_shift2_im;

    wire signed [9:0] state5_butter_up_re;
    wire signed [9:0] state5_butter_up_im;
    wire signed [9:0] state5_butter_l_re;
    wire signed [9:0] state5_butter_l_im;

    shift#(1, 9) state5_shift_1(clk, 
                                rst_n, 
                                state4_outL_re, 
                                state4_outL_im, 
                                state5_shift1_re, 
                                state5_shift1_im
    );

    commutator_state5#(9) state5_com(state_com_mode,
                            state5_com_flag,
                            state4_outUp_re,
                            state4_outUp_im,
                            state5_shift1_re,
                            state5_shift1_im,
                            state5_comUp_re,
                            state5_comUp_im,
                            state5_comL_re,
                            state5_comL_im
    );

    shift#(1, 9) state5_shift_2(clk, 
                                rst_n, 
                                state5_comUp_re, 
                                state5_comUp_im, 
                                state5_shift2_re, 
                                state5_shift2_im
    );

    butterfly#(10) state4_butter(butter_mode, 
                                state5_shift2_re, 
                                state5_shift2_im, 
                                state5_comL_re, 
                                state5_comL_im, 
                                state5_butter_up_re, 
                                state5_butter_up_im, 
                                state5_butter_l_re, 
                                state5_butter_l_im
    );

    assign state5_outUp_re = state5_butter_up_re[8:0];
    assign state5_outUp_im = state5_butter_up_im[8:0];
    assign state5_outL_re = state5_butter_l_re[8:0];
    assign state5_outL_im = state5_butter_l_im[8:0];

endmodule
