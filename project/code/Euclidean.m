function[i, j] = Euclidean(i, j, tx, ty, h)
    [rows, cols, ~] = size(tx);
    [i1, j1] = smooth(i, j, rows, cols);
    i = i  + h* ty(i1, j1);
    j = j  + h* tx(i1, j1);
end