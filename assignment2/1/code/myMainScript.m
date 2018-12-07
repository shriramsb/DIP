%% MainScript
myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

%% Your code here
tic;
image_paths = ["../data/lionCrop.mat", "../data/superMoonCrop.mat"];
scale = [1,1];      %scale values for images
sigma = [5,10];     %sigma values for images
for i=1:2
    load(image_paths(i));
    
    img = imageOrig;
    [stretched_img, ~] = myLinearConstrastStretching(img);  %Linear Contrast Stretching
    
    h = figure;

    subplot(1,2,1);imshow(stretched_img);title('Original Image'); 
    daspect([1 1 1]);
    colormap(myColorScale);
    axis tight;
    colorbar;

    % Sharpening the image through myUnsharpMasking function
    sharp_img = myUnsharpMasking(stretched_img, sigma(i), scale(i));
    [stretched_sharp_img, ~] = myLinearConstrastStretching(sharp_img);
    subplot(1,2,2);imshow(stretched_sharp_img);title('Sharpened Image');
    daspect([1 1 1]);
    colormap(myColorScale);
    axis tight;
    colorbar;
end
toc;
