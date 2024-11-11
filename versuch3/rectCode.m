% Test Script for Region Growing with Visual Output in Subplots
clc; clear; close all;

% Step 1: Load Image
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Images (*.jpg, *.png, *.bmp)'}, 'Select an image');
if isequal(filename,0)
    disp('No file selected.');
    return;
else
    I = imread(fullfile(pathname, filename));
    % Convert to grayscale if the image is RGB
    if size(I, 3) == 3
        I = rgb2gray(I);
    end
end

% Step 2: Edge Detection
edges = edge(I, 'Canny'); % Perform edge detection using Canny method

% Step 3: Ask for Start Point
figure;
imshow(I); title('Select the Seed Point for Segmentation');
[xStart, yStart] = ginput(1);  % Get seed point from user click
xStart = round(xStart);  % Round to integer
yStart = round(yStart);

% Step 4: Ask for Threshold
threshold = inputdlg('Enter the Threshold Value:', 'Threshold', [1 50]);
threshold = str2double(threshold{1});
if isnan(threshold) || threshold <= 0
    disp('Invalid threshold value entered.');
    return;
end

% Step 5: Perform Region Growing
S = regionGrowing(I, xStart, yStart, threshold, edges); % Pass edges to regionGrowing

% Step 6: Display Results with Subplots
figure;

% (1) Original Image with Seed Point
subplot(2, 2, 1);
imshow(I); title('Original Image with Seed Point');
hold on;
plot(xStart, yStart, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
legend('Seed Point', 'Location', 'best');

% (2) Segmentation Result on Original Image with Contour Overlay
subplot(2, 2, 2);
imshow(I); title('Segmentation Result on Original Image');
hold on;
contour(S, [0.5 0.5], 'r', 'LineWidth', 1.5); % Red contour at the segmentation boundary
plot(xStart, yStart, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
legend('Segmented Region', 'Seed Point', 'Location', 'best');

% (3) Side-by-Side Original and Segmentation Result
subplot(2, 2, 3);
imshowpair(I, S, 'montage'); % Show original and segmented images side by side
title('Original and Segmented Images Side by Side');

% (4) Display Edge Image with Segmentation
subplot(2, 2, 4);
imshow(edges, []); title('Edge Image with Segmentation');
hold on;
contour(S, [0.5 0.5], 'r', 'LineWidth', 1.5); % Red contour at the segmentation boundary
plot(xStart, yStart, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
legend('Segmented Region', 'Seed Point', 'Location', 'best');

% Adjust layout
sgtitle('Region Growing Segmentation Results');

function S = regionGrowing(I, xStart, yStart, threshold, edges)
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
            
            % If not yet segmented and not an edge
            if S(y, x) == 0 && ~edges(y, x)
                % Compute intensity difference
                intensityDiff = abs(double(I(y, x)) - regionMean);
                
                % Check if the neighbor meets the threshold condition
                if intensityDiff <= threshold
                    % Add to region
                    S(y, x) = 1;
                    % Update region mean
                    regionMean = (regionMean * sum(S(:) == 1) + double(I(y, x))) / (sum(S(:) == 1) + 1);
                    % Add this neighbor to available points list
                    apList = [apList; x, y];
                end
            end
        end
    end
end
