function cdf = getCdf(image2d)
    histogram = imhist(image2d);
    cdf = cumsum(histogram) / sum(histogram);    
end

