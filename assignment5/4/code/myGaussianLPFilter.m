function [Z, final_image] = myGaussianLPFilter(image, D)
    % dft computation
    dft = fftshift(fft2(image));
    [rows, cols] = size(image);
    
    % filter computation
    [X,Y] = meshgrid(-rows/2 + 1:rows/2, -cols/2 + 1:cols/2);
    Z = exp(-(X.^2 + Y.^2)/(2 * D * D));
    
    % filter application and idft of result
    final_image = abs(ifft2(dft .* Z));
end