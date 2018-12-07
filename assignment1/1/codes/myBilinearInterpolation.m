function outputImage = myBilinearInterpolation(inputImage)
%MYBILINEARINTERPOLATION Bilinear interpolation for image

inputImage = im2double(inputImage);
[M, N] = size(inputImage);
output_M = 3*M-2;
output_N = 2*N-1;
scale_M = (output_M-1)/(M-1);
scale_N = (output_N-1)/(N-1);

%Appending a row and a column of zeros to the inputImage
inputImage = [inputImage zeros(M,1)];
inputImage = [inputImage; zeros(1, N+1)];

outputImage = zeros(output_M, output_N);

%Iterate over every output pixel, map it to input image pixel to perform
%bilinear interpolation using the formula
for x = 1:output_M
    for y = 1:output_N
        org_x = (x - 1)/scale_M + 1;
        org_y = (y - 1)/scale_N + 1;
        x1 = floor(org_x);
        y1 = floor(org_y);
        x2 = x1 + 1;
        y2 = y1 + 1;
        
        outputImage(x,y) = inputImage(x1,y1) * (x2 - org_x) * (y2-org_y) ...
                         + inputImage(x1,y2) * (x2 - org_x) * (org_y-y1) ...
                         + inputImage(x2,y1) * (org_x - x1) * (y2-org_y) ...
                         + inputImage(x2,y2) * (org_x-x1) * (org_y-y1);
        
    end
end        
end

