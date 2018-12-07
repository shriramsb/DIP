function [smoothed_img] = FBL(img, sigma_e, r_e, sigma_g, r_g, tx, ty, type)
    % type = 1 => along the edge
    % type = 2 => in gradient direction
    if (type == 1)
        d = ceil(3 * sigma_e);                    % d is number of points (one-side) to get from streamline
        x = linspace(-d+1, d-1, 2*d-1);
        spatial_gaussian = exp(-x .^ 2 / (2 * ((d/3) ^ 2)));
        [rows, cols, ~] = size(img);
        smoothed_img = zeros(size(img));
        for j = 1 : rows
            for i = 1 : cols
                % l can be 1D or 3D. If 3D, it needs to have 3 rows each
                % giving a color component
                l = streamline(j, i, tx, ty, d, img);
                intensity_gaussian = applyIntensityGaussian(l, img(j, i, :), r_e);
                res = zeros(1, size(l, 1));
                normalizer = sum(spatial_gaussian .* intensity_gaussian);
                for k = 1 : size(l, 1)
                    res(k) = sum(l(k, :) .* spatial_gaussian .* intensity_gaussian) ./ normalizer;
                end
                smoothed_img(j, i, :) = res;
            end
        end
    elseif (type == 2)
        d = ceil(3 * sigma_g);
        x = linspace(-d+1, d-1, 2*d - 1);
        spatial_gaussian = exp(-x .^ 2 / (2 * ((d/3) ^ 2)));
        [rows, cols, ~] = size(img);
        smoothed_img = zeros(size(img));
        for j = 1 : rows
            for i = 1 : cols
                grad = [ty(j, i), -tx(j, i)];
                l = gradline(j, i, grad, d, img);
                intensity_gaussian = applyIntensityGaussian(l, img(j, i, :), r_g);
                res = zeros(1, size(l, 1));
                normalizer = sum(spatial_gaussian .* intensity_gaussian);
                for k = 1 : size(l, 1)
                    res(k) = sum(l(k, :) .* spatial_gaussian .* intensity_gaussian) ./ normalizer;
                end
                smoothed_img(j, i, :) = res;
            end
        end     
    end
end

