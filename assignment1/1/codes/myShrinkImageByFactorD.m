function outputImage = myShrinkImageByFactorD(inputImage,d)
%myShrinkImageByFactorD Shrinks image by sampling at a factor of d
% Picking pixel values at every dth index using 1:d:end
outputImage = inputImage(1:d:end, 1:d:end);
end

