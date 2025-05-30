`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 03:41:20 PM
// Design Name: 
// Module Name: fft_state2
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


module fft_state2 #(
    parameter WIDTH = 9
) (
    input clk,
    input rst_n,
    input [4:0] state_com_mode,
    input       butter_mode,
    input       mul_mode,
    input [6:0] state_code,
    input [2:0] rom_8_counter,
    input signed [WIDTH-1:0] state1_outUp_re,
    input signed [WIDTH-1:0] state1_outUp_im,
    input signed [WIDTH-1:0] state1_outL_re,
    input signed [WIDTH-1:0] state1_outL_im,
    
    output signed [WIDTH-1:0] state2_outUp_re,
    output signed [WIDTH-1:0] state2_outUp_im,
    output signed [WIDTH-1:0] state2_outL_re,
    output signed [WIDTH-1:0] state2_outL_im
);

    wire signed [8:0] state2_shift1_re;
    wire signed [8:0] state2_shift1_im;

    wire signed [8:0] state2_comUp_re;
    wire signed [8:0] state2_comUp_im;
    wire signed [8:0] state2_comL_re;
    wire signed [8:0] state2_comL_im;

    wire signed [8:0] state2_shift2_re;
    wire signed [8:0] state2_shift2_im;

    wire signed [9:0] state2_butter_up_re;
    wire signed [9:0] state2_butter_up_im;
    wire signed [9:0] state2_butter_l_re;
    wire signed [9:0] state2_butter_l_im;

    wire signed [8:0] rom8_re;
    wire signed [8:0] rom8_im;

    wire signed [18:0] state2_mul_l_re;
    wire signed [18:0] state2_mul_l_im;

    shift#(8, 9) state2_shift_1(clk, 
                                rst_n, 
                                state1_outL_re,
                                state1_outL_im, 
                                state2_shift1_re, 
                                state2_shift1_im
    );

    commutator_state2#(9) state2_com(state_com_mode, 
                            state_code,
                            state1_outUp_re, 
                            state1_outUp_im, 
                            state2_shift1_re, 
                            state2_shift1_im, 
                            state2_comUp_re, 
                            state2_comUp_im, 
                            state2_comL_re, 
                            state2_comL_im
    );

    shift#(8, 9) state2_shift_2(clk, 
                                rst_n, 
                                state2_comUp_re, 
                                state2_comUp_im, 
                                state2_shift2_re, 
                                state2_shift2_im
    );

    butterfly#(10) state2_butter(butter_mode, 
                                state2_shift2_re, 
                                state2_shift2_im, 
                                state2_comL_re, 
                                state2_comL_im, 
                                state2_butter_up_re, 
                                state2_butter_up_im, 
                                state2_butter_l_re, 
                                state2_butter_l_im
    );
    
    ROM8 rom_8(rom_8_counter, 
            rom8_re, 
            rom8_im);

    multiply#(10) state2_mul(mul_mode, 
                            state2_butter_l_re, 
                            state2_butter_l_im, 
                            rom8_re, rom8_im, 
                            state2_mul_l_re, 
                            state2_mul_l_im
    );

    assign state2_outUp_re = state2_butter_up_re[8:0];
    assign state2_outUp_im = state2_butter_up_im[8:0];
    assign state2_outL_re = state2_mul_l_re[15:7];
    assign state2_outL_im = state2_mul_l_im[15:7];

endmodule
