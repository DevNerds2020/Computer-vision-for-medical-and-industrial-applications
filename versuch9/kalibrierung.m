close all
%% Verwendung gegebener Stereobilder
load('focusedStereoSetup.mat');
% load('parallelStereoSetup.mat');

%% Definition Kalibrierungsobjekt
Xw = [0, 0, 0; ... % 1 Ecke 1,3,5 (gelb, rot, blau)
      6, 0, 0; ... % 2 Ecke 1,4,5 (gelb, magenta, blau)
      0, 0, 6; ... % 3 Ecke 1,2,3 (gelb, cyan, rot)
      6, 0, 6; ... % 4 Ecke 1,2,4 (gelb, cyan, magenta)
      0, 6, 0; ... % 5 Ecke 3,5,6 (rot, blau, grün)
      6, 6, 0; ... % 6 Ecke 4,5,6 (magenta, blau, grün)
      0, 6, 6; ... % 7 Ecke 2,3,6 (cyan, rot, grün)
      6, 6, 6];    % 8 Ecke 2,4,6 (cyan, magenta, grün)
     
%% Plotte Kalibrierungsobjekt
figure(1); clf;
plotCube(Xw, true);
view(-30, 30); axis off;

%% Aufgabe 1a) Implementierung der Funktion für Projektionsmatrix
% Projection matrix function in separate file (see below)
%% test getpoints function
% Load the image
figure;
imshow(img1); % Replace 'img1' with your specific image variable
title('Test getPoints Function');

% Run getPoints
Ximg = getPoints(img1);

% Display results
disp('Manually marked points:');
disp(Ximg);

% Visualize the selected points
hold on;
plot(Ximg(:, 1), Ximg(:, 2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title('Marked Points');
hold off;
%% Aufgabe 1b) Kalibrierung einer Kamera anhand eines Bildes
% Projizierte Eckpunkte des Würfels bestimmen (getPoints.m)
figure(2); clf;
imshow(img1); % Replace with the specific image from the dataset
title('Markieren Sie die Eckpunkte des Kalibrierungswürfels');
Ximg = getPoints(img1); % Returns the manually marked image points (8x2 matrix)

% Display the selected points for debugging
disp('Selected image points:');
disp(Ximg);

% Filter out missing points
validIdx = all(Ximg > 0, 2); % Points with valid coordinates
Ximg_valid = Ximg(validIdx, :);
Xw_valid = Xw(validIdx, :);

% Check if valid points exist
if isempty(Ximg_valid) || isempty(Xw_valid)
    error('No valid points found. Please mark the points in the image.');
end

% Visualize valid points
figure(3); clf;
imshow(img1); hold on;
plot(Ximg_valid(:, 1), Ximg_valid(:, 2), 'go', 'LineWidth', 2);
title('Valid Points After Filtering');
hold off;

% Compute the projection matrix
P = getProjectionMatrix(Xw_valid, Ximg_valid);

%% Aufgabe 1c) Test (Rückprojektion)
% Reproject the 3D points (Xw) into the image
Ximg_proj = P * [Xw, ones(size(Xw, 1), 1)]';
Ximg_proj = Ximg_proj(1:2, :) ./ Ximg_proj(3, :); % Normalize homogeneous coordinates

% Plot original and projected points
figure(3); clf;
imshow(img1); hold on;
plot(Ximg(:, 1), Ximg(:, 2), 'go', 'LineWidth', 2); % Original points
plot(Ximg_proj(1, :), Ximg_proj(2, :), 'rx', 'LineWidth', 2); % Projected points
legend('Original Points', 'Projected Points');

% Compute Mean Squared Error (MSE)
MSE = mean(sum((Ximg_valid' - Ximg_proj(:, validIdx)).^2, 1));
fprintf('Mittlerer Rückprojektionsfehler (MSE): %.5f\n', MSE);


%% Aufgabe 2a) Kalibrierung der zweiten Kamera
% Projizierte Eckpunkte des Würfels bestimmen (getPoints.m)
figure(4); clf;
imshow(img2); % Replace with the specific image name for the second camera
title('Markieren Sie die Eckpunkte des Kalibrierungswürfels');
Ximg2 = getPoints(img2); % Returns the manually marked image points (8x2 matrix)

% Filter out missing points for the second camera
validIdx2 = all(Ximg2 > 0, 2); % Points with valid coordinates
Ximg2_valid = Ximg2(validIdx2, :);
Xw_valid2 = Xw(validIdx2, :);

% Compute projection matrix for the second camera
P2 = getProjectionMatrix(Xw_valid2, Ximg2_valid);

% Display the projection matrix for debugging
disp('Projection Matrix for Camera 2:');
disp(P2);
%% Aufgabe 2b) Bestimmung der Kamerazentren und Visualisierung der 3D-Szene
% Compute camera centers
C1 = null(P); % Camera center for the first camera
C2 = null(P2); % Camera center for the second camera
C1 = C1 ./ C1(end); % Normalize homogeneous coordinates
C2 = C2 ./ C2(end);

% Visualize the scene in 3D
figure(5); clf;
plotCube(Xw, true); % Plot calibration object
hold on;
plot3(C1(1), C1(2), C1(3), 'ro', 'MarkerSize', 10, 'LineWidth', 3); % Camera 1
plot3(C2(1), C2(2), C2(3), 'bo', 'MarkerSize', 10, 'LineWidth', 3); % Camera 2
legend('Calibration Object', 'Camera 1 Center', 'Camera 2 Center');
title('3D Scene Visualization');
grid on;
view(3);
%% Aufgabe 2c) Rekonstruktion von 3D-Punkten mittels Triangulation
% Perform triangulation for valid points
X_reconstructed = myTriangulation(Ximg_valid, Ximg2_valid, P, P2);

% Display the reconstructed points for debugging
disp('Reconstructed 3D Points:');
disp(X_reconstructed);
%% Aufgabe 2d) Visualisierung und Berechnung des Rekonstruktionsfehlers
% Calculate reconstruction error (MSE)
MSE_3D = mean(sum((X_reconstructed - Xw_valid2).^2, 2));

% Display the Mean Squared Error
fprintf('Reconstruction Mean Squared Error (MSE): %.5f\n', MSE_3D);

% Visualize the reconstructed points alongside the calibration object
figure(6); clf;
plotCube(Xw, true); % Plot the original calibration object
hold on;
plot3(X_reconstructed(:, 1), X_reconstructed(:, 2), X_reconstructed(:, 3), 'kx', ...
    'MarkerSize', 10, 'LineWidth', 2);
legend('Original Calibration Object', 'Reconstructed Points');
title('Comparison of Original and Reconstructed Points');
grid on;
view(3);
