function L = kmeansUpdated(X, w, k, maxIterations, numRestarts)
    % X = n x d matrix of data points
    % w = n x 1 vector of weights
    % k = number of clusters
    % maxIterations = maximum number of iterations to run
    % numRestarts = number of random restarts
    
    % Number of data points (n) and dimensions (d)
    [n, d] = size(X);
    
    % Initialize variables to track the best solution
    bestVariance = inf;
    bestLabels = [];
    bestCenters = [];
    
    % Repeat the process for multiple restarts
    for restart = 1:numRestarts
        % Step 1: Initialize k random cluster centers from the data points
        idx = randperm(n, k);  % Random indices for initial cluster centers
        cj = X(idx, :);        % Initial cluster centers
        
        % Initialize the labels for each data point
        L = zeros(n, 1);
        
        % Run the algorithm for maxIterations iterations
        for iter = 1:maxIterations
            % Store the old cluster centers to check changes
            cj_old = cj;
            
            % Step 4: Assign each data point to the closest cluster center
            for i = 1:n
                % Calculate the distance from the data point to each cluster center
                distances = vecnorm(X(i, :) - cj, 2, 2);
                
                % Find the index of the closest cluster center
                [~, L(i)] = min(distances);
            end
            
            % Step 5: Update the cluster centers based on the weighted average of points
            for j = 1:k
                % Find the indices of the points assigned to cluster j
                cluster_points = X(L == j, :);
                cluster_weights = w(L == j);
                
                if ~isempty(cluster_points)
                    % Calculate the new cluster center as the weighted average of the points
                    cj(j, :) = sum(cluster_weights .* cluster_points) / sum(cluster_weights);
                end
            end
            
            % Check for convergence by comparing the old and new cluster centers
            if all(all(abs(cj - cj_old) < 1e-6))
                break;  % Stop if centers have converged
            end
        end
        
        % Calculate the total variance (sum of squared distances from points to their cluster centers)
        totalVariance = 0;
        for i = 1:n
            totalVariance = totalVariance + norm(X(i, :) - cj(L(i), :))^2;
        end
        
        % If this run has a lower variance, save the results
        if totalVariance < bestVariance
            bestVariance = totalVariance;
            bestLabels = L;
            bestCenters = cj;
        end
    end
    
    % Return the best labels and centers from the run with the lowest variance
    L = bestLabels;
end
