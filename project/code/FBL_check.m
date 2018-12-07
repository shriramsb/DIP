
image = imread('../data/test/lion_face.png');

% Example similar to Fig 16 in paper
%{
rows = 300;
cols = 300;
image = zeros(rows, cols);
radius = 50;
center = [rows/2, cols/2];
for i = 1:rows
    for j=1:cols
        if ((i - center(1))^2 + (j - center(2))^2 < radius^2)
            image(i, j) = 150;
        else
            image(i, j) = 200;
        end
    end
end
std = 10.0;
image = image + std * randn(rows, cols);
%}
%imshow(uint8(image));


%% Finding ETF
%Smoothning given image
image = imgaussfilt(image, 1);

image_gray = rgb2gray(image);
%Calculation of ETF
[tx,ty] = ETF(image_gray, 5, 2);
fprintf(1, "1done");
%%
% Line Integral Convolution and Visualization
f = LIC(tx,ty,25);
s = @(img) (img - min(min(img)))/(max(max(img)) - min(min(img)));
imshow(double(s(f)))

% plotting the vector field
%quiver(tx, ty)
fprintf(1, "1adone");

%%
sigma_e = 2.0; sigma_g = 0.5;
r_e = 10; r_g = 10;
iters = 5;
smoothed_image = double(image);
for i = 1 : iters 
    smoothed_image = FBL(smoothed_image, sigma_e, r_e, sigma_g, r_g, tx, ty, 1);
    smoothed_image = FBL(smoothed_image, sigma_e, r_e, sigma_g, r_g, tx, ty, 2);
    figure;
    imshow(uint8(smoothed_image));
end
fprintf(1, "2done");

%% Quantizing image
num_bins = 10;
grad_range = [0, 100];
phi_range = [3, 14];
quantized_image = quantizeImage(smoothed_image, num_bins, grad_range, phi_range);
imshow(uint8(quantized_image));