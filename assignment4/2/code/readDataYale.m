function [data] = readDataYale(file_path, num_img_per_person, num_persons)
%READDATAYALE Summary of this function goes here
%   Detailed explanation goes here
yale_dir = dir(file_path);
for person = 1 : num_persons
    person_dir = dir(strcat(file_path, string(yale_dir(person + 2).name), "/*.pgm"));
    for img = 1 : num_img_per_person
        if (person == 1 && img == 1)
            t = imread(char(strcat(file_path, string(yale_dir(person + 2).name), "/", string(person_dir(img).name))));
            data = zeros(size(t, 1), size(t, 2), num_img_per_person, num_persons);
            data(:, :, img, person) = t;
        else
            data(:, :, img, person) = imread(char(strcat(file_path, string(yale_dir(person + 2).name), "/", string(person_dir(img).name))));
        end
    end
end
data = double(data);
end

