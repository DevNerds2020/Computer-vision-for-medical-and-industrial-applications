function cost = histCost(sc1, sc2)
    % sc1 and sc2 are histograms to compare (e.g., of size [nBinsR, nBinsTheta, n])
    
    % Ensure histograms have the same size
    if ~isequal(size(sc1), size(sc2))
        error('Histograms sc1 and sc2 must have the same size.');
    end
    
    % Initialize cost
    cost = 0;
    
    % Iterate through each bin pair to compute the chi-squared distance
    for i = 1:size(sc1, 1) % Radius bins
        for j = 1:size(sc1, 2) % Theta bins
            % Extract bin values
            p = sc1(i, j);
            q = sc2(i, j);
            
            % Avoid division by zero
            if p + q > 0
                cost = cost + ((p - q)^2) / (p + q);
            end
        end
    end
    
    % Final cost is half the accumulated sum
    cost = 0.5 * cost;
end
