function [matched_image] = myHM(image1, mask1, image2, mask2)
    [histogram1, cdf1] = getHistogram(image1, mask1);
    [histogram2, cdf2] = getHistogram(image2, mask2);
    [num_rows, num_cols, num_channels] = size(image1);
    matched_image = zeros(num_rows, num_cols, num_channels);
    for channel = 1:num_channels
        for row = 1:num_rows
            for col = 1:num_cols
                % include only masked regions
                if (mask1(row, col) == 0)
                    continue
                end
                % apply cdf of original image
                matched_image(row, col, channel) = cdf1(image1(row, col, channel) + 1, 1, channel);
                % finding inverse of cdf or reference image - 
                % inv_cdf(x) - approximated with least value y such that cdf(y) >= x
                inverse = 1;
                while ((inverse <= 256) && (matched_image(row, col, channel) > cdf2(inverse, 1, channel)))
                    inverse = inverse + 1;
                end
                inverse = inverse - 1;
                matched_image(row, col, channel) = inverse;
            end
        end
    end
end

