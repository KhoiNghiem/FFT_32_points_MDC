load('FFTInput32', 'FFTIn32')
x_all = S(randi(4, 96, 1));  % tạo 96 sample QPSK
x = (FFTIn32);
X_mdc = quanti(x);

X_ref = fft(x);
fprintf('Max abs error: %.3e\n', max(abs(X_ref - X_mdc)));

% === Vẽ kết quả ===
subplot(2,1,1); stem(real(X_ref), 'bo'); hold on; stem(real(X_mdc), 'rx'); title('Real');
subplot(2,1,2); stem(imag(X_ref), 'bo'); hold on; stem(imag(X_mdc), 'rx'); title('Imag');