function [line, sm] = streamline(x, y, tx, ty, d, img)
    % x, y   -> coorinate of middle point of streamline x - row no.
    % tx, ty -> tangent vector field for streamline
    % d      -> length of streamline
    % img    -> pixels of image to get along this streamline
    % line   -> 1 (or 3) X 2d - 1 vector of pixel values along the streamline given
    %           by tx, ty
    
    [rows, cols, ~] = size(img);
    
    % line -> contains image pixels for sm coordinates
    line = zeros(size(img, 3),2*d-1);
    % sm -> contains coordiantes along the streamline (for debugging)
    sm = zeros(2, 2*d-1);
    line(:, d) = img(x, y, :);
    sm(1, d) = x;
    sm(2, d) = y;
    % Step size in RK4 or Euclidean
    h = 1.4;
   
    r = x;
    c = y;
    new_r = r; new_c = c;
    old_r = r; old_c = c;
    dir = 1;
    for i=1:d-1
        if (tx(old_r, old_c) * tx(new_r, new_c) + ty(old_r, old_c) * ty(new_r, new_c) < 0)
               dir = -dir;
        end
        [r, c] = Euclidean(r, c, tx, ty, dir * h);
        [r1, c1] = smooth(r, c, rows, cols);

        old_r = new_r; old_c = new_c;
        new_r = r1; new_c = c1;
        
        line(d+i) = img(r1, c1);
        sm(1, d+i) = r1;
        sm(2, d+i) = c1; 
    end
    
    r = x;
    c = y;
    new_r = r; new_c = c;
    old_r = r; old_c = c;
    dir = -1;
    for i=1:d-1
        if (tx(old_r, old_c) * tx(new_r, new_c) + ty(old_r, old_c) * ty(new_r, new_c) < 0)
               dir = -dir;
        end
        [r, c] = Euclidean(r, c, tx, ty, dir * h);
        [r1, c1] = smooth(r, c, rows, cols);

        old_r = new_r; old_c = new_c;
        new_r = r1; new_c = c1;
        
        line(d-i) = img(r1, c1);
        sm(1, d-i) = r1;
        sm(2, d-i) = c1; 
    end
    
    %{
    r = x;
    c = y;
    for i=1:d-1
        % get the next position along streamline
        [r, c] = Euclidean(r, c, tx, ty, h);
        % clip and round if necessary
        [r1, c1] = smooth(r, c, rows, cols);
        %assign to streamline
        line(:, d+i) = img(r1, c1, :);
        sm(1, d+i) = r1;
        sm(2, d+i) = c1; 
    end
       
    
    % Same as above but for negative steps
    r = x;
    c = y;
    for i=1:d-1
        [r, c] = Euclidean(r, c, tx, ty, -h);
        [r1, c1] = smooth(r, c, rows, cols);
        line(:, d-i) = img(r1, c1, :);
        sm(1, d-i) = r1;
        sm(2, d-i) = c1;
    end
    %}
end

