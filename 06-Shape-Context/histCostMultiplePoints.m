function cost = histCostMultiplePoints(SC1, SC2)
    % histCostMultiplePoints - Compute chi-squared distance between two Shape Context descriptors
    %
    % Inputs:
    %   SC1 - Shape Context descriptors of first set of points (N1 x nBinsR x nBinsTheta)
    %   SC2 - Shape Context descriptors of second set of points (N2 x nBinsR x nBinsTheta)
    %
    % Output:
    %   cost - Total chi-squared cost between the two sets

    [N1, nBinsR, nBinsTheta] = size(SC1);
    [N2, ~, ~] = size(SC2);
    
    % Ensure the number of bins matches
    if nBinsR ~= size(SC2, 2) || nBinsTheta ~= size(SC2, 3)
        error('Dimension mismatch: Shape Context histograms do not have the same bin structure.');
    end

    % Initialize cost matrix
    chi2Mat = zeros(N1, N2);

    % Compute chi-squared cost for all point pairs
    for i = 1:N1
        for j = 1:N2
            h1 = reshape(SC1(i, :, :), [nBinsR, nBinsTheta]);
            h2 = reshape(SC2(j, :, :), [nBinsR, nBinsTheta]);

            % Compute chi-squared distance
            chi2Mat(i, j) = 0.5 * sum(sum((h1 - h2).^2 ./ (h1 + h2 + eps)));
        end
    end

    % Compute total cost (sum of minimum costs)
    cost = sum(min(chi2Mat, [], 2)); % Match each point in SC1 to its best match in SC2
end
