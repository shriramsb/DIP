%% MyMainScript
myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

%% Patch Based Filtering for 3 given images
tic;
image_paths = ["barbara", "honeyCombReal", "grass"];
o_image_paths = ["../Report/barbara.mat", "../Report/honeyComb.mat", "../Report/grass.mat"];
% RMSD
rmsd = @(a, b) (sum(sum((a-b).*(a-b)))/(length(a(1:end)))) ^ 0.5;  
stretch = @(img) (img - min(min(img))) / (max(max(img)) - min(min(img)));
% standard deviation for weighing patch (making it isotropic)
patch_weights_std_dev = [3, 3, 1.5];
% standard deviation for gaussian function of patch distance (h as
% represented in class)
gaussian_weights = [0.04, 0.035, 0.047];
for i=1:3
    if(i == 1)
        % downsampling only barbara image by 2
        I = load("../data/barbara.mat");
        image = I.imageOrig;
        range = max(max(image)) - min(min(image));
        I_C = image + (range * 0.3) * rand(512, 512);
        gaussian_blur_filter = fspecial('gaussian', 5, 0.66);
        I_C = imfilter(I_C, gaussian_blur_filter);
        image = image(1:2:end, 1:2:end);
        I_C = I_C(1:2:end, 1:2:end); 
    
    elseif( i == 2)
        image = imread('../data/honeyCombReal.png');
        I_C = load('../data/honeyCombReal_Noisy.mat');
        I_C = I_C.imgCorrupt;
    
    else
        image = imread('../data/grass.png');
        image = double(image);
        range = max(max(image)) - min(min(image));
        I_C = load('../data/grassNoisy.mat');
        I_C = I_C.imgCorrupt;
    end
    % image - original image, I_C - corrupted image
    image = double(image);
    image = stretch(image);
    I_C = double(I_C);
    I_C = stretch(I_C);
        
    % PF function for optimal sigma
    [I_PF, mask] = myPatchBasedFiltering(I_C, patch_weights_std_dev(i), gaussian_weights(i));
    I_PF = stretch(I_PF);
    fprintf('RMSD for %s for case 0 is %f\n', char(image_paths(i)), rmsd(I_PF, image));
    
    % PF function for 0.9 sigma
    [I_PF1, ~] = myPatchBasedFiltering(I_C, patch_weights_std_dev(i), 0.9 * gaussian_weights(i));
    I_PF1 = stretch(I_PF1);
    fprintf('RMSD for %s for case 1 is %f\n', char(image_paths(i)), rmsd(I_PF1, image));
    
    % PF function for 1.1 sigma
    [I_PF2, ~] = myPatchBasedFiltering(I_C, patch_weights_std_dev(i), 1.1 * gaussian_weights(i));
    I_PF2 = stretch(I_PF2);
    fprintf('RMSD for %s for case 2 is %f\n', char(image_paths(i)), rmsd(I_PF2, image));
    
    % Plotting all images
    h = figure;
    subplot(2, 2, 1), imagesc(image), title('Original');
    daspect([1 1 1]);
    colormap gray;
    axis tight;
    colorbar;
    
    subplot(2, 2, 2), imagesc(I_C), title('Corrupted');
    daspect([1 1 1]);
    colormap gray;
    axis tight;
    colorbar;
    
    subplot(2, 2, 3), imagesc(I_PF), title("Patch weights stddev = " + patch_weights_std_dev(i) + ", gaussian intensity weights = " + gaussian_weights(i));
    daspect([1 1 1]);
    colormap gray;
    axis tight;
    colorbar;
    
    subplot(2, 2, 4), imagesc(mask), title("spacial gaussian mask");
    daspect([1 1 1]);
    colormap gray;
    axis tight;
    colorbar;
    
    save(char(o_image_paths(i)), 'image', 'I_C', 'I_PF', 'mask');
end
toc;