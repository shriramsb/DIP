%% MyMainScript
load('../data/boat.mat');
inputImage = mat2gray(imageOrig);
sigma_grad = 1;
sigma_weights = 3;
k = 0.05;
[derivatives, eigenvalues, cornerness] = myHarrisCornerDetector(inputImage, sigma_grad, sigma_weights, k);

%% Plotting the derivative images
tic;
myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

h = figure;
subplot(1, 2, 1), imagesc(mat2gray(derivatives(:,:,1))), title('Derivative along x-axis');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(mat2gray(derivatives(:,:,2))), title('Derivative along y-axis');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% Plotting the eigenvalues
tic;

myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

h = figure;
subplot(1, 2, 1), imagesc(mat2gray(eigenvalues(:,:,1))), title('First Eigenvalue');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(mat2gray(eigenvalues(:,:,2))), title('Second Eigenvalue');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% Plotting cornerness
tic;
myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

h = figure;
subplot(1, 1, 1), imagesc(mat2gray(cornerness)), title('Cornerness');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;