% Load MNIST data
load('ShapeContextData.mat'); % Contains train_data, test_data, train_labels, test_labels

% Parameters for Shape Context
nBinsTheta = 12; % Number of angular bins
nBinsR = 5;      % Number of radial bins
rMin = 0.01;     % Minimum radius (distance)
rMax = 0.5;      % Maximum radius (normalized to image size)

% Select two example digits
img1 = train_data(:, :, 1); % First training image
img2 = train_data(:, :, 2); % Second training image

% Extract corresponding labels (optional for display)
label1 = label_train(1);  
label2 = label_train(2);

% Get edge points for the two images
edgePoints1 = getEdgePoints(img1, 50); % Extract 50 edge points
edgePoints2 = getEdgePoints(img2, 50); % Extract 50 edge points

% Normalize edge points to [0,1] range
edgePoints1 = edgePoints1 / size(img1, 1);
edgePoints2 = edgePoints2 / size(img2, 1);

% Compute Shape Context descriptors for both images
SC1 = scCompute(edgePoints1, edgePoints1, nBinsTheta, nBinsR, rMin, rMax);
SC2 = scCompute(edgePoints2, edgePoints2, nBinsTheta, nBinsR, rMin, rMax);

% Compute histogram similarity (chi-squared distance)
distance = histCost(SC1, SC2);

% Visualization
figure;

% (a) Display the original images
subplot(2, 3, 1);
imshow(img1, []);
title(['Image 1 (Label: ', num2str(label1), ')']);

subplot(2, 3, 4);
imshow(img2, []);
title(['Image 2 (Label: ', num2str(label2), ')']);

% (b) Display the edge points and Shape Context bins
subplot(2, 3, 2);
scatter(edgePoints1(:, 1), edgePoints1(:, 2), 'b.');
title('Edge Points (Image 1)');
axis([0 1 0 1]);
axis equal;

subplot(2, 3, 5);
scatter(edgePoints2(:, 1), edgePoints2(:, 2), 'b.');
title('Edge Points (Image 2)');
axis([0 1 0 1]);
axis equal;

% (c) Display Shape Context histograms
subplot(2, 3, 3);
imagesc(sum(SC1, 3)); % Summing over the third dimension to visualize
colormap('hot');
colorbar;
title('Shape Context (Image 1)');
xlabel('Theta Bins');
ylabel('Radius Bins');

subplot(2, 3, 6);
imagesc(sum(SC2, 3)); % Summing over the third dimension to visualize
colormap('hot');
colorbar;
title('Shape Context (Image 2)');
xlabel('Theta Bins');
ylabel('Radius Bins');

% Display the computed distance
sgtitle(['Chi-Squared Distance: ', num2str(distance)]);
