`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 03:04:46 PM
// Design Name: 
// Module Name: fft_state4
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


module fft_state4 #(
    parameter WIDTH = 9
) (
    input clk,
    input rst_n,
    input [4:0] state_com_mode,
    input butter_mode,
    input mul_mode,
    input state4_com_flag,
    input rom_2_counter,
    input signed [WIDTH-1:0] state3_outUp_re,
    input signed [WIDTH-1:0] state3_outUp_im,
    input signed [WIDTH-1:0] state3_outL_re,
    input signed [WIDTH-1:0] state3_outL_im,
    
    output signed [WIDTH-1:0] state4_outUp_re,
    output signed [WIDTH-1:0] state4_outUp_im,
    output signed [WIDTH-1:0] state4_outL_re,
    output signed [WIDTH-1:0] state4_outL_im
);

    wire signed [8:0] state4_shift1_re;
    wire signed [8:0] state4_shift1_im;

    wire signed [8:0] state4_comUp_re;
    wire signed [8:0] state4_comUp_im;
    wire signed [8:0] state4_comL_re;
    wire signed [8:0] state4_comL_im;

    wire signed [8:0] state4_shift2_re;
    wire signed [8:0] state4_shift2_im;

    wire signed [9:0] state4_butter_up_re;
    wire signed [9:0] state4_butter_up_im;
    wire signed [9:0] state4_butter_l_re;
    wire signed [9:0] state4_butter_l_im;

    wire signed [8:0] rom2_re;
    wire signed [8:0] rom2_im;

    wire signed [18:0] state4_mul_l_re;
    wire signed [18:0] state4_mul_l_im;

    shift#(2, 9) state4_shift_1(clk, 
                                rst_n, 
                                state3_outL_re, 
                                state3_outL_im, 
                                state4_shift1_re, 
                                state4_shift1_im
    );

    commutator_state4#(9) state4_com(state_com_mode,
                            state4_com_flag,
                            state3_outUp_re,
                            state3_outUp_im,
                            state4_shift1_re,
                            state4_shift1_im,
                            state4_comUp_re,
                            state4_comUp_im,
                            state4_comL_re,
                            state4_comL_im
    );

    shift#(2, 9) state4_shift_2(clk, 
                                rst_n, 
                                state4_comUp_re, 
                                state4_comUp_im, 
                                state4_shift2_re, 
                                state4_shift2_im
    );

    butterfly#(10) state4_butter(butter_mode, 
                                state4_shift2_re, 
                                state4_shift2_im, 
                                state4_comL_re, 
                                state4_comL_im, 
                                state4_butter_up_re, 
                                state4_butter_up_im, 
                                state4_butter_l_re, 
                                state4_butter_l_im
    );
    
    ROM2 rom_2(rom_2_counter, 
            rom2_re, 
            rom2_im);

    multiply#(10) state4_mul(mul_mode, 
                            state4_butter_l_re, 
                            state4_butter_l_im, 
                            rom2_re, rom2_im, 
                            state4_mul_l_re, 
                            state4_mul_l_im
    );

    assign state4_outUp_re = state4_butter_up_re[8:0];
    assign state4_outUp_im = state4_butter_up_im[8:0];
    assign state4_outL_re = state4_mul_l_re[15:7];
    assign state4_outL_im = state4_mul_l_im[15:7];

endmodule
