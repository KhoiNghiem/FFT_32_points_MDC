module fft_state3 #(
    parameter WIDTH = 9
) (
    input clk,
    input rst_n,
    input [6:0] state_code,
    input [1:0] rom_4_counter,
    input signed [WIDTH-1:0] state2_outUp_re,
    input signed [WIDTH-1:0] state2_outUp_im,
    input signed [WIDTH-1:0] state2_outL_re,
    input signed [WIDTH-1:0] state2_outL_im,
    
    output signed [WIDTH-1:0] state3_outUp_re,
    output signed [WIDTH-1:0] state3_outUp_im,
    output signed [WIDTH-1:0] state3_outL_re,
    output signed [WIDTH-1:0] state3_outL_im
);

    wire signed [8:0] state3_shift1_re;
    wire signed [8:0] state3_shift1_im;

    wire signed [8:0] state3_comUp_re;
    wire signed [8:0] state3_comUp_im;
    wire signed [8:0] state3_comL_re;
    wire signed [8:0] state3_comL_im;

    wire signed [8:0] state3_shift2_re;
    wire signed [8:0] state3_shift2_im;

    wire signed [9:0] state3_butter_up_re;
    wire signed [9:0] state3_butter_up_im;
    wire signed [9:0] state3_butter_l_re;
    wire signed [9:0] state3_butter_l_im;

    wire signed [8:0] rom4_re;
    wire signed [8:0] rom4_im;

    wire signed [18:0] state3_mul_l_re;
    wire signed [18:0] state3_mul_l_im;

    shift#(4, 9) state3_shift_1(clk, 
                                rst_n, 
                                state2_outL_re, 
                                state2_outL_im, 
                                state3_shift1_re, 
                                state3_shift1_im
    );

    commutator_state3#(9) state3_com(1'b0,
                            state_code,
                            state2_outUp_re,
                            state2_outUp_im,
                            state3_shift1_re,
                            state3_shift1_im,
                            state3_comUp_re,
                            state3_comUp_im,
                            state3_comL_re,
                            state3_comL_im
    );

    shift#(4, 9) state3_shift_2(clk, 
                                rst_n, 
                                state3_comUp_re, 
                                state3_comUp_im, 
                                state3_shift2_re, 
                                state3_shift2_im
    );

    butterfly#(10) state3_butter(1'b0, 
                                state3_shift2_re, 
                                state3_shift2_im, 
                                state3_comL_re, 
                                state3_comL_im, 
                                state3_butter_up_re, 
                                state3_butter_up_im, 
                                state3_butter_l_re, 
                                state3_butter_l_im
    );
    
    ROM4 rom_4(rom_4_counter, 
            rom4_re, 
            rom4_im);

    multiply#(10) state3_mul(1'b0, 
                            state3_butter_l_re, 
                            state3_butter_l_im, 
                            rom4_re, rom4_im, 
                            state3_mul_l_re, 
                            state3_mul_l_im
    );

    assign state3_outUp_re = state3_butter_up_re[8:0];
    assign state3_outUp_im = state3_butter_up_im[8:0];
    assign state3_outL_re = state3_mul_l_re[15:7];
    assign state3_outL_im = state3_mul_l_im[15:7];

endmodule