function [filtered_img, patch_weights] = myPatchBasedFiltering(img, patch_weights_std_dev, h)
    
    patch_size = 9; half_patch_size = (patch_size - 1) / 2;
    window_size = 25; half_window_size = (window_size - 1) / 2;
    [rows, cols] = size(img);
    
    % gaussian weighting of patch intensity vector for making filtering isotropic
    patch_weights = fspecial('gaussian', patch_size, patch_weights_std_dev);
    
    filtered_img = img;
    for r = 1 : rows
        for c = 1 : cols
            % weights for each pixel inside the window
            pixel_weights = zeros(window_size, window_size);
            % patch width on (top, bottom, left, right) of center of window
            % center of window - p
            p_patch_lim = zeros(1, 4);
            p_patch_lim(1) = r - max(r - half_patch_size, 1);
            p_patch_lim(2) = min(r + half_patch_size, rows) - r;
            p_patch_lim(3) = c - max(c - half_patch_size, 1);
            p_patch_lim(4) = min(c + half_patch_size, cols) - c;
            
            % window width (top, bottom, left, right) of center of window
            window_lim = zeros(1, 4);
            window_lim(1) = r - max(r - half_window_size, 1);
            window_lim(2) = min(r + half_window_size, rows) - r;
            window_lim(3) = c - max(c - half_window_size, 1);
            window_lim(4) = min(c + half_window_size, cols) - c;
            
            % iterating over each point inside the window
            for i = r - window_lim(1) : r + window_lim(2)
                for j = c - window_lim(3) : c + window_lim(4)
                    % q - a point inside the window
                    % patch width on (top, bottom, left, right) of q
                    q_patch_lim = zeros(1, 4);
                    q_patch_lim(1) = i - max(i - half_patch_size, 1);
                    q_patch_lim(2) = min(i + half_patch_size, rows) - i;
                    q_patch_lim(3) = j - max(j - half_patch_size, 1);
                    q_patch_lim(4) = min(j + half_patch_size, cols) - j;
                    
                    % matching the patch dimensions around p and q to
                    % handle boundary of images
                    patch_lim = min(p_patch_lim, q_patch_lim);
                    
                    % extracting patch around p and q
                    p_patch = img(r - patch_lim(1) : r + patch_lim(2), c - patch_lim(3) : c + patch_lim(4));
                    q_patch = img(i - patch_lim(1) : i + patch_lim(2), j - patch_lim(3) : j + patch_lim(4));
                    
                    % extracting gaussian weights for patch from
                    % patch_weights
                    clipped_patch_weights = patch_weights(half_patch_size + 1 - patch_lim(1) : half_patch_size + 1 + patch_lim(2), half_patch_size + 1 - patch_lim(3) : half_patch_size + 1 + patch_lim(4));
                    % multiplying gaussian weight to patch and taking
                    % difference
                    cur_weight = sum(sum((clipped_patch_weights .* p_patch - clipped_patch_weights .* q_patch).^2)) / sum(sum(clipped_patch_weights.^2));
                    % weight for current point
                    cur_weight = exp(-cur_weight / h.^2);
                    pixel_weights(i - r + half_window_size + 1, j - c + half_window_size + 1) = cur_weight;
                end
            end
            
            % normalizing weights
            pixel_weights = pixel_weights ./ sum(sum(pixel_weights));
            % weighted sum of points in the window to get filtered image
            filtered_img(r, c) = sum(sum(pixel_weights(half_window_size + 1 - window_lim(1) : half_window_size + 1 + window_lim(2), half_window_size + 1 - window_lim(3) : half_window_size + 1 + window_lim(4)) .* img(r - window_lim(1) : r + window_lim(2), c - window_lim(3) : c + window_lim(4))));
        end
    end
    
end

