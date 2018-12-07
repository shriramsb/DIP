function outputImage = myPCADenoising2(inputImage, sigma)
%myPCADenoising2 Image Denoising using only 200 patches
%   Detailed explanation goes here

img = inputImage;

[img_x, img_y] = size(img);

patch_xlim = img_x-6;
patch_ylim = img_y-6;

reconImage = zeros(img_x, img_y);
reconWeight = zeros(img_x, img_y);

for i=1:patch_xlim
    for j=1:patch_ylim
        patch = img(i:i+6, j:j+6);
        patch = patch(:);
        
        patch_xmin = max(i-15, 1);
        patch_xmax = min(i+9, patch_xlim);
        patch_ymin = max(j-15, 1);
        patch_ymax = min(j+9, patch_ylim);
        
        patch_num = (patch_xmax - patch_xmin + 1) * (patch_ymax - patch_ymin + 1);
        
        patches = zeros([49 patch_num]);
        
        for m=patch_xmin:patch_xmax
            for n=patch_ymin:patch_ymax
                patch_temp = img(m:m+6, n:n+6);
                patches(:, (patch_xmax-patch_xmin+1)*(m-patch_xmin) + (n-patch_ymin+1)) = patch_temp(:);
            end
        end
        
        mse = sum((patches - patch).^2);
        [~, ind] = sort(mse', 'ascend');
        
        patch_num = min(200, patch_num);
        P = patches(:,ind(1:patch_num));
        
        [V, ~] = eig(P*P');
        P_alpha = V'*P;

        avg_alpha = sum(P_alpha.^2 , 2)/patch_num;
        avg_alpha = max(avg_alpha - sigma*sigma, 0);

        ISNR = (sigma*sigma)./(avg_alpha.^2) + 1;

        P_alpha_den = P_alpha(:,1) ./ ISNR; %Only extract 1 patch from here

        P_den = V * P_alpha_den;
        
        patch_den = reshape(P_den, 7, 7);
        reconImage(i:i+6, j:j+6) = reconImage(i:i+6, j:j+6) + patch_den;
        reconWeight(i:i+6, j:j+6) = reconWeight(i:i+6, j:j+6) + 1;
    end
end

outputImage = reconImage./reconWeight;
end

