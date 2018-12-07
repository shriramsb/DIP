%% myMeanShiftSegmentation Code
function [segmented_img,num_iterations] = myMeanShiftSegmentation(img, h_s, h_r, stopping_threshold, bar)
    % ---INPUT---
    % img               - input RGB image(may be downsampled) to be segmented
    % h_s               - spacial bandwidth parameter
    % h_r               - range(color) bandwidth parameter
    % stopping_threshold- value s.t if maximum movement of any pixel is
    %                     less than this value then the algorithm is said to converge
    % bar               - waitbar to display progress
    
    % ---OUTPUT---
    % segmented_img     - final RGB image with segmented colors
    % num_iterations    - Number of iterations till convergence
    
    
    % ---ALGORITHM---
    
    % Step 1: Make feature vectors
    [n_rows, n_cols, ~] = size(img); 
    features = reshape(img, n_rows * n_cols, 3); %colors R,G,B
    [X, Y] = meshgrid(1:n_rows,1:n_cols);
    features(:,4) = reshape(Y, n_rows * n_cols, 1); %row number
    features(:,5) = reshape(X, n_rows * n_cols, 1); %col number
    
    % Step 3: Define Kernel
    kernel = @(x, y) exp(-sum((x-y).^2, 2));
    dist = @(x, y) sum((x - repmat(y,1)).^2, 2);
    knn = @(x, y, c) find(dist(x, y) < c);

    % Step 4: Mean Shift Algorithm
    num_iterations = 0;
    while num_iterations < 20
        num_iterations = num_iterations + 1;
        waitbar(double(num_iterations)/20, bar, "Running iteration " + int2str(num_iterations));
        err = 0;
        
        for i=1:n_rows * n_cols
            temp_features = horzcat(features(:,1:3)/h_r , features(:,4:5)/h_s);
            % Step 4.1: knnsearch on feature space to find nearest neighbours to pt i
            indices = knn(temp_features, temp_features(i,:), 1);          
            
            % Step 4.2: Calculate weighted mean
            weights = kernel(temp_features(indices,:), repmat(temp_features(i,:), length(indices), 1));
            weights = weights/sum(weights);
            weights = repmat(weights,1,5);
            mean = sum(features(indices,:) .*  weights);
                        
            % Step 4.3: Calulate the shift
            mean_shift = mean - features(i,:);
            err = max(err, sum(mean_shift.^2));
                        
            % Step 4.4: update the point
            features(i,:) = mean;
            
        end
        % disp(err);
        if (err <= stopping_threshold)
            break
        end
    end
        
    % Step 5: Transform Final Features to RGB image
    segmented_img = reshape(features(:,1:3), n_rows, n_cols, 3);
end