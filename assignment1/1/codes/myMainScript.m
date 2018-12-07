%% MyMainScript

%% part a)
tic;

myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];
image_path = '../data/circles_concentric.png';
I = imread(image_path);
I_Shrink_2 = myShrinkImageByFactorD(I,2);
I_Shrink_3 = myShrinkImageByFactorD(I,3);
h = figure;
subplot(1, 3, 1), imagesc(I), title('Original');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 3, 2), imagesc(I_Shrink_2), title('Subsampled by 2');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 3, 3), imagesc(I_Shrink_3), title('Subsampled by 3');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% part b)
tic;

myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];
image_path = '../data/barbaraSmall.png';
I = imread(image_path);
I_bilinear = myBilinearInterpolation(I);
h = figure;
subplot(1, 2, 1), imagesc(I), title('Original');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(I_bilinear), title('Bilinear Interpolated');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;

%% part c)
tic;

myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];
image_path = '../data/barbaraSmall.png';
I  = imread(image_path);
I_nn = myNearestNeighborInterpolation(I);
I_Shrink_3 = myShrinkImageByFactorD(I,3);
h = figure;
subplot(1, 2, 1), imagesc(I), title('Original');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

subplot(1, 2, 2), imagesc(I_nn), title('NN Interpolated');
daspect([1 1 1]);
colormap(myColorScale); axis tight; colorbar;

waitfor(h);

toc;