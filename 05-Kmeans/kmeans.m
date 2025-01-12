function L = kmeans(X, w, k)
    % X = n x d matrix of data points
    % w = n x 1 vector of weights
    % k = number of clusters
    
    % Number of data points (n) and dimensions (d)
    [n, d] = size(X);
    disp(d);
    
    % Step 1: Initialize k random cluster centers from the data points
    idx = randperm(n, k);  % Random indices for initial cluster centers
    cj = X(idx, :);        % Initial cluster centers
    
    % Initialize the labels for each data point (to store the cluster assignments)
    L = zeros(n, 1);
    
    % Initialize a variable to check if the cluster centers have converged
    converged = false;
    
    % Step 2: Repeat the assignment and update steps until convergence
    while ~converged
        % Step 3: Store old cluster centers to check convergence later
        cj_old = cj;
        
        % Step 4: Assign each data point to the closest cluster center
        for i = 1:n
            % Calculate the distance from the data point to each cluster center
            distances = vecnorm(X(i, :) - cj, 2, 2);
            
            % Find the index of the closest cluster center
            [~, L(i)] = min(distances);
        end
        
        % Step 5: Update the cluster centers based on the weighted average of the points assigned to each cluster
        for j = 1:k
            % Find the indices of the points assigned to cluster j
            cluster_points = X(L == j, :);
            cluster_weights = w(L == j);
            
            if ~isempty(cluster_points)
                % Calculate the new cluster center as the weighted average of the points
                cj(j, :) = sum(cluster_weights .* cluster_points) / sum(cluster_weights);
            end
        end
        
        % Step 6: Check if the cluster centers have converged
        if all(all(abs(cj - cj_old) < 1e-6))
            converged = true;
        end
    end
end
