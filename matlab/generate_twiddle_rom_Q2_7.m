function [cos_bin_table, sin_bin_table] = generate_twiddle_rom_Q2_7()
    N = 32;
    frac_bits = 7;  % Q2.7: 2 bit nguyên, 7 bit phần thập phân (signed)
    scale = 2^frac_bits;

    theta = -2 * pi * (0:15)' / N;
    cos_vals = cos(theta);
    sin_vals = sin(theta);

    % Lượng tử hóa Q2.7 (signed 9-bit)
    cos_q = floor(cos_vals * scale);
    sin_q = floor(sin_vals * scale);

    % Cắt ngưỡng ±2 → [-256, +255] (do 9-bit signed bù 2)
    cos_q = max(min(cos_q, 255), -256);
    sin_q = max(min(sin_q, 255), -256);
    
    cos_table = cos_q/scale;
    sin_table = sin_q/scale;

    % Chuyển sang chuỗi nhị phân bù 2 dài 9-bit
    cos_bin_table = dec2bin(mod(cos_q, 512), 9);  % mod 512 = 2^9
    sin_bin_table = dec2bin(mod(sin_q, 512), 9);
    
    % In ra bảng nếu muốn gán vào ROM Verilog
    fprintf('Twiddle ROM:\n');
    for i = 1:16
        fprintf('%2d: cos = %7.4f (%3d), sin = %7.4f (%3d)\n', ...
            i-1, cos_table(i), cos_q(i), sin_table(i), sin_q(i));
    end
    
    % In bảng
    fprintf('Twiddle ROM (Q2.7 signed, 9-bit binary):\n');
    for i = 1:16
        fprintf('%2d: cos = %s  (%4d), sin = %s  (%4d)\n', ...
            i-1, cos_bin_table(i,:), cos_q(i), sin_bin_table(i,:), sin_q(i));
    end
end
