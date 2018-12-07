function [Z, final_image] = myIdealLPFilter(image, D)
    % dft computation
    dft = fftshift(fft2(image));
    [rows, cols] = size(image);
    
    % filter computation
    [X,Y] = meshgrid(-rows/2 + 1:rows/2, -cols/2 + 1:cols/2);
    Z = sqrt(X.^2 + Y.^2);
    % use of cutoff frequency D
    Z = Z <= D;
    
    % filter application and idft of result
    final_image = abs(ifft2(dft .* Z));
end
