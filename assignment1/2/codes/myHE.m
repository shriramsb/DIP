function [equalized_image] = myHE(image,mask)
    [num_rows, num_cols, num_channels] = size(image);
    % custom function to get histogram only taking masked pixels, if
    % specified
    [histogram, cumulative_distribution] = getHistogram(image, mask);
    % finding CDF(image(i,j)) for all i,j
    equalized_image = arrayfun(@(x) cumulative_distribution(x + 1, 1, 1), image(:, :, 1));
    
    % repeating same across channels
    for channel = 2:num_channels
        equalized_image(:, :, channel) = arrayfun(@(x) cumulative_distribution(x + 1, 1, channel), image(:, :, channel));
        equalized_image(:, :, channel) = arrayfun(@(x) cumulative_distribution(x + 1, 1, channel), image(:, :, channel));
    end
end

