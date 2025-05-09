module shift_tb ();
    reg clk;
    reg rst_n;
    reg [12:0] di_re;
    reg [12:0] di_im;
    wire [12:0] do_re;
    wire [12:0] do_im;

    shift_16 uut(di_re, di_im, do_re, do_im);

    

    initial begin
        #10;
        di_re = 4'd5;
        di_im = -4'd3;
        #10;
        di_re = 4'd2;
        di_im = -4'd1;
        #10;
        di_re = 4'd6;
        di_im = -4'd3;
        #10;
        di_re = -4'd2;
        di_im = -4'd1;
        #10;
        di_re = 4'd0;
        di_im = -4'd3;
        #10;
        di_re = 4'd2;
        di_im = -4'd6;
        #10;
        di_re = 4'd5;
        di_im = -4'd5;
        #10;
        di_re = 4'd1;
        di_im = -4'd1;
        #10;
        di_re = 4'd0;
        di_im = -4'd1;
        #10;
        di_re = 4'd5;
        di_im = -4'd3;
    end

endmodule