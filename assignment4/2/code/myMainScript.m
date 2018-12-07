%% MyMainScript


%% Read Yale dataset
num_train_per_person = 40;
num_test_per_person = 20;
num_persons = 38;
data = readDataYale('../CroppedYale/', num_train_per_person + num_test_per_person, num_persons);
train_data = data(:, :, 1: num_train_per_person, 1: num_persons);
test_data = data(:, :, num_train_per_person + 1 : num_train_per_person + num_test_per_person, 1: num_persons);
train_data_1d = reshape(train_data, [size(data, 1) * size(data, 2), num_train_per_person * num_persons]);
test_data_1d = reshape(test_data, [size(data, 1) * size(data, 2), num_test_per_person * num_persons]);

%% Calculate eigen-values/vectors using train dataset
tic;
mean_train = mean(train_data_1d, 2);
centered_train = train_data_1d - mean_train;
centered_test = test_data_1d - mean_train;
[V, D_sorted, D_argsort] = getEigVec(centered_train);
k = [2, 10, 20, 50, 75, 100, 125, 150, 175];
image_2d = test_data(:, :, 1, 1);
image = centered_test(:, 1);
image_p = transpose(V) * image;

%% Pick an example from test set and reconstruct it with different values of k; visualize eigenvectors
reconstructed_images = reconstructImage(image_p, V, D_argsort, k, mean_train);
reconstructed_images_2d = reshape(reconstructed_images, size(image_2d, 1), size(image_2d, 2), size(reconstructed_images, 2));
figure;
imshow(uint8(image_2d));
figure;
for i = 1 : size(k, 2)
    subplot(3, 3, i); imshow(uint8(reconstructed_images_2d(:, :, i))); title(strcat("k = ", string(k(i))));
end
N_rows = 5;
N_cols = 5;
N_eig = N_rows * N_cols;
V_2d = reshape(V, size(image_2d, 1), size(image_2d, 2), size(V, 2));
figure;
for i = 1 : N_eig
    ev = V_2d(:, :, D_argsort(i));
    contrast_stretched_ev = (ev - min(min(ev))) ./ (max(max(ev)) - min(min(ev))) .* 255;
    subplot(N_rows, N_cols, i); imshow(uint8(contrast_stretched_ev)); title(strcat("eigval = ", string(D_sorted(i))));
end
toc;
