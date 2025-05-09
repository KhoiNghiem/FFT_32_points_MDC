function X_mdc = mdc_fft_stage4_quantized(x, N_frac)
    W32 = exp(-1j * 2 * pi/32 * (0:15)).';  % Twiddle factors

    %% === Stage 1 ===
    x1 = x(1:16);
    x2 = x(17:32);
    a1 = x1 + x2;
    b1 = (x1 - x2) .* W32;
    % Lượng tử hóa tại stage 1
    a1 = quantize_fixed(a1, 7);
    b1 = quantize_fixed(b1, 7);
    stage1_out = [a1; b1];

    %% === Stage 2 ===
    a2 = stage1_out([1:8 17:24]) + stage1_out([9:16 25:32]);
    b2 = (stage1_out([1:8 17:24]) - stage1_out([9:16 25:32])) .* W32([1 3 5 7 9 11 13 15 1 3 5 7 9 11 13 15]);
    stage2_out = zeros(32,1);
    a2 = quantize_fixed(a2, 7);
    b2 = quantize_fixed(b2, 7);
    stage2_out([1:8 17:24]) = a2;
    stage2_out([9:16 25:32]) = b2;

    %% === Stage 3 ===
    a3 = stage2_out([1:4 9:12 17:20 25:28]) + stage2_out([5:8 13:16 21:24 29:32]);
    b3 = (stage2_out([1:4 9:12 17:20 25:28]) - stage2_out([5:8 13:16 21:24 29:32])) .* ...
         W32(repmat([1 5 9 13],1,4));
    stage3_out = zeros(32,1);
    a3 = quantize_fixed(a3, 7);
    b3 = quantize_fixed(b3, 7);
    stage3_out([1:4 9:12 17:20 25:28]) = a3;
    stage3_out([5:8 13:16 21:24 29:32]) = b3;

    %% === Stage 4 ===
    a4_idx1 = [1 2 5 6 9 10 13 14 17 18 21 22 25 26 29 30];
    a4_idx2 = [3 4 7 8 11 12 15 16 19 20 23 24 27 28 31 32];
    a4 = stage3_out(a4_idx1) + stage3_out(a4_idx2);
    b4 = (stage3_out(a4_idx1) - stage3_out(a4_idx2)) .* W32(repmat([1 9],1,8));
    stage4_out = zeros(32,1);
    a4 = quantize_fixed(a4, N_frac);
    b4 = quantize_fixed(b4, N_frac);
    stage4_out(a4_idx1) = a4;
    stage4_out(a4_idx2) = b4;

    %% === Stage 5 ===
    a5 = stage4_out(1:2:31) + stage4_out(2:2:32);
    b5 = stage4_out(1:2:31) - stage4_out(2:2:32);
    stage5_out = zeros(32,1);
    stage5_out(1:2:31) = a5;
    stage5_out(2:2:32) = b5;

    %% === Bit-reversal ===
    bit_rev_idx = bitrevorder(0:31) + 1;
    X_mdc = stage5_out(bit_rev_idx);
end
