% Test script for cell detection in 'Zellen.jpg' using Hough Circle Transform

% 1. Load and preprocess the image
I = imread('./bilder/Zellen.jpg');
if size(I, 3) == 3
    I = rgb2gray(I); % Convert to grayscale if it is a color image
end

% 2. Generate edge image using Canny edge detector
E = edge(I, 'canny'); % Use Canny for edge detection
figure;
imshow(E);
% 3. Define Hough parameters
nc = 50;          % Number of circles to detect
minR = 5;         % Minimum radius
maxR = 20;        % Maximum radius

% 4. Apply Hough Circle Transform
[mOut, nOut, rOut] = houghCircle(E, nc, minR, maxR);

% 5. Display the original image with detected circles
figure;
imshow(I);
title('Detected Circles in Zellen.jpg');
hold on;
for k = 1:length(mOut)
    plotCircle(mOut(k), nOut(k), rOut(k)); % Use plotCircle to plot each detected circle
end
hold off;

% 6. Plot a histogram of the detected circle radii
figure;
histogram(rOut, minR:maxR); % Generate histogram of radius
title('Histogram of Detected Circle Radii');
xlabel('Radius');
ylabel('Frequency');