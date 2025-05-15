`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 03:41:20 PM
// Design Name: 
// Module Name: fft
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


module fft (
    input clk,
    input rst_n,
    input                   valid_in,
    input wire signed [8:0] FFTInRe,
    input wire signed [8:0] FFTInIm,

    output wire signed [8:0] MDCOutUpRe,
    output wire signed [8:0] MDCOutUpIm,
    output wire signed [8:0] MDCOutDownRe,
    output wire signed [8:0] MDCOutDownIm,
    output wire signed [8:0] FFTOutRe,
    output wire signed [8:0] FFTOutIm
);

//----------------MODE--------------------
wire [4:0] state_com_mode;
wire butter_mode;
wire mul_mode;

//----------------State1------------------
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

//----------------STATE CODE-------------
wire [6:0] state_code;

//---------------------------------------
controller controler_1(
    clk, 
    rst_n, 
    valid_in,
    state_com_mode,
    butter_mode,
    mul_mode,
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
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state1_inLI_re <= 0;
        state1_inLI_im <= 0;
    end else begin
        state1_inLI_re <= FFTInRe;
        state1_inLI_im <= FFTInIm;
    end
end

fft_state1 state1(
    clk,
    rst_n,
    state_com_mode,
    butter_mode,
    mul_mode,
    state_code,
    rom_16_counter,

    state1_inLI_re,
    state1_inLI_im,
    state1_outUp_re,
    state1_outUp_im,
    state1_outL_re,
    state1_outL_im
);

//---------State2-------------
fft_state2#(9) state2(
    clk,
    rst_n,
    state_com_mode,
    butter_mode,
    mul_mode,
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


//------ Pipeline giữa state2 và state3 ------
    reg [8:0] state2_pp_outUp_re, state2_pp_outUp_im;
    reg [8:0] state2_pp_outL_re,  state2_pp_outL_im;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state2_pp_outUp_re <= 0; state2_pp_outUp_im <= 0;
            state2_pp_outL_re  <= 0; state2_pp_outL_im  <= 0;
        end else begin
            state2_pp_outUp_re <= state2_outUp_re;
            state2_pp_outUp_im <= state2_outUp_im;
            state2_pp_outL_re  <= state2_outL_re;
            state2_pp_outL_im  <= state2_outL_im;
        end
    end

// Delay 1 chu kỳ cho state3
    reg [4:0] state_com_mode_d1;
    reg       butter_mode_d1;
    reg       mul_mode_d1;
    reg [6:0] state_code_d1;
    reg [1:0] rom_4_counter_d1;
    reg       rom_2_counter_d1;
    reg       state4_com_flag_d1;
    reg       state5_com_flag_d1;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_com_mode_d1 <= 0;
            butter_mode_d1    <= 0;
            mul_mode_d1       <= 0;
            state_code_d1     <= 0;
            rom_4_counter_d1  <= 0;
            rom_2_counter_d1  <= 0;
            state4_com_flag_d1 <= 0;
            state5_com_flag_d1 <= 0;
        end else begin
            state_com_mode_d1 <= state_com_mode;
            butter_mode_d1    <= butter_mode;
            mul_mode_d1       <= mul_mode;
            state_code_d1     <= state_code;
            rom_4_counter_d1  <= rom_8_counter;
            rom_2_counter_d1  <= rom_4_counter;
            state4_com_flag_d1 <= state4_com_flag;
            state5_com_flag_d1 <= state5_com_flag;
        end
    end

//---------State3-------------
fft_state3#(9) state3(
    clk,
    rst_n,
    state_com_mode_d1,
    butter_mode_d1,
    mul_mode_d1,
    state_code_d1,
    rom_4_counter_d1,
    state2_pp_outUp_re,
    state2_pp_outUp_im,
    state2_pp_outL_re,
    state2_pp_outL_im,
    state3_outUp_re,
    state3_outUp_im,
    state3_outL_re,
    state3_outL_im
);

//------ Pipeline giữa state3 và state4 ------
    reg [8:0] state3_pp_outUp_re, state3_pp_outUp_im;
    reg [8:0] state3_pp_outL_re,  state3_pp_outL_im;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state3_pp_outUp_re <= 0; state3_pp_outUp_im <= 0;
            state3_pp_outL_re  <= 0; state3_pp_outL_im  <= 0;

        end else begin
            state3_pp_outUp_re <= state3_outUp_re;
            state3_pp_outUp_im <= state3_outUp_im;
            state3_pp_outL_re  <= state3_outL_re;
            state3_pp_outL_im  <= state3_outL_im;
        end
    end

    reg [4:0] state_com_mode_d2;
    reg       butter_mode_d2;
    reg       mul_mode_d2;
    reg [6:0] state_code_d2;
    reg       rom_2_counter_d2;
    reg       state4_com_flag_d2;
    reg       state5_com_flag_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_com_mode_d2 <= 0;
            butter_mode_d2    <= 0;
            mul_mode_d2       <= 0;
            state_code_d2     <= 0;
            rom_2_counter_d2  <= 0;
            state4_com_flag_d2 <= 0;
            state5_com_flag_d2 <= 0;
        end else begin
            state_com_mode_d2 <= state_com_mode_d1;
            butter_mode_d2    <= butter_mode_d1;
            mul_mode_d2       <= mul_mode_d1;
            state_code_d2     <= state_code_d1;
            rom_2_counter_d2  <= rom_2_counter_d1;
            state4_com_flag_d2 <= state4_com_flag_d1;
            state5_com_flag_d2 <= state5_com_flag_d1;
        end
    end


//---------State4-------------
fft_state4#(9) state4(
    clk,
    rst_n,
    state_com_mode_d2,
    butter_mode_d2,
    mul_mode_d2,
    state4_com_flag_d2,
    rom_2_counter_d2,
    state3_pp_outUp_re,
    state3_pp_outUp_im,
    state3_pp_outL_re,
    state3_pp_outL_im,
    state4_outUp_re,
    state4_outUp_im,
    state4_outL_re,
    state4_outL_im
);



//--------------State5----------------
fft_state5#(9) state5(
    clk,
    rst_n,
    state_com_mode_d2,
    butter_mode_d2,
    state5_com_flag_d2,
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

//-------------- Ping Pong output --------------

    reg valid_ping_pong_in_d;
    reg valid_ping_pong_in_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_ping_pong_in_d <= 0;
            valid_ping_pong_in_d2 <= 0;
        end
        else begin
            valid_ping_pong_in_d <= valid_ping_pong_in;
            valid_ping_pong_in_d2 <= valid_ping_pong_in_d;
        end
    end

ping_pong pp(
    clk,
    rst_n,
    valid_ping_pong_in_d2,
    state5_outUp_re,
    state5_outUp_im,
    state5_outL_re,
    state5_outL_im,
    FFTOutRe,
    FFTOutIm
);

endmodule

