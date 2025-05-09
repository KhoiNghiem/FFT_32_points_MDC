x = (1:16).';  % input
W16 = exp(-1j * 2 * pi/16 * (0:7)).';  % Twiddle factors

%% === Stage 1 ===
x1 = x(1:8);        % direct path
x2 = x(9:16);       % delayed path

a1 = x1 + x2;
b1 = (x1 - x2) .* W16;

stage1_out = [a1; b1];

%% === Stage 2 ===
stage2_in = stage1_out;

a2 = stage2_in([1 2 3 4 9 10 11 12]) + stage2_in([5 6 7 8 13 14 15 16]);
b2 = (stage2_in([1 2 3 4 9 10 11 12]) - stage2_in([5 6 7 8 13 14 15 16])) .* W16([1 3 5 7 1 3 5 7]); 

stage2_out = zeros(16,1);
stage2_out([1 2 3 4 9 10 11 12]) = a2;
stage2_out([5 6 7 8 13 14 15 16]) = b2;

%% === Stage 3 ===

stage3_in = stage2_out;

a3 = stage3_in([1 2 5 6 9 10 13 14]) + stage3_in([3 4 7 8 11 12 15 16]);
b3 = (stage3_in([1 2 5 6 9 10 13 14]) - stage3_in([3 4 7 8 11 12 15 16])) .* W16([1 5 1 5 1 5 1 5]);  % W8^0 và W8^2

stage3_out = zeros(16,1);
stage3_out([1 2 5 6 9 10 13 14]) = a3;
stage3_out([3 4 7 8 11 12 15 16]) = b3;

%% === Stage 4 ===
stage4_in = stage3_out;

a4 = stage4_in([1 3 5 7 9 11 13 15]) + stage4_in([2 4 6 8 10 12 14 16]);
b4 = stage4_in([1 3 5 7 9 11 13 15]) - stage4_in([2 4 6 8 10 12 14 16]);

stage4_out = zeros(16,1);
stage4_out([1 3 5 7 9 11 13 15]) = a4;
stage4_out([2 4 6 8 10 12 14 16]) = b4;

%% === Bit-reversal ===
bit_rev_idx = bitrevorder(0:15) + 1;
X_mdc = stage4_out(bit_rev_idx);

%% === So sánh ===
X_ref = fft(x);
fprintf('Max abs error: %.3e\n', max(abs(X_ref - X_mdc)));

% === Vẽ kết quả ===
subplot(2,1,1); stem(real(X_ref), 'bo'); hold on; stem(real(X_mdc), 'rx'); title('Real');
subplot(2,1,2); stem(imag(X_ref), 'bo'); hold on; stem(imag(X_mdc), 'rx'); title('Imag');
