% Load MNIST data
load('ShapeContextData.mat'); % Contains train_data, test_data, train_labels, test_labels

% Parameters for Shape Context
nBinsTheta = 12;
nBinsR = 5;
rMin = 0.01; % Minimum distance
rMax = 0.5; % Maximum distance (normalized to image size)

% Select an example digit
img = train_data(:, :, 1); % First training image
label = label_train(1);  % Corresponding label

% Get edge points
edgePoints = getEdgePoints(img, 50); % Extract edge points

% Normalize edge points to [0,1] range
edgePoints = edgePoints / size(img, 1);

% Use the center of the image as P
P = [0.5, 0.5];

% Compute Shape Context descriptor
SC = scComputeMultiplePoints(P, edgePoints, nBinsTheta, nBinsR, rMin, rMax);

% Visualization
figure;

% (a) Display the original image
subplot(1, 3, 1);
imshow(img, []);
title(['Original Image (Label: ', num2str(label), ')']);

% (b) Display the edge points
subplot(1, 3, 2);
scatter(edgePoints(:, 1), edgePoints(:, 2), 'b.');
hold on;
plot(P(1), P(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Mark P
title('Edge Points and Reference P');
axis([0 1 0 1]);
axis equal;

% (c) Display the Shape Context Descriptor
subplot(1, 3, 3);
imagesc(sum(SC, 3)); % Summing over the third dimension to visualize
colormap('hot');
colorbar;
title('Shape Context Descriptor');
xlabel('Theta Bins');
ylabel('Radius Bins');
