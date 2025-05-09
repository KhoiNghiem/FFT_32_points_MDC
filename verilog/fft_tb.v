module fft_tb ();
    reg clk;
    reg rst_n;
    reg mode;

    reg signed [8:0] FFTInRe;
    reg signed [8:0] FFTInIm;

    wire [8:0] MDCOutUpRe;
    wire [8:0] MDCOutUpIm;
    wire [8:0] MDCOutDownRe;
    wire [8:0] MDCOutDownIm;

    fft uut(clk, rst_n, FFTInRe, FFTInIm, MDCOutUpRe, MDCOutUpIm, MDCOutDownRe, MDCOutDownIm);

    reg signed [8:0] FFTInRe_mem [0:31];  // 9-bit signed, từ file
    reg signed [8:0] FFTInIm_mem [0:31];

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
        $readmemb("real_part_bin.txt", FFTInRe_mem);
        $readmemb("imag_part_bin.txt", FFTInIm_mem);

        wait(rst_n == 1);
        for (i = 0; i < 32; i = i + 1) begin
            // Cắt 9-bit xuống còn 4-bit signed (Q2.7 -> signed integer)
            FFTInRe = FFTInRe_mem[i];  // bỏ phần thập phân
            FFTInIm = FFTInIm_mem[i];
            @(negedge clk);
        end

        #5000;
        $stop();
    end
endmodule
