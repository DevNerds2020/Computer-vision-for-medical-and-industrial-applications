function S = regionGrowing(I, xStart, yStart, threshold)
    % Initialize the segmentation mask
    S = zeros(size(I));
    % Initialize list of available points and set the initial seed
    apList = [xStart, yStart];
    % Initialize region mean with the seed point intensity
    regionMean = double(I(yStart, xStart));
    % Set initial pixel as part of the region
    S(yStart, xStart) = 1;
    
    % Begin region growing loop
    while ~isempty(apList)
        % Get the next point (FIFO)
        p = apList(1, :);
        apList(1, :) = []; % Remove from list
        % Find neighbors (4-connectivity: left, right, top, bottom)
        neighbors = [p(1)-1, p(2);  % Left
                     p(1)+1, p(2);  % Right
                     p(1), p(2)-1;  % Top
                     p(1), p(2)+1]; % Bottom
                 
        % Check each neighbor
        for i = 1:size(neighbors, 1)
            x = neighbors(i, 1);
            y = neighbors(i, 2);
            
            % Boundary check
            if x < 1 || x > size(I, 2) || y < 1 || y > size(I, 1)
                continue; % Skip out-of-bound neighbors
            end
            
            % If not yet segmented
            if S(y, x) == 0
                % Compute intensity difference
                intensityDiff = abs(double(I(y, x)) - regionMean);
                
                % Check if the neighbor meets the threshold condition
                if intensityDiff <= threshold
                    % Update region mean
                    regionMean = (regionMean * sum(S(:) == 1) + double(I(y, x))) / (sum(S(:) == 1) + 1);
                    % Add to region
                    S(y, x) = 1;
                    % Add this neighbor to available points list
                    apList = [apList; x, y];
                end
            end
        end
    end
end
