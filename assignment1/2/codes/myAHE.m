function [final_image] = myAHE(image, N)
    [rows, cols, channels] = size(image);
    final_image = image;
    
    for ch = 1:channels
        for r =1:rows
            for c =1:cols
                % Creating cropped window around the pixel (r,c)
                left_lim    = max(r - N/2, 1);
                right_lim   = min(r + N/2, rows);
                down_lim    = max(c - N/2, 1);
                up_lim      = min(c + N/2, cols);
                
                % Getting CDF for cropped window 
                cdf = getCdf(image(left_lim:right_lim, down_lim:up_lim, ch));
                
                % Transforming pixel to new value
                final_image(r, c, ch) = 255 * cdf(image(r, c, ch) + 1, 1);
            end
        end
    end
 end





