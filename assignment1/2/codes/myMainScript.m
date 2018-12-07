%% MyMainScript
myNumOfColors = 256;
myColorScale = [[0:1/(myNumOfColors-1):1]' ,[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];

%% part a)
tic;
image_paths = ["../data/barbara.png", "../data/TEM.png", "../data/canyon.png", "../data/retina.png", "../data/church.png"];
mask_paths = ["", "", "", "../data/retinaMask.png", ""];
is_grayscale = [1, 1, 0, 0, 0];
for i=1:5
    I = imread(char(image_paths(i)));
    mask = [];
    if (mask_paths(i) ~= "")
        mask = imread(char(mask_paths(i)));
    end
    I_linear_stretched = myLinearContrastStretching(I, mask);
    h = figure;
    subplot(2, 1, 1), imagesc(I), title('Original');
    daspect([1 1 1]);
    subplot(2, 1, 2), imagesc(I_linear_stretched), title('Contrast Stretched');
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
end

toc;

%% part b)
tic;
image_paths = ["../data/barbara.png", "../data/TEM.png", "../data/canyon.png", "../data/retina.png", "../data/church.png"];
mask_paths = ["", "", "", "../data/retinaMask.png", ""];
is_grayscale = [1, 1, 0, 0, 0];
for i=1:5
    I = imread(char(image_paths(i)));
    mask = [];
    if (mask_paths(i) ~= "")
        mask = imread(char(mask_paths(i)));
    end
    I_equalized = myHE(I, mask);
    h = figure;
    subplot(2, 1, 1), imagesc(I), title('Original');
    daspect([1 1 1]);
    subplot(2, 1, 2), imagesc(uint8(I_equalized)), title('Equalized');
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
end

toc;

%% part c)
tic;
I = imread('../data/retina.png');
I_mask = imread('../data/retinaMask.png');
Iref = imread('../data/retinaRef.png');
Iref_mask = imread('../data/retinaRefMask.png');
I_equalized = myHE(I, I_mask);
I_matched = myHM(I, I_mask, Iref, Iref_mask);
h = figure;
subplot(3, 1, 1), imagesc(I), title('Original');
daspect([1 1 1]);
subplot(3, 1, 2), imagesc(uint8(I_equalized)), title('Equalized');
daspect([1 1 1]);
subplot(3, 1, 3), imagesc(uint8(I_matched)), title('Matched');
daspect([1 1 1]);
toc;

%% part d)
tic;
f = waitbar(0,'Running Part (d) Script...');
image_paths = ["../data/barbara.png", "../data/TEM.png", "../data/canyon.png"];
o_image_paths = ["../Report/d/barbara.mat", "../Report/d/TEM.mat", "../Report/d/canyon.mat"];
is_grayscale = [1, 1, 0];
% Tuned Parameters for each image
N = [230, 200, 370];
for i=1:3
    I = imread(char(image_paths(i)));
    % AHE function for N
    I_AHE = myAHE(I, N(i));
    waitbar(i/3 - 0.22, f, "Enhanced " + char(image_paths(i))  + ' at N = ' + int2str(N(i)));
    
    % AHE function for N/4
    I_AHE_small = myAHE(I, uint16(N(i) / 4));
    waitbar(i/3 - 0.11, f, "Enhanced " + char(image_paths(i))  + ' at N = ' + int2str(uint16(N(i) / 4)));
    
    % AHE function for N*4
    I_AHE_large = myAHE(I, uint16(N(i) * 4));
    waitbar(i/3, f, "Enhanced " + char(image_paths(i))  + ' at N = ' + int2str(uint16(N(i) * 4)));
    
    % Plotting all images
    h = figure;
    subplot(2, 2, 1), imagesc(I), title('Original');
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
    
    subplot(2, 2, 2), imagesc(I_AHE), title("(Optimal) AHE Tuned N = " + int2str(N(i)));
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
    
    subplot(2, 2, 3), imagesc(I_AHE_large), title("AHE Tuned N = " + int2str(uint16(N(i) * 4)));
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
    
    subplot(2, 2, 4), imagesc(I_AHE_small), title("AHE Tuned N = " + int2str(uint16(N(i) / 4)));
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
    save(char(o_image_paths(i)),'I_AHE', 'I_AHE_large', 'I_AHE_small');
end
delete(f);
toc;

%% part e)
tic;
f = waitbar(0,'Running Part (e) Script...');
image_paths = ["../data/barbara.png", "../data/TEM.png", "../data/canyon.png"];
o_image_paths = ["../Report/e/barbara.mat", "../Report/e/TEM.mat", "../Report/e/canyon.mat"];
is_grayscale = [1, 1, 0];
% Tuned parameters
N = [230, 200, 370];
gamma = [0.0075, 0.0075, 0.0075];
for i=1:3
    I = imread(char(image_paths(i)));
   
    % CLAHE function for N , gamma
    I_CLAHE = myCLAHE(I, N(i), gamma(i));
    waitbar(i/3 - 0.16, f, "Enhanced " + char(image_paths(i))  + ' at N = ' + N(i) + ', gamma = ' + num2str(gamma(i)));
    
    % CLAHE function for N , gamma/2
    I_CLAHE_half = myCLAHE(I, N(i), gamma(i)/2);
    waitbar(i/3, f, "Enhanced " + char(image_paths(i))  + ' at N = ' + N(i) + ', gamma = ' + num2str(gamma(i)/2));
    
    % Plotting all images
    h = figure;
    subplot(1, 3, 1), imagesc(I), title('Original');
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
    
    subplot(1, 3, 2), imagesc(I_CLAHE), title("(optimal) CL-AHE Tuned N = " + int2str(N(i)) + ', gamma = ' +  num2str(gamma(i)));
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
    
    subplot(1, 3, 3), imagesc(I_CLAHE_half), title("CL-AHE Tuned N = " + int2str(N(i)) + ', gamma = ' +  num2str(gamma(i)/2));
    daspect([1 1 1]);
    if (is_grayscale(i))
        colormap(myColorScale);
        axis tight;
        colorbar;
    end
    save(char(o_image_paths(i)), 'I_CLAHE', 'I_CLAHE_half');
end
delete(f);
toc;