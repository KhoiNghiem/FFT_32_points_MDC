x = [1 1 1 2 3 1 2 0].';  % 8 điểm
W8 = exp(-1j * 2*pi/8 * (0:3)).';

% === Stage 1 ===
x1 = x(1:4);           % direct path
x2 = x(5:8);           % delayed path

a1 = x1 + x2;          % sum
b1 = (x1 - x2) .* W8;  % difference with twiddle

stage1_out = [a1; b1]; % output 8 điểm

% === Stage 2 === (2-point butterfly trên từng cặp)
stage2_in = stage1_out;

a2 = stage2_in([1 2 5 6]) + stage2_in([3 4 7 8]);
b2 = (stage2_in([1 2 5 6]) - stage2_in([3 4 7 8])) .* W8([1 3 1 3]);  % W8^0 và W8^2

stage2_out = zeros(8,1);
stage2_out([1 2 5 6]) = a2;
stage2_out([3 4 7 8]) = b2;

% === Stage 3 ===
stage3_in = stage2_out;

a3 = stage3_in([1 3 5 7]) + stage3_in([2 4 6 8]);
b3 = (stage3_in([1 3 5 7]) - stage3_in([2 4 6 8]));  % W8^0 → W8^3

stage3_out = zeros(8,1);
stage3_out([1 3 5 7]) = a3;
stage3_out([2 4 6 8]) = b3;

% === Bit-reversal ===
N = 8;
bit_rev_idx = bitrevorder(0:N-1) + 1;  % MATLAB dùng index từ 1

X_mdc = stage3_out(bit_rev_idx);

% === So sánh ===
X_ref = fft(x);
fprintf('Max abs error: %.3e\n', max(abs(X_ref - X_mdc)));

% === Vẽ kết quả ===
subplot(2,1,1); stem(real(X_ref), 'bo'); hold on; stem(real(X_mdc), 'rx'); title('Real');
subplot(2,1,2); stem(imag(X_ref), 'bo'); hold on; stem(imag(X_mdc), 'rx'); title('Imag');
