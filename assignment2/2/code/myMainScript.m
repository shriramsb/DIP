%% MainScript
myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

%% Running on 3 images
tic;
image_paths = ["barbara", "honeyCombReal", "grass"];
% RMSD
rmsd = @(a, b) (sum(sum((a-b).*(a-b)))/(length(a(1:end)))) .^ 0.5;  
stretch = @(img) (img - min(min(img))) / (max(max(img)) - min(min(img)));
% Tuned Parameters for each image
sigma_spacial = [1.1, 1.3, 1.1];
sigma_intensity = [0.05, 0.08, 0.1];
for i=1:3
    % Different loading mechanisms for different images
    if(i == 1)
        I = load("../data/barbara.mat");
        image = I.imageOrig;
        range = max(max(image)) - min(min(image));
        I_C = image + (range * 0.10) * rand(512, 512);   
    
    elseif( i == 2)
        image = imread('../data/honeyCombReal.png');
        I_C = load('../data/honeyCombReal_Noisy.mat');
        I_C = I_C.imgCorrupt;
    
    else
        image = imread('../data/grass.png');
        I_C = load('../data/grassNoisy.mat');
        I_C = I_C.imgCorrupt;
    end
    
    % Linear constrast stretching images so as to make them comparable for
    % RMSD  calulations
    image = double(image);
    image = stretch(image);
    
    I_C = double(I_C);
    I_C = stretch(I_C);
        
    % BF function for optimal sigma1, sigma2
    [I_BF, mask] = myBilateralFiltering(I_C, sigma_spacial(i), sigma_intensity(i));
    fprintf('RMSD for %s for optimal case is %f\n', char(image_paths(i)), rmsd(I_BF, image));
    
    % BF function for 0.9 sigma1, sigma2
    [I_BF1, ~]= myBilateralFiltering(I_C, 0.9 * sigma_spacial(i), sigma_intensity(i));
    fprintf('RMSD for %s: 0.9 * spacial, 1.0 * intensity is %f\n', char(image_paths(i)), rmsd(I_BF1, image));
    
    % BF function for 1.1 sigma1, sigma2
    [I_BF2, ~]= myBilateralFiltering(I_C, 1.1 * sigma_spacial(i), sigma_intensity(i));
    fprintf('RMSD for %s: 1.1 * spacial, 1.0 * intensity is %f\n', char(image_paths(i)), rmsd(I_BF2, image));
    
    % BF function for sigma1, 0.9 sigma2
    [I_BF3, ~]= myBilateralFiltering(I_C, sigma_spacial(i), 0.9 * sigma_intensity(i));
    fprintf('RMSD for %s: 1.0 * spacial, 0.9 * intensity is %f\n', char(image_paths(i)), rmsd(I_BF3, image));
    
    % BF function for sigma1, 1.1 sigma2
    [I_BF4, ~]= myBilateralFiltering(I_C, sigma_spacial(i), 1.1 * sigma_intensity(i));
    fprintf('RMSD for %s: 1.0 * spacial, 1.1 * intensity is %f\n', char(image_paths(i)), rmsd(I_BF4, image));
    
    % Plotting all images
    h = figure;
    subplot(2, 2, 1), imagesc(image), title('Original');
    daspect([1 1 1]);
    colormap(myColorScale);
    axis tight;
    colorbar;
    
    subplot(2, 2, 2), imagesc(I_C), title('Corrupted');
    daspect([1 1 1]);
    colormap(myColorScale);
    axis tight;
    colorbar;
    
    subplot(2, 2, 3), imagesc(I_BF), title("BF Tuned spacial = " + sigma_spacial(i) + ", intensity = " + sigma_intensity(i));
    daspect([1 1 1]);
    colormap(myColorScale);
    axis tight;
    colorbar;
    
    subplot(2, 2, 4), imagesc(mask), title("spacial gaussian mask");
    daspect([1 1 1]);
    colormap(myColorScale);
    axis tight;
    colorbar;
end
toc;
