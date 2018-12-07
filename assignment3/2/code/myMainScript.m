%% MyMainScript
tic;
%% Preparing Input parameters
f = waitbar(0,'PreparingInput');
downsample_factor = 0.25;
h_s = 35;
h_r = 35;
stopping_threshold = 0.01;
waitbar(0.01, f, "Running mean-shift-segmentation");

%% Smoothen the image and downsample
img = imread('../data/baboonColor.png');
img = imgaussfilt(img, 1);
img = imresize(img, downsample_factor);
img = double(img);

%% Algorithm
[final_img, num_iterations] = myMeanShiftSegmentation(img, h_s, h_r, stopping_threshold, f);
[unique_colors, ~, ~] = unique(reshape(uint8(final_img), [], 3), 'rows');
fprintf('Terminated in %d iterations with %d segments\n', num_iterations, size(unique_colors, 1));
delete(f);

%% Plotting all images
h = figure;
subplot(1, 2, 1), imagesc(uint8(img)), title('Original');
daspect([1 1 1]);

subplot(1, 2, 2), imagesc(uint8(final_img)), title('Segmented');
daspect([1 1 1]);
%% End of script
toc;
