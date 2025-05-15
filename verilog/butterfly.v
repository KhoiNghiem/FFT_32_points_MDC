`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 03:41:20 PM
// Design Name: 
// Module Name: butterfly
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


module butterfly #(
    parameter WIDTH = 10
)(
    input  wire                  butter_mode,     // 0: compute, 1: bypass
    input  wire signed [WIDTH-2:0] x0_re,
    input  wire signed [WIDTH-2:0] x0_im,
    input  wire signed [WIDTH-2:0] x1_re,
    input  wire signed [WIDTH-2:0] x1_im,
    output reg  signed [WIDTH-1:0] y0_re,
    output reg  signed [WIDTH-1:0] y0_im,
    output reg  signed [WIDTH-1:0] y1_re,
    output reg  signed [WIDTH-1:0] y1_im
);

always @(x0_re or x0_im or x1_re or x1_im) begin
    if (!butter_mode) begin  // compute mode
        y0_re = x0_re + x1_re;
        y0_im = x0_im + x1_im;
        y1_re = x0_re - x1_re;
        y1_im = x0_im - x1_im;
    end else begin  // bypass mode
        y0_re = x0_re;
        y0_im = x0_im;
        y1_re = x1_re;
        y1_im = x1_im;
    end
end

endmodule


