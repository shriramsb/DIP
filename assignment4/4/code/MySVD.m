function [U,V,S] = MySVD(A)

% Eigen vectors of A X A^t form the matrix V
[V, RS] = eig(A'*A);

% Eigen values for the above form the singular values in S	
RS = sqrt(RS);
[~,ind] = sort(diag(RS), 'descend');
S = RS(ind,ind);
V = V(:, ind);

% Since V is orthonormal U = A * V * S^-1	
U = A*V*pinv(S);

end