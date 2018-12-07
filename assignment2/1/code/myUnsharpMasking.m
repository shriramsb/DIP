function [sharpened_img] = myUnsharpMasking(img, std_dev, scale)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    filter = fspecial('gaussian', 6 * ceil(std_dev) + 1, std_dev);
    smoothed_img = imfilter(img, filter);
    sharpened_img = img + scale * (img - smoothed_img);
end

