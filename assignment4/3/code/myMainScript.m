%% MyMainScript

%% Read ORL dataset
total_images_pp = 10;
total_persons = 40;
% provide path to ORL database parent directory; include '/' at the end
data = readData('../att_faces/', total_images_pp, total_persons);
num_train_pp = 5;
num_val_pp = 1;
num_test_pp = 4;
num_train = 26;
num_val = 6;
num_test = 8;

test_data = data(:, :, num_train_pp + num_val_pp + 1: num_train_pp + num_val_pp + num_test_pp, 1 : total_persons);
test_data_1d = reshape(test_data, [size(data, 1) * size(data, 2), num_test_pp * total_persons]);

% setting true test labels
test_labels = zeros(1, num_test_pp * total_persons);
for i = 1 : total_persons
    for j = 1 : num_test_pp
        if (i <= num_train + num_val)
            test_labels((i - 1) * num_test_pp + j) = 1;
        else
            test_labels((i - 1) * num_test_pp + j) = 0;
        end
    end
end

%% validation - construct train and val dataset 
train_data = data(:, :, 1: num_train_pp, 1: num_train);
val_data = data(:, :, num_train_pp + 1 : num_train_pp + num_val_pp, 1: (num_train + num_val));

% reshape data to 1d for eigen-value/vector calculation
train_data_1d = reshape(train_data, [size(data, 1) * size(data, 2), num_train_pp * num_train]);
val_data_1d = reshape(val_data, [size(data, 1) * size(data, 2), num_val_pp * (num_train + num_val)]);

% setting true labels
val_labels = zeros(1, num_val_pp * (num_train + num_val));
for i = 1 : (num_train + num_val)
    for j = 1 : num_val_pp
        if (i <= num_train)
            val_labels((i - 1) * num_val_pp + j) = 1;
        else
            val_labels((i - 1) * num_val_pp + j) = 0;
        end
    end
end

val_class_labels = zeros(1, num_val_pp * (num_train + num_val));
for i = 1 : (num_train + num_val)
    for j = 1 : num_val_pp
        val_class_labels((i - 1) * num_val_pp + j) = i;
    end
end

train_class_labels = zeros(1, num_train_pp * num_train);
for i = 1 : num_train
    for j = 1 : num_train_pp
        train_class_labels((i - 1) * num_train_pp + j) = i;
    end
end


%% validation - find best_k and best_threshold
k = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100];

mean_train = mean(train_data_1d, 2);            % mean image
centered_train = train_data_1d - mean_train;    % mean-centering both train and test images
centered_val = val_data_1d - mean_train;

[V, D_sorted, D_argsort] = getEigVec(centered_train);       % getting eigen-values/vectors
% taking best_k according to classification accuracy
accuracy = getAccuracy(centered_train, centered_val(:, 1: num_val_pp * num_train), train_class_labels, val_class_labels(1 : num_train * num_val_pp), V, D_sorted, D_argsort, k, 0);
[accuracy_sorted, accuracy_argmax] = max(accuracy, [], 2);
best_k = k(accuracy_argmax(1));

best_threshold = tuneThreshold(centered_train, centered_val, val_labels, V, D_argsort, best_k, 0);

%% testing - expand training data into validation data
num_train = num_train + num_val;
num_train_pp = num_train_pp + num_val_pp;
train_data = data(:, :, 1: num_train_pp, 1: num_train);
train_data_1d = reshape(train_data, [size(data, 1) * size(data, 2), num_train_pp * num_train]);
offset = 0;

%% Use calculated hyperparameters to train with whole train set and test on test set

mean_train = mean(train_data_1d, 2);            % mean image
centered_train = train_data_1d - mean_train;    % mean-centering both train and test images
centered_test = test_data_1d - mean_train;    % mean-centering both train and test images

[V, D_sorted, D_argsort] = getEigVec(centered_train);       % getting eigen-values/vectors

V_k = zeros(size(V, 1), best_k);
% extracting eigenvectors corresponding to top 'cur_k' eigenvalues after
% leaving first 'offset' eigenvalues
for i = 1 : best_k
    V_k(:, i) = V(:, D_argsort(i + offset));
end
% projecting images onto calculated eigenspaces
train_p = transpose(V_k) * centered_train;
test_p = transpose(V_k) * centered_test;

% squared distance of each test image with each train image
dist = sum(train_p.^2, 1) + transpose(sum(test_p.^2, 1)) - 2 .* (transpose(test_p) * train_p);
% closest train image for each test image
[min_dist, min_index] = min(dist, [], 2);

[test_accuracy, FP, FN] = getBinaryAccuracy(min_dist, test_labels, best_threshold);
    
disp(strcat("metric: ", string(test_accuracy)));
disp(strcat("False positives: ", string(FP)));
disp(strcat("False negatives: ", string(FN)));
