function outputImage = myPCADenoising1(inputImage, sigma)
%myPCADenoising1 PCA Denoising Function
%   Detailed explanation goes here
img = inputImage;

[img_x, img_y] = size(img);

patch_xlim = img_x-6;
patch_ylim = img_y-6;
N = patch_xlim * patch_ylim;

P = zeros([49, N]);

for i=1:patch_xlim
    for j=1:patch_ylim
        patch = img(i:i+6, j:j+6);
        P(:, (i-1)*patch_xlim + j) = patch(:);
    end
end

[V, ~] = eig(P*P');
P_alpha = V'*P;



avg_alpha = sum(P_alpha.^2 , 2)/N;
avg_alpha =  max(avg_alpha - sigma*sigma, 0);

ISNR = (sigma*sigma)./(avg_alpha.^2) + 1;

P_alpha_den = P_alpha ./ ISNR;

P_den = V * P_alpha_den;

reconImage = zeros(img_x, img_y);
reconWeight = zeros(img_x, img_y);

for i=1:patch_xlim
    for j=1:patch_ylim
        patch_den = reshape(P_den(:, (i-1)*patch_xlim + j), 7, 7);
        reconImage(i:i+6, j:j+6) = reconImage(i:i+6, j:j+6) + patch_den;
        reconWeight(i:i+6, j:j+6) = reconWeight(i:i+6, j:j+6) + 1;
    end
end

outputImage = reconImage./reconWeight;

end

