function [best_threshold] = tuneThreshold(centered_train, centered_val, val_labels, V, D_argsort, k, offset)
    V_k = zeros(size(V, 1), k);
    % extracting eigenvectors corresponding to top 'cur_k' eigenvalues after
    % leaving first 'offset' eigenvalues
    for i = 1 : k
        V_k(:, i) = V(:, D_argsort(i + offset));
    end
    % projecting images onto calculated eigenspaces
    train_p = transpose(V_k) * centered_train;
    val_p = transpose(V_k) * centered_val;
    
    % squared distance of each test image with each train image
    dist = sum(train_p.^2, 1) + transpose(sum(val_p.^2, 1)) - 2 .* (transpose(val_p) * train_p);
    % closest train image for each test image
    [min_dist, min_index] = min(dist, [], 2);
    best_error = 2;
    best_threshold = 0;
    for i = 1 : size(min_dist, 1)
        cur_threshold = min_dist(i);
        [cur_error, FP, FN] = getBinaryAccuracy(min_dist, val_labels, cur_threshold);
        if (cur_error < best_error)
            best_error = cur_error;
            best_threshold = cur_threshold;
        end
    end
        
end

