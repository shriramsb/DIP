function [Z, final_image] = myIdealNotchFilter(image, centers, D)
    [rows, cols] = size(image);
    
    % dft computation given image
    dft = fftshift(fft2(image));
    
    % filter computation
    [X,Y] = meshgrid(1:rows, 1:cols);
    Z = ones(rows, cols);
    for c = centers
        tmp_mask = (Y - c(1)).^2 + (X - c(2)).^2;
        Z = Z .* (tmp_mask > D); 
    end
   
    % filter application and inverse dft to get final image
    final_image = abs(ifft2(dft .* Z));
end