function p = TDLS(M, xStart, yStart, w)
    % Block Matching (Two Dimensional Logarithmic Search)
    %
    % Input: M - Video, (m x n x 3 x t)-Array
    %        xStart, yStart - Start point
    %        w - Window size
    %
    % Output: p - (2 x t)-Array, tracked path.
    
    % Get the size of the video
    [height, width, ~, numFrames] = size(M);
    
    % Initialize the path array
    p = zeros(2, numFrames);
    p(:, 1) = [xStart; yStart];
    
    % Iterate over each frame
    for t = 2:numFrames
        % Current point from the previous frame
        x = p(1, t - 1);
        y = p(2, t - 1);
        
        % Initialize the step size
        stepSize = 8;
        
        % Search iteratively
        while stepSize >= 1
            % Define candidate positions
            candidates = [
                0, 0;                  % Current block
                stepSize, 0;           % Right
                -stepSize, 0;          % Left
                0, stepSize;           % Down
                0, -stepSize           % Up
            ];
            
            % Compute SSD for each candidate
            bestSSD = inf;
            bestOffset = [0, 0];
            for i = 1:size(candidates, 1)
                % Get candidate coordinates
                dx = candidates(i, 1);
                dy = candidates(i, 2);
                newX = x + dx;
                newY = y + dy;
                
                % Check bounds
                if newX - w < 1 || newX + w > width || ...
                   newY - w < 1 || newY + w > height
                    continue;
                end
                
                % Compute SSD
                SSD = sum(sum(sum( ...
                    (M(newY-w:newY+w, newX-w:newX+w, :, t-1) - ...
                     M(newY-w:newY+w, newX-w:newX+w, :, t)).^2)));
                 
                % Update best match
                if SSD < bestSSD
                    bestSSD = SSD;
                    bestOffset = [dx, dy];
                end
            end
            
            % Update position
            x = x + bestOffset(1);
            y = y + bestOffset(2);
            
            % If no movement, halve step size
            if bestOffset(1) == 0 && bestOffset(2) == 0
                stepSize = floor(stepSize / 2);
            end
        end
        
        % Perform fine search (neighboring blocks)
        bestSSD = inf;
        for dx = -1:1
            for dy = -1:1
                newX = x + dx;
                newY = y + dy;
                
                % Check bounds
                if newX - w < 1 || newX + w > width || ...
                   newY - w < 1 || newY + w > height
                    continue;
                end
                
                % Compute SSD
                SSD = sum(sum(sum( ...
                    (M(newY-w:newY+w, newX-w:newX+w, :, t-1) - ...
                     M(newY-w:newY+w, newX-w:newX+w, :, t)).^2)));
                 
                % Update best match
                if SSD < bestSSD
                    bestSSD = SSD;
                    x = newX;
                    y = newY;
                end
            end
        end
        
        % Save position in path
        p(:, t) = [x; y];
    end
end
