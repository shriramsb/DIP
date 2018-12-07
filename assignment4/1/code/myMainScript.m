%% MyMainScript
 
%% Read ORL dataset
num_train_per_person = 6;
num_test_per_person = 4;
num_persons = 32;
% provide path to ORL database parent directory; include '/' at the end
data = readData('../att_faces/', num_train_per_person + num_test_per_person, num_persons);
train_data = data(:, :, 1: num_train_per_person, 1: num_persons);
test_data = data(:, :, num_train_per_person + 1 : num_train_per_person + num_test_per_person, 1: num_persons);

% reshape data to 1d for eigen-value/vector calculation
train_data_1d = reshape(train_data, [size(data, 1) * size(data, 2), num_train_per_person * num_persons]);
test_data_1d = reshape(test_data, [size(data, 1) * size(data, 2), num_test_per_person * num_persons]);


%% Setting true labels

train_labels = zeros(1, num_train_per_person * num_persons);
test_labels = zeros(1, num_test_per_person * num_persons);
for i = 1 : num_persons
    for j = 1 : num_test_per_person
        test_labels((i - 1) * num_test_per_person + j) = i;
    end
end

for i = 1 : num_persons
    for j = 1 : num_train_per_person
        train_labels((i - 1) * num_train_per_person + j) = i;
    end
end

%% Eigenvector calculation and recognition with PCA on test images
tic;
mean_train = mean(train_data_1d, 2);            % mean image
centered_train = train_data_1d - mean_train;    % mean-centering both train and test images
centered_test = test_data_1d - mean_train;

k = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];

[V, D_sorted, D_argsort] = getEigVec(centered_train);       % getting eigen-values/vectors
accuracy = getAccuracy(centered_train, centered_test, train_labels, test_labels, V, D_sorted, D_argsort, k, 0);
[V, D_sorted, D_argsort] = getEigVecSVD(centered_train);
accuracy_svd = getAccuracy(centered_train, centered_test, train_labels, test_labels, V, D_sorted, D_argsort, k, 0);
txt = sprintf("norm of difference in eig and svd accuracies : %f", norm(accuracy - accuracy_svd));    % not displaying svd; eig and svd have no difference in values
disp(txt);
figure;
plot(k, accuracy);
title("ORL database: accuracy vs k");
xlabel("k");
ylabel("accuracy");
toc;

%% Read Yale Dataset
num_train_per_person = 40;
num_test_per_person = 20;
num_persons = 38;
data = readDataYale('../CroppedYale/', num_train_per_person + num_test_per_person, num_persons);
train_data = data(:, :, 1: num_train_per_person, 1: num_persons);
test_data = data(:, :, num_train_per_person + 1 : num_train_per_person + num_test_per_person, 1: num_persons);
% reshape data to 1d for calculation of eigen-value/vectors
train_data_1d = reshape(train_data, [size(data, 1) * size(data, 2), num_train_per_person * num_persons]);
test_data_1d = reshape(test_data, [size(data, 1) * size(data, 2), num_test_per_person * num_persons]);

%% Setting true labels
train_labels = zeros(1, num_train_per_person * num_persons);
test_labels = zeros(1, num_test_per_person * num_persons);
for i = 1 : num_persons
    for j = 1 : num_test_per_person
        test_labels((i - 1) * num_test_per_person + j) = i;
    end
end

for i = 1 : num_persons
    for j = 1 : num_train_per_person
        train_labels((i - 1) * num_train_per_person + j) = i;
    end
end

%% Eigenvector calculation and recognition with PCA; comparing with/without top 3 eigenvectors
tic;
mean_train = mean(train_data_1d, 2);
centered_train = train_data_1d - mean_train;
centered_test = test_data_1d - mean_train;
k = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];
[V, D_sorted, D_argsort] = getEigVecSVD(centered_train);
% top 3 eigenvectors included in eigenfaces
accuracy_svd = getAccuracy(centered_train, centered_test, train_labels, test_labels, V, D_sorted, D_argsort, k, 0);
% top 3 eigenvectors not included in eigenfaces
accuracy_svd_offset = getAccuracy(centered_train, centered_test, train_labels, test_labels, V, D_sorted, D_argsort, k, 3);
figure;
plot(k, accuracy_svd);
title("Yale database: accuracy vs k including top 3 eigenvectors");
xlabel("k");
ylabel("accuracy");
figure;
plot(k, accuracy_svd_offset);
title("Yale database: accuracy vs k excluding top 3 eigenvectors");
xlabel("k");
ylabel("accuracy");
toc;

%%

