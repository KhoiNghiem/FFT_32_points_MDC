load('FFTInput32', 'FFTIn32');
x1 = FFTIn32(:);  % Đảm bảo là cột vector phức

%% Cấu hình Q2.7
frac_bits = 7;
scale = 2^frac_bits;
max_val = 255;
min_val = -256;

%% Phần thực
x_real = real(x1);
x_real_fixed = floor(x_real * scale);
x_real_fixed = max(min(x_real_fixed, max_val), min_val);
x_real_bin = dec2bin(mod(x_real_fixed, 512), 9);  % 2's complement

%% Phần ảo
x_imag = imag(x1);
x_imag_fixed = floor(x_imag * scale);
x_imag_fixed = max(min(x_imag_fixed, max_val), min_val);
x_imag_bin = dec2bin(mod(x_imag_fixed, 512), 9);  % 2's complement

%% Ghi ra file
fid_re = fopen('real_part_bin.txt', 'w');
fid_im = fopen('imag_part_bin.txt', 'w');

for i = 1:length(x1)
    fprintf(fid_re, '%s\n', x_real_bin(i,:));
    fprintf(fid_im, '%s\n', x_imag_bin(i,:));
end

fclose(fid_re);
fclose(fid_im);
