function [Tx, Ty] = ETF(image, iterations, ws)
    % image      -> grayscale image
    % iterations -> no. of iterations to run ETF for
    % ws         -> kernel parameter (window size)
    % Tx         -> normalized x coeff of tangent vector field
    % Ty         -> normalized y coeff of tangent vector field
    [rows, cols, ~] = size(image);
    
    %Calculation of T0 (perpendicular to gradient anticlockwise)
    [Gx,Gy] = imgradientxy(image);
    Tx = -Gy;
    Ty = Gx;
    
    %Magnitude at each pixel remains same for all iterations
    Gmag = sqrt(Gx.*Gx + Gy.*Gy);
    Gmag = (Gmag - min(min(Gmag))) / (max(max(Gmag)) - min(min(Gmag)));
    
    new_Tx = Tx;
    new_Ty = Ty;
    
    for x=1:iterations
        
        %Normalize the tangent vectors
        Tmag = sqrt(Tx.*Tx + Ty.*Ty);  
        Tmag(Tmag == 0) = 1;
        Tx = Tx./Tmag;
        Ty = Ty./Tmag;

        for i=1:rows
            for j=1:cols
                %Window parameters
                l = max(1,j-ws);
                r = min(cols,j+ws);
                u = max(1,i-ws);
                d = min(rows,i+ws);
                
                %Tangent window
                w_tx = Tx(u:d, l:r);
                w_ty = Ty(u:d, l:r);
                
                %Calculation of w_magnitude
                wm = (tanh(Gmag(u:d, l:r) - Gmag(i,j)) + 1)/2;
                
                %Calculation of w_dot product
                wd = w_ty .* Ty(i, j) + w_tx .* Tx(i, j);
                
                %Calculation of w_box spacial (circular)
                [z,y] = meshgrid(l:r, u:d);
                wsp = (z-j).*(z-j) + (y-i).*(y-i) < ws*ws;
                
                %Creating next tangent vector
                new_Tx(i,j)  = sum(sum(w_tx .* wm .* wd .* wsp));
                new_Ty(i,j)  = sum(sum(w_ty .* wm .* wd .* wsp));
            end
        end
        
        Tx = new_Tx;
        Ty = new_Ty;
    end
    
    %Final normalization of tangents
    Tmag = sqrt(Tx.*Tx + Ty.*Ty);  
    Tmag(Tmag == 0) = 1;
    Tx = Tx./Tmag;
    Ty = Ty./Tmag;

end

