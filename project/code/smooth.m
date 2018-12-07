function [r, c] = smooth(r, c, rows, cols)
    r = round(max(1, min(rows, r)));
    c = round(max(1, min(cols, c)));
end