clc; clear;

%% Bước 1: Load tín hiệu vào
load('FFTInput32.mat');  % cần chứa biến FFTIn32
N = 32;

if length(FFTIn32) ~= N
    error('Biến FFTIn32 phải có độ dài đúng bằng 32');
end

x = FFTIn32(:).';

% FFT tham chiếu chuẩn
X_ref = fft(x);
bitrev_idx = bitrevorder(1:N);
X_ref = X_ref(bitrev_idx);

% Hàm lượng tử hóa
quantize = @(x, Nf) floor(real(x) * 2^Nf) / 2^Nf + 1i * floor(imag(x) * 2^Nf) / 2^Nf;

% Đặt N = 7 cho tất cả các stage
Nq = 7;

% === STAGE 1 ===
xu1 = quantize(x(1:16), Nq);
xl1 = quantize(x(17:32), Nq);
s1_up = quantize(xu1 + xl1, Nq);
s1_down = quantize(xu1 - xl1, Nq);
W1 = exp(-1j * 2 * pi * (0:15) / 32);
s1_down = quantize(s1_down .* W1, Nq);
out1 = quantize([s1_up, s1_down], Nq);

% === STAGE 2 ===
xu2 = quantize([out1(1:8), out1(17:24)], Nq);
xl2 = quantize([out1(9:16), out1(25:32)], Nq);
s2_up = quantize(xu2 + xl2, Nq);
s2_down = quantize(xu2 - xl2, Nq);
W2 = exp(-1j * 2 * pi * (0:7) / 16); W2 = repmat(W2, 1, 2);
s2_down = quantize(s2_down .* W2, Nq);
out2 = quantize([s2_up, s2_down], Nq);

% === STAGE 3 ===
xu3 = quantize([out2(1:4), out2(9:12), out2(17:20), out2(25:28)], Nq);
xl3 = quantize([out2(5:8), out2(13:16), out2(21:24), out2(29:32)], Nq);
s3_up = quantize(xu3 + xl3, Nq);
s3_down = quantize(xu3 - xl3, Nq);
W3 = exp(-1j * 2 * pi * (0:3) / 8); W3 = repmat(W3, 1, 4);
s3_down = quantize(s3_down .* W3, Nq);
out3 = quantize([s3_up, s3_down], Nq);

% === STAGE 4 ===
xu4 = quantize(out3([1:2,5:6,9:10,13:14,17:18,21:22,25:26,29:30]), Nq);
xl4 = quantize(out3([3:4,7:8,11:12,15:16,19:20,23:24,27:28,31:32]), Nq);
s4_up = quantize(xu4 + xl4, Nq);
s4_down = quantize(xu4 - xl4, Nq);
W4 = exp(-1j * 2 * pi * (0:1) / 4); W4 = repmat(W4, 1, 8);
s4_down = quantize(s4_down .* W4, Nq);
out4 = quantize([s4_up, s4_down], Nq);

% === STAGE 5 ===
xu5 = quantize(out4(1:2:end), Nq);
xl5 = quantize(out4(2:2:end), Nq);
s5_up = quantize(xu5 + xl5, Nq);
s5_down = quantize(xu5 - xl5, Nq);
% W5 = 1, không cần nhân
out5 = quantize([s5_up, s5_down], Nq);

% === Bit-reversal ===
X_mdc = out5(bitrev_idx);

% === Tính SQNR ===
signal_power = sum(abs(X_ref).^2);
noise_power = sum(abs(X_ref - X_mdc).^2);
SQNR_dB = 10 * log10(signal_power / noise_power);

fprintf('✅ SQNR toàn bộ FFT lượng tử hóa với N = 7: %.2f dB\n', SQNR_dB);
