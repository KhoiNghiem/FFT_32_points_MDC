S = [1+1j, 1-1j, -1+1j, -1-1j];
rng(0);  % đảm bảo tái hiện được kết quả
load('FFTInput32', 'FFTIn32')
x1 = (FFTIn32.');
x2 = ifft(x_all(33:64));
x3 = ifft(x_all(65:96));

Ns = 7:15;
%SQNR = zeros(length(Ns),3);
SQNR = zeros(3);     % cho full
for s = 1:3
    eval(sprintf('x = x%d;', s));
    X_ref = fft(x.');
    %for i = 1:length(Ns)
        %X_mdc = mdc_fft_twiddle_quantized(x.', Ns(i));
        X_mdc = quanti(x.');
        error = X_ref - X_mdc;
        signal_power = mean(abs(X_ref).^2);
        noise_power = mean(abs(error).^2);
        %SQNR(i,s) = 10*log10(signal_power / noise_power);
        SQNR(s) = 10*log10(signal_power / noise_power);
    %end
end

% === Vẽ kết quả ===
figure;
plot(Ns, SQNR(1), 'r-o', 'LineWidth', 1.5); hold on;
plot(Ns, SQNR(2), 'g-*', 'LineWidth', 1.5);
plot(Ns, SQNR(3), 'b-s', 'LineWidth', 1.5);
xlabel('Fractional Word-Length N');
ylabel('SQNR (dB)');
title('SQNR vs Fractional Part Word-Length (Quantization at Stage 1)');
legend('Symbol 1', 'Symbol 2', 'Symbol 3');
grid on;
