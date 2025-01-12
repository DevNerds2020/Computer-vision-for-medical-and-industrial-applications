%%
clc; clear; close all;
%% Bestimme ("ideale") Zellmaske

% Beispielbilder laden und als (dreidimensionale) Matrix abspeichern
dir = './Good/';
n_img = 150;

pos_images = [];
for im = 1:n_img
    filename = cat(2, dir, 'Good', num2str(im), '.bmp');
    if exist(filename, 'file')
        pos_images = cat(3, pos_images, im2double(imread(filename)));
    end
end

% Bestimmung einer "durchschnittlichen" Zelle aus den Beispielbildern
% Hinweis: imadjust kann den Kontrast in diesem Bild verbessern
avg_cell = mean(pos_images, 3);  % Average cell calculation
avg_cell = imadjust(avg_cell);   % Contrast adjustment

% Display average cell to help define the cell mask
imshow(avg_cell);
title('Average Cell');

level_nucleus = graythresh(avg_cell);  % Otsu's method for nucleus threshold
level_wall = level_nucleus * 0.7;      % Adjusted threshold for cell wall

cell_mask = zeros(size(avg_cell));
cell_mask(avg_cell > level_nucleus) = 1; % Nucleus
cell_mask((avg_cell > level_wall) & (avg_cell <= level_nucleus)) = -1; % Cell wall

% Display the cell mask (optional)
figure;
imshow(cell_mask, []);
title('Cell Mask');

%% Bestimmung der Verteilungsfunktionen
%  Als Merkmal wird die Differenz des mittleren Grauwerts von Zellkern und
%  Zellwand verwendet. Es wird die Annahme getroffen dieses Merkmal ist
%  normalverteilt.

% Merkmal für die positiven Beispiele bestimmen, d.h. in jedem Beispielbild
% wird der Mittelwert im Bereich des Zellkerns und der Zellwand bestimmt
% und abschließend voneinander abgezogen.
% Die entsprechenden Bereiche sind durch die definierte Zellmaske gegeben.

feature_pos = [];  % Initialize array to store feature values

for it = 1:size(pos_images, 3)
    im = pos_images(:, :, it);

    % Calculate mean grayscale value for nucleus and wall based on mask
    nucleus_mean = mean(im(cell_mask == 1));
    wall_mean = mean(im(cell_mask == -1));
    feature_pos = [feature_pos; nucleus_mean - wall_mean]; % Difference as feature
end

% Bestimme Mittelwert und Varianz der postiven Beispiele
mean_pos = mean(feature_pos);  % Mean of positive examples
var_pos = var(feature_pos);    % Variance of positive examples

% Merkmal für die negativen Beispiele bestimmen.
dir = './Bad/';
n_img = 460;

neg_images = [];
for im = 1:n_img
    filename = cat(2, dir, 'Bad', num2str(im), '.bmp');
    if exist(filename, 'file')
        neg_images = cat(3, neg_images, im2double(imread(filename)));
    end
end

feature_neg = [];  % Initialize array to store feature values for negative samples

for it = 1:size(neg_images, 3)
    im = neg_images(:, :, it);

    % Calculate mean grayscale value for nucleus and wall based on mask
    nucleus_mean = mean(im(cell_mask == 1));
    wall_mean = mean(im(cell_mask == -1));
    feature_neg = [feature_neg; nucleus_mean - wall_mean]; % Difference as feature
end

% Bestimme Mittelwert und Varianz der negativen Beispiele
mean_neg = mean(feature_neg);  % Mean of negative examples
var_neg = var(feature_neg);    % Variance of negative examples

%% Schwellwert für die Klassifikation bestimmen

% Verteilungen (positive und negative Beispiele) plotten
figure;
histogram(feature_pos, 'Normalization', 'pdf', 'DisplayName', 'Positive Samples');
hold on;
histogram(feature_neg, 'Normalization', 'pdf', 'DisplayName', 'Negative Samples');
title('Feature Distribution of Positive and Negative Samples');
xlabel('Mean Difference (Nucleus - Wall)');
ylabel('Probability Density');
legend;

% Schwellwert bestimmen, der eine (optimale) Trennung zwischen Zelle und
% Hintergrund auf der Basis des Merkmals angibt und im Plot markieren
threshold = (mean_pos + mean_neg) / 2;

%% Bild(ausschnitte) klassifizieren und gefundene Zellen markieren

% Testbild laden
%%
img = im2double(rgb2gray(imread('CellDetectPreFreeze.jpg')));
%%
img = im2double(rgb2gray(imread('CellDetectFreeze.jpg')));
%%
img = im2double(rgb2gray(imread('CellDetectPostFreeze.jpg')));
%%

% Bild mit einem "Sliding Window" absuchen und Zellen über die Differenz des
% mittleren Grauwerts der maskierten Zellbestandteile und den Schwellwert detektieren.
% Zur Beschleunigung ist es ausreichend, das Fenster in 5er-Schritten weiterzuschieben.

window_size = size(cell_mask);  % Assuming cell mask is 101x101 pixels
step_size = 9;  % Window step size for sliding

detected_cells = zeros(size(img));  % Initialize detected cells image

for row = 1:step_size:size(img, 1) - window_size(1) + 1
    for col = 1:step_size:size(img, 2) - window_size(2) + 1
        window = img(row:row + window_size(1) - 1, col:col + window_size(2) - 1);
        
        % Calculate feature for the current window
        nucleus_mean = mean(window(cell_mask == 1));
        wall_mean = mean(window(cell_mask == -1));
        feature_value = nucleus_mean - wall_mean;

        % Detect cell if feature value exceeds threshold
        if feature_value >= threshold
            detected_cells(row + round(window_size(1) / 2), col + round(window_size(2) / 2)) = 1;  % Mark detected cell at center of window
        end
    end
end

% Bild und gefundene Zellen darstellen
figure;
imshow(img);
hold on;
[y, x] = find(detected_cells == 1);
plot(x, y, 'r.', 'MarkerSize', 10);
title('Detected Cells');

%%
%% Add Mean Shift to Cluster Detected Cells

% Sliding window detection process
window_size = size(cell_mask);  % Assuming cell mask is 101x101 pixels
step_size = 9;  % Window step size for sliding

detected_cells = zeros(size(img));  % Initialize detected cells image
detected_centers = [];  % Array to store coordinates of detected cell centers

for row = 1:step_size:size(img, 1) - window_size(1) + 1
    for col = 1:step_size:size(img, 2) - window_size(2) + 1
        window = img(row:row + window_size(1) - 1, col:col + window_size(2) - 1);
        
        % Calculate feature for the current window
        nucleus_mean = mean(window(cell_mask == 1));
        wall_mean = mean(window(cell_mask == -1));
        feature_value = nucleus_mean - wall_mean;

        % Detect cell if feature value exceeds threshold
        if feature_value >= threshold
            detected_centers = [detected_centers; row + round(window_size(1) / 2), col + round(window_size(2) / 2)];  % Add center of window
        end
    end
end

% Apply Mean Shift to cluster detected cell centers
if ~isempty(detected_centers)
    % Call the meanshift function to find clusters (you can adjust bandwidth `b` as needed)
    [L] = meanshift(detected_centers, 15, 1);  % Example bandwidth = 10, visualization every iteration

    % Get the final cluster centers
    cluster_centers = zeros(max(L), 2);
    for i = 1:max(L)
        cluster_centers(i, :) = mean(detected_centers(L == i, :), 1);  % Mean center for each cluster
    end
    
    % Display the image and plot the detected clusters
    figure;
    imshow(img);
    hold on;

    % Plot each cluster center
    for i = 1:size(cluster_centers, 1)
        plot(cluster_centers(i, 2), cluster_centers(i, 1), 'go', 'MarkerSize', 10, 'LineWidth', 2);  % Green circles for clusters
    end

    title('Detected Cells (Clusters)');
end
