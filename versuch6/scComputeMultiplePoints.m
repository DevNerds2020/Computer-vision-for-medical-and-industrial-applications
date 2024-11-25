function SC = scComputeMultiplePoints(P, X, nBinsTheta, nBinsR, rMin, rMax)
    % Computes Shape Context descriptors for every point in P based on points in X.
    % P: points to compute Shape Context for (Nx2)
    % X: reference points for the Shape Context (Mx2)
    % nBinsTheta: number of angular bins
    % nBinsR: number of radial bins
    % rMin, rMax: minimum and maximum radius for bins
    
    N = size(P, 1);  % Number of points in P
    SC = zeros(N, nBinsR, nBinsTheta); % Initialize descriptor array
    
    for i = 1:N
        % Compute relative positions
        dx = X(:, 1) - P(i, 1);
        dy = X(:, 2) - P(i, 2);
        distances = sqrt(dx.^2 + dy.^2);
        angles = atan2(dy, dx);
        
        % Normalize angles to [0, 2*pi)
        angles(angles < 0) = angles(angles < 0) + 2 * pi;
        
        % Ensure that distances are within the range [rMin, rMax]
        distances(distances < rMin) = rMin; % Enforce minimum distance
        distances(distances > rMax) = rMax; % Enforce maximum distance

        % Compute radial bins using logarithmic scale
        binR = ceil(nBinsR * (log(distances / rMin) / log(rMax / rMin)));
        binR(binR > nBinsR) = nBinsR;  % Ensure radial bins do not exceed max bin number
        
        % Compute angular bins
        binTheta = ceil(nBinsTheta * (angles / (2 * pi)));
        binTheta(binTheta > nBinsTheta) = nBinsTheta;  % Ensure angular bins do not exceed max bin number
        
        % Accumulate histogram
        for j = 1:numel(binR)
            if binR(j) > 0 && binR(j) <= nBinsR && binTheta(j) > 0 && binTheta(j) <= nBinsTheta
                SC(i, binR(j), binTheta(j)) = SC(i, binR(j), binTheta(j)) + 1;
            end
        end
    end
end
