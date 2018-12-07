function [final_image, spacial_guassian_mask] = myBilateralFiltering(image, spacial_sigma, intensity_sigma)
    final_image = image;
    [rows, cols] = size(image);
    
    % Step 1: Create function for 2 guassians according to given input parameters
    f =@(x, sigma) exp(-double(x) .^ 2 / (2 * sigma ^ 2));  
    
    % Step 2: Create Spacial guassian window
    window_size = 6 * ceil(spacial_sigma);
    if mod(window_size,2) == 0
        window_size = window_size + 1;
    end
    
    W = fspecial('gaussian', window_size, spacial_sigma);        
    
    % Step 3: Convolution
    for r =1:rows
        for c =1:cols
            
            % Window limits in imput image
            left_lim = r - (window_size-1)/2;
            right_lim = r + (window_size-1)/2;
            down_lim = c - (window_size-1)/2;
            up_lim = c + (window_size-1)/2;
            
            % Window limits in mask
            left_lim_x = 1;
            right_lim_x = window_size;
            down_lim_x = 1;
            up_lim_x = window_size;
            
            % Crop window
            if r - (window_size-1)/2 < 1
               left_lim = 1;
               left_lim_x = (window_size+1)/2 - r + 1;
            end
            
            if r + (window_size-1)/2 > rows
               right_lim = rows;
               right_lim_x = (window_size+1)/2 + rows - r;
            end
            
            if c - (window_size-1)/2 < 1
               down_lim = 1;
               down_lim_x = (window_size+1)/2 - c + 1;
            end
            
            if c + (window_size-1)/2 > cols
               up_lim = cols;
               up_lim_x = (window_size+1)/2 + cols - c;
            end
            
            % Window and mask creation from image
            window = image(left_lim:right_lim, down_lim:up_lim);
            W_here = W(left_lim_x:right_lim_x, down_lim_x:up_lim_x);
            mask = W_here .* f(window - image(r,c), intensity_sigma); 
            
            % Calculation of convoluted intensities
            numerator = sum(sum(mask .* window));
            final_image(r,c) = numerator/sum(sum(mask));
        end
    end
    
    spacial_guassian_mask = W;
end

