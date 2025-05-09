module test_tb ();
    reg clk;
    reg rst_n;
    reg valid_in;
    wire [8:0] w_r;
    wire [8:0] w_i;
    wire valid_out_rom16;


    ROM16 uut(clk, rst_n, valid_in, w_r, w_i, valid_out_rom16);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end

    initial begin
        valid_in = 0; // đừng quên khởi tạo

        wait(rst_n == 1);  // Đợi đến khi reset được bỏ
        #240;
        valid_in = 1'b1;
        #10;
        valid_in = 1'b0;
        #270;
        valid_in = 1'b1;
        #10;
        valid_in = 1'b0;
        #700;
        valid_in = 1'b1;
        #10;
        valid_in = 1'b0;
    end





endmodule