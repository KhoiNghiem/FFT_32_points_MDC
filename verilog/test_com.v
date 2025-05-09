module test_com ();
    reg clk;
    reg rst_n;
    reg mode;
    reg [12:0] in0_re;
    reg [12:0] in0_im;
    wire [12:0] Up_out_re;
    wire [12:0] Up_out_im;
    wire [12:0] Low_out_re;
    wire [12:0] Low_out_im;


    commutator_input uut(clk, rst_n, mode, in0_re, in0_im, Up_out_re, Up_out_im, Low_out_re, Low_out_im);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end

    initial begin
        wait(rst_n == 1);
        @(negedge clk);
        in0_re = 4'd5;
        in0_im = -4'd3;
        @(negedge clk);
        in0_re = 4'd2;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd6;
        in0_im = -4'd3;
        @(negedge clk);
        in0_re = -4'd2;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd0;
        in0_im = -4'd3;
        @(negedge clk);
        in0_re = 4'd2;
        in0_im = -4'd6;
        @(negedge clk);
        in0_re = 4'd5;
        in0_im = -4'd5;
        @(negedge clk);
        in0_re = 4'd1;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd0;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd3;
        in0_im = -4'd2;
        @(negedge clk);
        in0_re = 4'd0;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd2;
        in0_im = -4'd3;
        @(negedge clk);
        in0_re = 4'd4;
        in0_im = -4'd5;
        @(negedge clk);
        in0_re = 4'd0;
        in0_im = 4'd1;
        @(negedge clk);
        in0_re = 4'd1;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd2;
        in0_im = -4'd2;
        @(negedge clk);
        in0_re = 4'd3;
        in0_im = -4'd3;
        @(negedge clk);
        in0_re = 4'd1;
        in0_im = 4'd0;
        @(negedge clk);
        in0_re = 4'd5;
        in0_im = -4'd3;
        @(negedge clk);
        in0_re = 4'd1;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd5;
        in0_im = -4'd1;
        @(negedge clk);
        in0_re = 4'd1;
        in0_im = -4'd3;
        @(negedge clk);
        in0_re = 4'd5;
        in0_im = -4'd3;
    end

endmodule