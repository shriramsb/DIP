function [img_derivative, eigenvalues, cornerness] = myHarrisCornerDetector(inputImage, sigma_grad, sigma_weights, k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

img = inputImage;
[img_x, img_y] = imgradientxy(img);         %Gradient along x and y directions
grad_kdim = round(3*sigma_grad);            %Size of gradient smoothening kernel
grad_kernel = fspecial('gaussian', [grad_kdim grad_kdim], sigma_grad);
img_x = conv2(img_x, grad_kernel, 'same');
img_y = conv2(img_y, grad_kernel, 'same');

img_derivative = cat(3, img_x, img_y);      %Storing the derivatives for output

%Calculating gradient products for constructing structure tensor
img_xx = img_x .^ 2;        
img_yy = img_y .^ 2;
img_xy = img_x .* img_y;

%Smoothening using the weights i.e. gaussian window in Harris
weights_kdim = round(3*sigma_weights);
weights_kernel = fspecial('gaussian', [weights_kdim weights_kdim], sigma_weights);
pixel_xx = conv2(img_xx, weights_kernel, 'same');
pixel_yy = conv2(img_yy, weights_kernel, 'same');
pixel_xy = conv2(img_xy, weights_kernel, 'same');

[num_rows, num_cols] = size(img);
eigenvalues = ones(num_rows, num_cols, 2);
cornerness = ones(num_rows, num_cols);

%For each pixel, constructing the structure matrix, 
%to determine its eigenvalues and cornerness
for i = 1:num_rows
    for j = 1:num_cols
        struct_tensor = [pixel_xx(i,j) pixel_xy(i,j); pixel_xy(i,j) pixel_yy(i,j)];
        eigenvalues(i,j,:) = eig(struct_tensor);
        cornerness(i,j) = det(struct_tensor) - k * trace(struct_tensor) * trace(struct_tensor);
    end
end
end

