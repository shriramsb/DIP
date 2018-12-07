function [final_image] = myCLAHE(image, N, gamma)
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
                window = image(left_lim:right_lim, down_lim:up_lim, ch);
                histogram = imhist(window);
              
                
                % Calculating clip limit and amount to redistribute 
                cut_point = uint16((right_lim - left_lim) * (up_lim- down_lim) * gamma);                
                redistribute_amt = sum(histogram(histogram > cut_point));
                
                %Clipping and redistributing histogram 
                histogram(histogram > cut_point)= cut_point;
                sz = size(histogram);
                histogram =  histogram + redistribute_amt/sz(1,1);
                
                % CDF of new histogram
                cdf = cumsum(histogram) / sum(histogram);

                % Transforming pixel to new value
                final_image(r, c, ch) = 255 * cdf(image(r, c, ch) + 1, 1);
            end
        end
    end
 end