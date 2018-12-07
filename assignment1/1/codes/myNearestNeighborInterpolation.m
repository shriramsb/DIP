function outputImage = myNearestNeighborInterpolation(inputImage)
%MYNEARESTNEIGHBORINTERPOLATION Nearest Neighbor interpolation for image

inputImage = im2double(inputImage);
[M, N] = size(inputImage);
output_M = 3*M-2;
output_N = 2*N-1;
scale_M = (output_M-1)/(M-1);
scale_N = (output_N-1)/(N-1);

outputImage = zeros(output_M, output_N);

%Iterate over every output pixel, map it to input image pixel to perform
%nearest neighbor interpolation using the formula
for x = 1:output_M
    for y = 1:output_N
        org_x = (x - 1)/scale_M + 1;
        org_y = (y - 1)/scale_N + 1;
        near_x = floor(org_x);
        near_y = floor(org_y);
                    
        if (org_x - near_x > 0.5)
            near_x = near_x + 1;
        end
        
        if (org_y - near_y > 0.5)
            near_y = near_y + 1;
        end
        
        outputImage(x,y) = inputImage(near_x, near_y);
        
    end
end        
end

