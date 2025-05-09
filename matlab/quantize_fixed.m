function yq = quantize_fixed(x, N_frac)
    % Lượng tử hóa số phức theo fixed-point với phần thập phân N_frac
    scale = 2^N_frac;
    yq = floor(real(x)*scale)/scale + 1j*floor(imag(x)*scale)/scale;
end