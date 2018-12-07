%% MyMainScript
tic;
%% Your code here
image = load('../data/image_low_frequency_noise.mat');
image = image.Z;

%% Display the DFT
dft = fftshift(fft2(image));
log_abs_dft = log(abs(dft) + 1);
fig = imshow(log_abs_dft,  [-1 18]);
colormap(jet); colorbar;
saveas(fig, '../images/dft.png');

%% Analysis for interfering frequencies
clear_dft = log_abs_dft >= 13;
fig = imshow(clear_dft);
saveas(fig, '../images/dft_clipped.png');

% Peaks in dft
[r,c] = find(clear_dft);

% Abnormal peaks(or Frequency centers) in clear_dft
centers = [
   119   139;
   124   134;
];
%% Image restoration via Notch Filter
D = 20; % moderately tuned parameter
[filter, final_image] = myIdealNotchFilter(image, centers, D);

fig = imshow(double(filter));
saveas(fig, '../images/notch_filter.png');

fig = imshow(uint8(final_image));
saveas(fig, '../images/filtered_image.png');

 %% End
toc;
