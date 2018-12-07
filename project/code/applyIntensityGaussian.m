function [weights] = applyIntensityGaussian(l ,ref, r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
weights = zeros(1, size(l, 2));
ref1 = zeros(size(ref, 3), 1);
for i = 1 : size(ref, 3)
    ref1(i) = ref(1, 1, i);
end
ref = ref1;
for i = 1 : size(l, 2)
    weights(i) = exp(-sum((l(:, i) - ref).^2) ./ (2 * r.^2));
end

