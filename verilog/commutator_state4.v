`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 03:16:07 PM
// Design Name: 
// Module Name: commutator_state4
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


module commutator_state4 #(
    parameter WIDTH = 9
)(
    input  wire [4:0]              state_com_mode,   // 0: switch, 1: bypass
    input  wire                    state4_com_flag,
    input  wire signed [WIDTH-1:0] inUI_re,
    input  wire signed [WIDTH-1:0] inUI_im,
    input  wire signed [WIDTH-1:0] inLI_re,
    input  wire signed [WIDTH-1:0] inLI_im,
    output wire signed [WIDTH-1:0] Up_out_re,
    output wire signed [WIDTH-1:0] Up_out_im,
    output wire signed [WIDTH-1:0] Low_out_re,
    output wire signed [WIDTH-1:0] Low_out_im
);

    wire is_switch_mode = ~state_com_mode[3];

    assign Up_out_re   = is_switch_mode ? (state4_com_flag ? inUI_re : inLI_re) : 0;
    assign Up_out_im   = is_switch_mode ? (state4_com_flag ? inUI_im : inLI_im) : 0;
    assign Low_out_re  = is_switch_mode ? (state4_com_flag ? inLI_re : inUI_re) : 0;
    assign Low_out_im  = is_switch_mode ? (state4_com_flag ? inLI_im : inUI_im) : 0;

endmodule

