dim = [300, 300];           % dimensions of image
I = zeros(dim(1), dim(2));  
J = zeros(dim(1), dim(2));
top_I = [50, 50];           % top corner of white rectangle in I
dim_white = [50, 70];       % dimensions of white rectangle
% filling with white rectangle in I
I(top_I(1) : top_I(1) + dim_white(1) , top_I(2) : top_I(2) + dim_white(2)) = 255;
shift_J = [-30, 70];        % shift in white rectangle for J
top_J = [top_I(1) + shift_J(1), top_I(2) + shift_J(2)]; % top corner of white rectangle in J
% filling with white rectangle in J
J(top_J(1) : top_J(1) + dim_white(1) , top_J(2) : top_J(2) + dim_white(2)) = 255;

I = double(I);
J = double(J);

% getting cross power spectrum
cross_power_spectrum = crossPowerSpectrum(I, J);

% finding peak in inverse FT
c_inv = ifft2(cross_power_spectrum);

figure;
imagesc(log(1 + abs(cross_power_spectrum)));
title('Magnitude of Cross Power Spectrum - No Noise');
colormap('gray');
daspect([1 1 1]);
[M, ind] = max(c_inv);
[M, ind1] = max(M);
ind_x = ind(ind1);
ind_y = ind1;
fprintf('No noise, Peak in ift : x peak : %d, y peak : %d\n', ind_x, ind_y);

% repeating same for noisy image
std_dev = 20;
I = I + std_dev .* randn(dim(1), dim(2));
J = J + std_dev .* randn(dim(1), dim(2));

% getting cross power spectrum
cross_power_spectrum_noisy = crossPowerSpectrum(I, J);

% finding peak in inverse FT
c_inv_noisy = ifft2(cross_power_spectrum_noisy);

figure;
imagesc(log(1 + abs(cross_power_spectrum_noisy)));
title('Magnitude of Cross Power Spectrum - With Gaussian Noise');
colormap('gray');
daspect([1 1 1]);
[M, ind] = max(c_inv_noisy);
[M, ind1] = max(M);
ind_x = ind(ind1);
ind_y = ind1;
fprintf('Gaussian noise, Peak in ift : x peak : %d, y peak : %d\n', ind_x, ind_y);

fprintf('Magnitude of Cross Power Spectrum in both cases (with/without Gaussian noise) is 1 everywhere\n');

