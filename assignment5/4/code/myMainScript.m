%% MyMainScript
tic;
%% Your code here
image = imread('../data/barbara256.png');

%% Ideal Low Pass Filter
cut_off = 60;
[filter, final_image] = myIdealLPFilter(image, cut_off);

dft = fftshift(fft2(filter));
log_abs_dft = log(abs(dft) + 1);
fig = imshow(log_abs_dft,  [-1 18]);
colormap(jet); colorbar;
saveas(fig, '../images/filter_ideal.png');

fig = imshow(uint8(final_image));
saveas(fig, '../images/final_image_ideal.png');

%% Gaussian Low Pass Filter
sigma = 60;
[filter, final_image] = myGaussianLPFilter(image, cut_off);

dft = fftshift(fft2(filter));
log_abs_dft = log(abs(dft) + 1);
fig = imshow(log_abs_dft,  [-1 18]);
colormap(jet); colorbar;
saveas(fig, '../images/filter_gaussian.png');

fig = imshow(uint8(final_image));
saveas(fig, '../images/final_image_gaussian.png');

 %% End
toc;
