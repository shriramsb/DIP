function [data] = readData(file_path, num_img_per_person, num_persons)
%READDATA Summary of this function goes here
%   Detailed explanation goes here
for person = 1 : num_persons
    cur_dir = dir(strcat(file_path, "s", string(person), "/*.pgm"));
    for img = 1 : num_img_per_person
        if (person == 1 && img == 1)
            t = imread(char(strcat(file_path, "s", string(person), "/", cur_dir(img).name)));
            data = zeros(size(t, 1), size(t, 2), num_img_per_person, num_persons);
            data(:, :, img, person) = t;
        else
            data(:, :, img, person) = imread(char(strcat(file_path, "/s", string(person), "/", cur_dir(img).name)));
        end
    end
end
data = double(data);
end

