function [V, D_sorted, D_argsort] = getEigVecSVD(centered_train)
%GETEIGVECSVD Summary of this function goes here
%   Detailed explanation goes here
[V, D, temp] = svd(centered_train, 'econ');
D = diag(D.^2);
[D_sorted, D_argsort] = sort(D, 'descend');
end

