function [cross_power_spectrum] = crossPowerSpectrum(I, J)
fft_I = fft2(I);
fft_J = fft2(J);

cross_power_spectrum = (fft_I .* conj(fft_J)) ./ (abs(fft_I .* fft_J));
for i=1:size(I, 1)
    for j=1:size(I, 2)
        if (isnan(cross_power_spectrum(i, j)))
            cross_power_spectrum(i, j) = 1;
        end
    end
end
end

