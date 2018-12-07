function [accuracies] = getAccuracy(centered_train, centered_test, train_labels, test_labels, V, D_sorted, D_argsort, k, offset)
% given centered_train and centered_test images and eigen-values/vectors,
% implements PCA and calculates test accuracy for given list of k
accuracies = zeros(1, size(k, 2));
index = 1;
for cur_k = k
    V_k = zeros(size(V, 1), cur_k);
    % extracting eigenvectors corresponding to top 'cur_k' eigenvalues after
    % leaving first 'offset' eigenvalues
    for i = 1 : cur_k
        V_k(:, i) = V(:, D_argsort(i + offset));
    end
    % projecting images onto calculated eigenspaces
    train_p = transpose(V_k) * centered_train;
    test_p = transpose(V_k) * centered_test;
    % squared distance of each test image with each train image
    dist = sum(train_p.^2, 1) + transpose(sum(test_p.^2, 1)) - 2 .* (transpose(test_p) * train_p);
    % closest train image for each test image
    [min_dist, min_index] = min(dist, [], 2);
    
    % calculating accuracy from true_test_labels for 'cur_k'
    accuracy = 0.0;
    test_pred = zeros(1, size(test_p, 2));
    for i = 1 : size(min_index, 1)
        test_pred(i) = train_labels(min_index(i));
        if (test_pred(i) == test_labels(i))
            accuracy = accuracy + 1;
        end
    end
    accuracy = accuracy / size(test_p, 2);
    accuracies(index) = accuracy;
    index = index + 1;
end

