function [new_final] = LIC(tx, ty, d)
    % Line integral convolution of 2d vector field given by tx and ty (with
    % streamline lengths d
    
    [rows, cols, ~] = size(tx);
    % White (Uniform) noise
    white_noise = randi(255, rows, cols);
    
    % 1D gauss filter
    x = linspace(-d+1, d-1, 2*d-1);
    gaussFilter = exp(-x .^ 2 / (2 * ((d/3) ^ 2)));
    gaussFilter = gaussFilter / sum (gaussFilter);
    
    final = white_noise;
    new_final = final;
    k = 5;
    for z=1:k
        final = new_final;
        for i=1:rows
            for j=1:cols
                % Get streamline at i,j in noise
                l = streamline(i, j, tx, ty, d, white_noise);
                % Line Integral convolution step
                final(i,j) = sum(gaussFilter.* l);
            end
        end
        new_final = final;
    end
end
  