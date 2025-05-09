module fft (
    input clk,
    input rst_n,
    input wire signed [8:0] FFTInRe,
    input wire signed [8:0] FFTInIm,


    output wire signed [8:0] MDCOutUpRe,
    output wire signed [8:0] MDCOutUpIm,
    output wire signed [8:0] MDCOutDownRe,
    output wire signed [8:0] MDCOutDownIm

);
//----------------State1------------------
    reg signed [8:0] state1_inUI_re;
    reg signed [8:0] state1_inUI_im;
    reg signed [8:0] state1_inLI_re;
    reg signed [8:0] state1_inLI_im;

    wire signed [8:0] state1_outUp_re;
    wire signed [8:0] state1_outUp_im;
    wire signed [8:0] state1_outL_re;
    wire signed [8:0] state1_outL_im;

    wire signed [3:0] rom_16_counter;

//----------------State2------------------
    wire signed [8:0] state2_outUp_re;
    wire signed [8:0] state2_outUp_im;
    wire signed [8:0] state2_outL_re;
    wire signed [8:0] state2_outL_im;

    wire signed [2:0] rom_8_counter;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state1_inUI_re <= 0;
            state1_inUI_im <= 0;
            
            
        end else begin
            state1_inLI_re <= FFTInRe;
            state1_inLI_im <= FFTInIm;
        end
    end


    wire state1_com1_flag;
    wire state2_com1_flag;
    wire state2_com2_flag;
    wire state3_com1_flag;
    wire state3_com2_flag;
    wire state3_com3_flag;

    wire [5:0] state_code;

    controller controler_1(clk, 
                        rst_n, 
                        rom_16_counter, 
                        rom_8_counter, 
                        state_code
    );
    
    //---------State1-------------

    fft_state1 state1(clk, 
                    rst_n, 
                    state_code,
                    rom_16_counter, 
                    state1_inUI_re, 
                    state1_inUI_im, 
                    state1_inLI_re, 
                    state1_inLI_im, 
                    state1_outUp_re, 
                    state1_outUp_im, 
                    state1_outL_re, 
                    state1_outL_im
    );

    //---------State2-------------


    fft_state2#(9) state2(clk, 
                        rst_n, 
                        state_code,
                        rom_8_counter, 
                        state1_outUp_re, 
                        state1_outUp_im, 
                        state1_outL_re, 
                        state1_outL_im, 
                        state2_outUp_re, 
                        state2_outUp_im, 
                        state2_outL_re, 
                        state2_outL_im
);

    wire signed [8:0] state3_shift1_re;
    wire signed [8:0] state3_shift1_im;

    wire signed [8:0] state3_comUp_re;
    wire signed [8:0] state3_comUp_im;
    wire signed [8:0] state3_comL_re;
    wire signed [8:0] state3_comL_im;

    shift#(4, 9) state3_shift_1(clk, 
                                rst_n, 
                                state2_outL_re, 
                                state2_outL_im, 
                                state3_shift1_re, 
                                state3_shift1_im
    );

    // commutator#(9) state3_com(1'b0,
    //                         state_code,
    //                         state2_outUp_re,
    //                         state2_outUp_im,
    //                         state3_shift1_re,
    //                         state3_shift1_im,
    //                         state3_comUp_re,
    //                         state3_comUp_im,
    //                         state3_comL_re,
    //                         state3_comL_im
    // );

    // assign MDCOutUpRe = state3_comUp_re;
    // assign MDCOutUpIm = state3_comUp_im;
    // assign MDCOutDownRe = state3_comL_re;
    // assign MDCOutDownIm = state3_comL_im;


endmodule