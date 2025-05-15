`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 03:06:19 PM
// Design Name: 
// Module Name: ping_pong
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


module ping_pong (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_ping_pong_in,
    input  wire [8:0] state5_outUp_re,
    input  wire [8:0] state5_outUp_im,
    input  wire [8:0] state5_outL_re,
    input  wire [8:0] state5_outL_im,
    output reg  [8:0] memOut_re,
    output reg  [8:0] memOut_im
);

    // === Memory Banks ===
    reg [8:0] bankA_re [0:31];
    reg [8:0] bankA_im [0:31];
    reg [8:0] bankB_re [0:31];
    reg [8:0] bankB_im [0:31];

    // === Control Registers ===
    reg [5:0] wr_count;
    reg [4:0] rd_count;
    reg       write_en;
    reg       write_sel;  // 0: write to A, 1: write to B
    reg       read_en;
    reg       read_sel;   // 0: read from A, 1: read from B

    wire [4:0] rd_addr = {rd_count[0], rd_count[1], rd_count[2], rd_count[3], rd_count[4]};

    // === Control and Write Logic ===
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_count   <= 0;
            rd_count   <= 0;
            write_en   <= 0;
            write_sel  <= 0;
            read_en    <= 0;
            read_sel   <= 0;
        end else begin
            if (valid_ping_pong_in)
                write_en <= 1;

            if (write_en) begin
                if (wr_count == 6'd30) begin
                    wr_count   <= 0;
                    write_en   <= 0;
                    write_sel  <= ~write_sel;
                    read_en    <= 1;
                    rd_count   <= 0;
                end else begin
                    wr_count <= wr_count + 2;
                end

                if (!write_sel) begin
                    bankA_re[wr_count]     <= state5_outUp_re;
                    bankA_im[wr_count]     <= state5_outUp_im;
                    bankA_re[wr_count + 1] <= state5_outL_re;
                    bankA_im[wr_count + 1] <= state5_outL_im;
                end else begin
                    bankB_re[wr_count]     <= state5_outUp_re;
                    bankB_im[wr_count]     <= state5_outUp_im;
                    bankB_re[wr_count + 1] <= state5_outL_re;
                    bankB_im[wr_count + 1] <= state5_outL_im;
                end
            end

            if (read_en) begin
                if (rd_count == 5'd31) begin
                    read_sel <= ~read_sel;
                end else begin
                    rd_count <= rd_count + 1;
                end
            end
        end
    end

    always @(read_en, read_sel, rd_addr, bankA_re, bankA_im, bankB_re, bankB_im) begin
        if (read_en) begin
            if (!read_sel) begin
                memOut_re = bankA_re[rd_addr];
                memOut_im = bankA_im[rd_addr];
            end else begin
                memOut_re = bankB_re[rd_addr];
                memOut_im = bankB_im[rd_addr];
            end
        end else begin
            memOut_re = 9'd0;
            memOut_im = 9'd0;
        end
    end
endmodule
