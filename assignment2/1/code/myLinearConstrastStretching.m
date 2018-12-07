function [img, stretched_img] = myLinearConstrastStretching(img)
%MYLINEARCONSTRASTSTRETCHING Summary of this function goes here
%   Detailed explan.ation goes here
    img = double(img);
    stretched_img = (img - min(min(img))) / (max(max(img)) - min(min(img)));
    
end

