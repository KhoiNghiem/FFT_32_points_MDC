function generate_quadrant_lut_9bit()
    %% Cấu hình
    N = 32;                   % Tổng số điểm FFT
    frac_bits = 7;           % Số bit phần thập phân (Q2.7)
    scale = 2^frac_bits;     % Hệ số scale
    total_bits = 9;          % Tổng số bit lưu giá trị signed
    num_entries = N / 4;     % Số điểm trong Quadrant I (8 điểm)

    %% Bước 1: Tính giá trị sin/cos cho góc dương Quadrant I
    k = 0:(num_entries - 1);                     % k = 0..7
    theta = pi * k / (2 * num_entries);          % theta từ 0 đến pi/2
    cos_q1 = cos(theta);                         % cos(góc dương)
    sin_q1 = sin(theta);                         % sin(góc dương)

    %% Bước 2: Đối xứng để tạo 16 điểm đầy đủ (0 đến pi)
    cos_vals = zeros(1, 16);
    sin_vals = zeros(1, 16);
    for n = 0:15
        if n < 8
            cos_vals(n+1) = cos_q1(n+1);
            sin_vals(n+1) = -sin_q1(n+1);
        else
            idx = n - 8 + 1; % Đối xứng từ điểm thứ 8 trở đi
            cos_vals(n+1) = -sin_q1(idx);   % cos(pi - θ) = -cos(θ)
            sin_vals(n+1) = -cos_q1(idx);    % sin(pi - θ) = sin(θ)
        end
    end

    %% Bước 3: Lượng tử hóa về Q2.7 (signed 9-bit)
    cos_q = floor(cos_vals * scale);
    sin_q = floor(sin_vals * scale);

    % Giới hạn phạm vi signed 9-bit: [-256, 255]
    cos_q = max(min(cos_q, 255), -256);
    sin_q = max(min(sin_q, 255), -256);

    % Đổi sang dạng nhị phân 9-bit signed (2's complement)
    cos_bin_table = dec2bin(mod(cos_q, 512), 9);
    sin_bin_table = dec2bin(mod(sin_q, 512), 9);

    %% Bước 4: In kết quả
    fprintf('N |   cos     |  sin     |  cos_q  |  sin_q  |   bin_cos   |   bin_sin\n');
    for n = 0:15
        fprintf('%2d | %8.5f | %8.5f | %6d  | %6d  | %s | %s\n', ...
            n, cos_vals(n+1), sin_vals(n+1), ...
            cos_q(n+1), sin_q(n+1), ...
            cos_bin_table(n+1,:), sin_bin_table(n+1,:));
    end
end
