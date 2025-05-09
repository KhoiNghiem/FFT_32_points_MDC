module fft_state1 #(
    parameter WIDTH = 9
) (
    input clk,
    input rst_n,
    input flag_in_com1,
    input flag_in_com2,
    input flag_switch_state2_1,
    input [3:0] rom_16_counter,
    input signed [WIDTH-1:0] state1_inUI_re,
    input signed [WIDTH-1:0] state1_inUI_im,
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


    commutator_input#(9) state1_com (1'b1, flag_in_com1, flag_in_com2, flag_switch_state2_1, state1_inUI_re, state1_inUI_im, state1_inLI_re, state1_inLI_im, state1_comUp_re, state1_comUp_im, state1_comL_re, state1_comL_im);

    shift_16#(16, 9) state1_shift_1(clk, rst_n, state1_comUp_re, state1_comUp_im, state1_shift_re, state1_shift_im);

    butterfly#(10) state_1butter(1'b0, state1_shift_re, state1_shift_im, state1_comL_re, state1_comL_im, state1_butter_up_re, state1_butter_up_im, state1_butter_l_re, state1_butter_l_im);

    ROM16 rom_16(rom_16_counter, rom16_re, rom16_im);

    multiply#(10) state1_mul(1'b0, state1_butter_l_re, state1_butter_l_im, rom16_re, rom16_im, state1_mul_l_re, state1_mul_l_im);

    assign state1_outUp_re = state1_butter_up_re[8:0];
    assign state1_outUp_im = state1_butter_up_im[8:0];
    assign state1_outL_re = state1_mul_l_re[16:7];
    assign state1_outL_im = state1_mul_l_im[16:7];



endmodule