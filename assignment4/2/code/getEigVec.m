function [V, D_sorted, D_argsort] = getEigVec(centered_train)
% calculation of eigen-values/vectors from mean centered dataset
% Takes 2d input mean-centered image (X) - each column representing an image
[V_t, D] = eig(transpose(centered_train) * centered_train); % eig((X^T)X) instead of eig(X(X^T))
D = diag(D);                                    % eigenvalues
[D_sorted, D_argsort] = sort(D, 'descend');     % sorting eigenvalues
V = centered_train * V_t;                       % calculating eigenvectors of X(X^T)
V = V ./ sqrt(sum(V.^2, 1));
end

