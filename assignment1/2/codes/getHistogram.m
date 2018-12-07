function [histogram,cumulative_distribution] = getHistogram(image,mask)
    [num_rows, num_cols, num_channels] = size(image);
    max_intensity = 256;
    histogram = zeros(max_intensity, 1, num_channels);
    % histogram found by naively iterating over each pixel and incrementing the count of pixel value
    % if mask is empty - consider whole image
    if (isempty(mask))
        for channel = 1:num_channels
            for row = 1:num_rows
                for col = 1:num_cols
                    histogram(image(row, col, channel) + 1, 1, channel) ...
                        = histogram(image(row, col, channel) + 1, 1, channel) + 1;
                end
            end
        end
    % otherwise, consider only parts masked for histogram calculation
    else
       for channel = 1:num_channels
            for row = 1:num_rows
                for col = 1:num_cols
                    if mask(row,col) == 1
                        histogram(image(row, col, channel) + 1, 1, channel) ...
                            = histogram(image(row, col, channel) + 1, 1, channel) + 1;
                    end
                end
            end
        end 
    end
    % cumulative distribution found by accumulating histogram values from least to greatest bin
    cumulative_distribution = histogram;
    for channel = 1:num_channels
        for i = 2:max_intensity
            cumulative_distribution(i, 1, channel) = ...
                cumulative_distribution(i - 1, 1, channel) + histogram(i, 1, channel);
        end
    end
    % rescaling cdf output to lie between 0-255
    cumulative_distribution = double(cumulative_distribution);
    cumulative_distribution = cumulative_distribution ./ cumulative_distribution(end:end, 1:1, :);
    cumulative_distribution = cumulative_distribution * (max_intensity - 1);
end

