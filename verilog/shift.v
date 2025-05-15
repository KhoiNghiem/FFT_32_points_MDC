`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 03:41:20 PM
// Design Name: 
// Module Name: shift
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


module shift #(
    parameter   DEPTH = 16,
    parameter   WIDTH = 9
)(
    input               clk,      // Master Clock
    input               rst_n,    // Active-low reset
    input   [WIDTH-1:0] di_re,    // Data Input (Real)
    input   [WIDTH-1:0] di_im,    // Data Input (Imag)
    output  [WIDTH-1:0] do_re,    // Data Output (Real)
    output  [WIDTH-1:0] do_im     // Data Output (Imag)
);

reg [WIDTH-1:0] buf_re[0:DEPTH-1];
reg [WIDTH-1:0] buf_im[0:DEPTH-1];

integer n;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (n = 0; n < DEPTH; n = n + 1) begin
            buf_re[n] <= 0;
            buf_im[n] <= 0;
        end
    end else begin
        for (n = DEPTH-1; n > 0; n = n - 1) begin
            buf_re[n] <= buf_re[n-1];
            buf_im[n] <= buf_im[n-1];
        end
        buf_re[0] <= di_re;
        buf_im[0] <= di_im;
    end
end

assign do_re = buf_re[DEPTH-1];
assign do_im = buf_im[DEPTH-1];

endmodule
