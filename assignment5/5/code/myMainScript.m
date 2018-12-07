%% MyMainScript
myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

im = double(imread('../data/barbara256.png'));
im1 = im + randn(size(im))*20;

%% Part a)
% PCA Denoising using all patches for eigenspace
tic;

im2 = myPCADenoising1(im1, 20);
rmse_a = sqrt( sum(sum((im2-im).^2)) / sum(sum(im.^2)) );
fprintf('RMSE for part a) is %f\n', rmse_a);

h = figure;
subplot(1, 2, 1), imagesc(mat2gray(im1)), title('Original Image');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(mat2gray(im2)), title('Denoised using all patches');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% Part b)
% PCA Denoising using 200 best neighbouring patches for eigenspace
tic;

im2 = myPCADenoising2(im1, 20);
rmse_b = sqrt( sum(sum((im2-im).^2)) / sum(sum(im.^2)) );
fprintf('RMSE for part b) is %f\n', rmse_b);

h = figure;
subplot(1, 2, 1), imagesc(mat2gray(im1)), title('Original Image');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(mat2gray(im2)), title('Denoised using best 200 patches');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% Part c)
% Denoising using Bilateral Filtering
tic;

im2 = myBilateralFiltering(im1, 1.1, 0.05);
rmse_c = sqrt( sum(sum((im2-im).^2)) / sum(sum(im.^2)) );
fprintf('RMSE for part c) is %f\n', rmse_c);

h = figure;
subplot(1, 2, 1), imagesc(mat2gray(im1)), title('Original Image');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(mat2gray(im2)), title('Denoised using bilateral filter');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% Part d)
% Removing Poisson Noise for im
tic;

im1 = poissrnd(im);
im2 = myPCADenoising2(sqrt(im1), 0.5);
im3 = im2.^2;
rmse_d = sqrt( sum(sum((im3-im).^2)) / sum(sum(im.^2)) );
fprintf('RMSE for part d) is %f\n', rmse_d);

h = figure;
subplot(1, 2, 1), imagesc(mat2gray(im1)), title('Original Image');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(mat2gray(im3)), title('Removing Poisson Noise');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% Part e)
% Removing Poisson Noise for low exposure image
tic;

im_low = im/20;
im1 = poissrnd(im_low);
im2 = myPCADenoising2(sqrt(im1), 0.5);
im3 = im2.^2;
rmse_e = sqrt( sum(sum((im3-im_low).^2)) / sum(sum(im_low.^2)) );
fprintf('RMSE for part e) is %f\n', rmse_e);

h = figure;
subplot(1, 2, 1), imagesc(mat2gray(im1)), title('Low-exposure Image');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(mat2gray(im3)), title('Removing Poisson Noise for low exposure image');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;