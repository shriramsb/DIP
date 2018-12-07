function [reconstructed_images] = reconstructImage(image_p, V, D_argsort, k, mean_image)

reconstructed_images = zeros(size(mean_image, 1), size(k, 2));
index = 1;
for cur_k = k
    % projections on top 'cur_k' eigenvectors
    image_pk = zeros(cur_k, 1);
    % top 'cur_k' eigenvectors
    V_k = zeros(size(V, 1), cur_k);
    for i = 1: cur_k
        image_pk(i) = image_p(D_argsort(i));
        V_k(:, i) = V(:, D_argsort(i));
    end
    % reconstructing image
    image_k = V_k * image_pk + mean_image;
    reconstructed_images(:, index) = image_k;
    index = index + 1;
end
end

