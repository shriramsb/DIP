
%image = imread('../data/test/baboonColor.png');
image = imread('../data/images/im_9.bmp');
image = rgb2gray(image);
%image = imread('../data/test/image1.png');
%Calculation of ETF
[tx,ty] = ETF(image, 5, 3);

% Line Integral Convolution and Visualization
f = LIC(tx,ty,25);
s = @(img) (img - min(min(img)))/(max(max(img)) - min(min(img)));
imshow(double(s(f)))

% plotting the vector field
quiver(tx, ty)

