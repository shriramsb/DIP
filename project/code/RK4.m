function[x, y] = RK4(i, j, tx, ty, h)
    [rows, cols, ~] = size(tx);
    f = @(z) [ty(z(1), z(2)), tx(z(1), z(2))];
    clip = @(z) [round(max(1, min(rows, z(1)))), round(max(1, min(cols, z(2))))];
    
    pt = [i,j];
    k1 = f(clip(pt));
    
    tmp = pt + 0.5 * h * k1;
    k2 = f(clip(tmp));
    
    tmp = [i,j] + 0.5 * h * k2;
    k3 = f(clip(tmp));
    
    tmp = [i,j] + h * k3;
    k4 = f(clip(tmp));
    
    out = [i,j] + (1/6)*(k1 + 2*k2 + 2*k3 + k4)*h; 
    x = out(1);
    y = out(2);
end