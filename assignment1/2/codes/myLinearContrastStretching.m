function [stretched_image] = myLinearContrastStretching(image, mask)
    max_intensity = 255;        % max pixel value
    
    % finding min_intensity
    % If mask is not present, then actual minimum value
    % Otherwise, exclude the masked part. Here, masked part assigned 255
    % effectively excluding it in calculation
    % for max_intensity, image is masked is made zero
    if (isempty(mask))          
        min_element = min(min(image));
        max_element = max(max(image));
    else
        temp_image = image + uint8((1 - mask) * max_intensity);
        min_element = min(min(temp_image));
        max_element = max(max(image .* uint8(mask)));
    end
    
    image = double(image);      % floating point image
    min_element = double(min_element);
    max_element = double(max_element);
    % pixels linearly scaled to get into range [0, 1]
    stretched_image = (image - min_element) ./ (max_element - min_element);
    % linear scaling to get into range [0, 255]
    stretched_image = stretched_image * max_intensity;
    % converting to uint for imshow of RGB image(RBG imshow works only for
    % uint8)
    stretched_image = uint8(stretched_image);
end

