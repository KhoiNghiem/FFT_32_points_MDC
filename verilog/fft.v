module fft (
    input clk,
    input rst_n,
    input wire signed [8:0] FFTInRe,
    input wire signed [8:0] FFTInIm,


    output wire signed [8:0] MDCOutUpRe,
    output wire signed [8:0] MDCOutUpIm,
    output wire signed [8:0] MDCOutDownRe,
    output wire signed [8:0] MDCOutDownIm,
    output wire signed [8:0] FFTOutRe,
    output wire signed [8:0] FFTOutIm
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

//----------------State3------------------
    wire signed [8:0] state3_outUp_re;
    wire signed [8:0] state3_outUp_im;
    wire signed [8:0] state3_outL_re;
    wire signed [8:0] state3_outL_im;

    wire [1:0] rom_4_counter;

//---------------State4------------------
    wire signed [8:0] state4_outUp_re;
    wire signed [8:0] state4_outUp_im;
    wire signed [8:0] state4_outL_re;
    wire signed [8:0] state4_outL_im;

    wire state4_com_flag;
    wire rom_2_counter;

//---------------State5------------------
    wire signed [8:0] state5_outUp_re;
    wire signed [8:0] state5_outUp_im;
    wire signed [8:0] state5_outL_re;
    wire signed [8:0] state5_outL_im;

    wire state5_com_flag;

//---------------PINGPONG----------------
    wire valid_ping_pong_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state1_inUI_re <= 0;
            state1_inUI_im <= 0;
            
            
        end else begin
            state1_inLI_re <= FFTInRe;
            state1_inLI_im <= FFTInIm;
        end
    end

    wire [6:0] state_code;

    controller controler_1(clk, 
                        rst_n, 
                        rom_16_counter, 
                        rom_8_counter, 
                        rom_4_counter,
                        rom_2_counter,
                        state_code,
                        state4_com_flag,
                        state5_com_flag,
                        valid_ping_pong_in
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

    //------------State3---------
    fft_state3#(9) state3(clk, 
                        rst_n, 
                        state_code,
                        rom_4_counter, 
                        state2_outUp_re, 
                        state2_outUp_im, 
                        state2_outL_re, 
                        state2_outL_im, 
                        state3_outUp_re, 
                        state3_outUp_im, 
                        state3_outL_re, 
                        state3_outL_im
    );

    //-------------State4----------

    fft_state4#(9) state4(clk, 
                        rst_n, 
                        state4_com_flag,
                        rom_2_counter, 
                        state3_outUp_re, 
                        state3_outUp_im, 
                        state3_outL_re, 
                        state3_outL_im, 
                        state4_outUp_re, 
                        state4_outUp_im, 
                        state4_outL_re, 
                        state4_outL_im
    );

//--------------State5----------------

    fft_state5#(9) state5(clk, 
                        rst_n, 
                        state5_com_flag,
                        state4_outUp_re, 
                        state4_outUp_im, 
                        state4_outL_re, 
                        state4_outL_im, 
                        state5_outUp_re, 
                        state5_outUp_im, 
                        state5_outL_re, 
                        state5_outL_im
    );

    assign MDCOutUpRe = state5_outUp_re;
    assign MDCOutUpIm = state5_outUp_im;
    assign MDCOutDownRe = state5_outL_re;
    assign MDCOutDownIm = state5_outL_im;

    ping_pong pp(clk, 
                rst_n,
                valid_ping_pong_in,
                state5_outUp_re,
                state5_outUp_im,
                state5_outL_re,
                state5_outL_im,
                FFTOutRe,
                FFTOutIm
    );

endmodule