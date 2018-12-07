function [error, FP, FN] = getBinaryAccuracy(min_dist, labels, threshold)

    FP = 0;
    FN = 0;
    P = 0;
    N = 0;
    for i = 1 : size(min_dist, 1)
        if (min_dist(i) >= threshold)
            cur_pred = 0;
        else
            cur_pred = 1;
        end
        if (labels(i) == 1)
            P = P + 1;
            if (cur_pred == 0)
                FN = FN + 1;
            end
        end
        if (labels(i) == 0)
            N = N + 1;
            if (cur_pred == 1)
                FP = FP + 1;
            end
        end
    end
    error = 1.0 * FP / N + 1.0 * FN / P;
end

