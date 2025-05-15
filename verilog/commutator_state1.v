`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 05:39:14 PM
// Design Name: 
// Module Name: commutator_state1
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


module commutator_state1 #(
    parameter WIDTH = 9
)(
    input  wire [4:0]            state_com_mode,     // 0: switch, 1: bypass
    input  wire [6:0]            com_mask, // bitmask of states
    input  wire signed [WIDTH-1:0] inLI_re,
    input  wire signed [WIDTH-1:0] inLI_im,
    output wire  signed [WIDTH-1:0] Up_out_re,
    output wire  signed [WIDTH-1:0] Up_out_im,
    output wire  signed [WIDTH-1:0] Low_out_re,
    output wire  signed [WIDTH-1:0] Low_out_im
);

    assign Up_out_re  = (state_com_mode[0] && !com_mask[0]) ? inLI_re : 0;
    assign Up_out_im  = (state_com_mode[0] && !com_mask[0]) ? inLI_im : 0;
    assign Low_out_re = (state_com_mode[0] &&  com_mask[0]) ? inLI_re : 0;
    assign Low_out_im = (state_com_mode[0] &&  com_mask[0]) ? inLI_im : 0;
    
endmodule

