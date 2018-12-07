function [line,pts] = gradline(i, j, grad, d, img)
% Returns intensities and coordinates of points along grad in img centered
% at x, y

    [rows, cols, ~] = size(img);
    
    % line -> contains image pixels along gradline coordinates
    line = zeros(size(img, 3),2*d-1);
    % pts -> contains coordiantes along the gradline (for debugging) -
    % format pts(1, : ) - row coord and other - col coord
    pts = zeros(2, 2*d-1);
    
    line(:, d) = img(i, j, :);
    pts(1, d) = i;
    pts(2, d) = j;
    h = 1;
    
    xt = j;
    yt = i;
    for k=1:d-1
        % get the next position along streamline
        xt = xt + h * grad(1);
        yt = yt + h * grad(2);
        % clip and round if necessary
        [ytd, xtd] = smooth(yt, xt, rows, cols);
        %assign to streamline
        line(:, d+k) = img(ytd, xtd, :);
        sm(1, d+k) = ytd;
        sm(2, d+k) = xtd; 
    end
    
    % Same as above but for negative steps
    xt = j;
    yt = i;
    h = -1;
    for k=1:d-1
        % get the next position along streamline
        xt = xt + h * grad(1);
        yt = yt + h * grad(2);
        % clip and round if necessary
        [ytd, xtd] = smooth(yt, xt, rows, cols);
        %assign to streamline
        line(:, d-k) = img(ytd, xtd, :);
        sm(1, d-k) = ytd;
        sm(2, d-k) = xtd; 
    end
end

