module fft_state5 #(
    parameter WIDTH = 9
) (
    input clk,
    input rst_n,
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

    commutator_state5#(9) state5_com(1'b0,
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

    butterfly#(10) state4_butter(1'b0, 
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