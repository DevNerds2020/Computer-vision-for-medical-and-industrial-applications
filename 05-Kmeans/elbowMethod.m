function elbowMethod(X, kMin, kMax)
    % Initialize an array to store WCSS values
    wcss = zeros(1, kMax - kMin + 1);
    
    % Loop over the range of k values
    for k = kMin:kMax
        % Run k-means clustering
        w = ones(size(X, 1), 1);  % Set all weights to 1
        L = kmeans(X, w, k);
        
        % Calculate the WCSS for the current k
        currentWCSS = 0;
        for j = 1:k
            % Find points in the current cluster
            clusterPoints = X(L == j, :);
            % Calculate cluster center
            clusterCenter = mean(clusterPoints, 1);
            % Sum the squared distances to the cluster center
            currentWCSS = currentWCSS + sum(sum((clusterPoints - clusterCenter).^2));
        end
        % Store the WCSS for this k
        wcss(k - kMin + 1) = currentWCSS;
    end
    
    % Plot WCSS vs. number of clusters
    figure;
    plot(kMin:kMax, wcss, '-o');
    xlabel('Number of Clusters (k)');
    ylabel('Within-Cluster Sum of Squares (WCSS)');
    title('Elbow Method for Optimal k');
    grid on;
end
