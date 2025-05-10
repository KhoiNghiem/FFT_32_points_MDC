module fft_tb ();
    reg clk;
    reg rst_n;
    reg mode;

    reg signed [8:0] FFTInRe;
    reg signed [8:0] FFTInIm;

    wire signed [8:0] MDCOutUpRe;
    wire signed [8:0] MDCOutUpIm;
    wire signed [8:0] MDCOutDownRe;
    wire signed [8:0] MDCOutDownIm;
    wire signed [8:0] FFTOutRe;
    wire signed [8:0] FFTOutIm;


    fft uut(clk, rst_n, FFTInRe, FFTInIm, MDCOutUpRe, MDCOutUpIm, MDCOutDownRe, MDCOutDownIm, FFTOutRe, FFTOutIm);

    reg signed [8:0] FFTInRe_mem [0:95];  // 9-bit signed, từ file
    reg signed [8:0] FFTInIm_mem [0:95];

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end

    integer i;

    initial begin
        // Đọc dữ liệu nhị phân từ file vào bộ nhớ
        $readmemb("real_part_bin_96.txt", FFTInRe_mem);
        $readmemb("imag_part_bin_96.txt", FFTInIm_mem);

        wait(rst_n == 1);
        for (i = 0; i < 96; i = i + 1) begin
            // Cắt 9-bit xuống còn 4-bit signed (Q2.7 -> signed integer)
            FFTInRe = FFTInRe_mem[i];  // bỏ phần thập phân
            FFTInIm = FFTInIm_mem[i];
            @(negedge clk);
        end

        #5000;
        $stop();
    end
endmodule
