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

% Step 2: Ask for Start Point
figure;
imshow(I); title('Select the Seed Point for Segmentation');
[xStart, yStart] = ginput(1);  % Get seed point from user click
xStart = round(xStart);  % Round to integer
yStart = round(yStart);

% Step 3: Ask for Threshold
threshold = inputdlg('Enter the Threshold Value:', 'Threshold', [1 50]);
threshold = str2double(threshold{1});
if isnan(threshold) || threshold <= 0
    disp('Invalid threshold value entered.');
    return;
end

% Step 4: Perform Region Growing
S = regionGrowing(I, xStart, yStart, threshold);

% Step 5: Display Results with Subplots
figure;

% (1) Original Image with Seed Point
subplot(2, 2, 1);
imshow(I); title('Original Image with Seed Point');
hold on;
plot(xStart, yStart, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
legend('Seed Point');

% (2) Segmentation Result on Original Image with Contour Overlay
subplot(2, 2, 2);
imshow(I); title('Segmentation Result on Original Image');
hold on;
contour(S, [0.5 0.5], 'r', 'LineWidth', 1.5); % Red contour at the segmentation boundary
plot(xStart, yStart, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
legend('Segmented Region', 'Seed Point');

% (3) Side-by-Side Original and Segmentation Result
subplot(2, 2, 3);
imshowpair(I, S, 'montage'); % Show original and segmented images side by side
title('Original and Segmented Images Side by Side');

% (4) Gradient Image Example with Segmentation
%gradientImage = repmat(linspace(0, 255, size(I, 2)), size(I, 1), 1);
%subplot(2, 2, 4);
%imshow(gradientImage, []); title('Gradient Example with Segmentation');
%hold on;
% Run region growing on the gradient image (same threshold for demonstration)
%S_gradient = regionGrowing(gradientImage, xStart, yStart, threshold);
%contour(S_gradient, [0.5 0.5], 'r', 'LineWidth', 1.5); % Red contour at the segmentation boundary
%plot(xStart, yStart, 'rx', 'MarkerSize', 10, 'LineWidth', 2);

% Calculate and display the final region mean on the gradient example
%regionMean = mean(gradientImage(S_gradient == 1), 'all');
%text(size(gradientImage, 2) - 50, 20, sprintf('Mean Intensity: %.2f', regionMean), ...
%    'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
%legend('Segmented Region', 'Seed Point');

% Adjust layout
sgtitle('Region Growing Segmentation Results');
