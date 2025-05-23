`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 03:12:24 PM
// Design Name: 
// Module Name: commutator_state3
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


module commutator_state3 #(
    parameter WIDTH = 9
)(
    input  wire [4:0]              state_com_mode,  // 0: switch, 1: bypass
    input  wire [6:0]              com_mask,        // bitmask of states
    input  wire signed [WIDTH-1:0] inUI_re,
    input  wire signed [WIDTH-1:0] inUI_im,
    input  wire signed [WIDTH-1:0] inLI_re,
    input  wire signed [WIDTH-1:0] inLI_im,
    output wire signed [WIDTH-1:0] Up_out_re,
    output wire signed [WIDTH-1:0] Up_out_im,
    output wire signed [WIDTH-1:0] Low_out_re,
    output wire signed [WIDTH-1:0] Low_out_im
);

    wire is_switch_mode = ~state_com_mode[2];

    assign Up_out_re = is_switch_mode ?
                        (com_mask[4] ? inUI_re :
                         com_mask[5] ? inLI_re :
                         0) : 0;

    assign Up_out_im = is_switch_mode ?
                        (com_mask[4] ? inUI_im :
                         com_mask[5] ? inLI_im :
                         0) : 0;

    assign Low_out_re = is_switch_mode ?
                        (com_mask[4] ? inLI_re :
                         com_mask[5] ? inUI_re :
                         com_mask[6] ? inLI_re :
                         0) : 0;

    assign Low_out_im = is_switch_mode ?
                        (com_mask[4] ? inLI_im :
                         com_mask[5] ? inUI_im :
                         com_mask[6] ? inLI_im :
                         0) : 0;

endmodule



