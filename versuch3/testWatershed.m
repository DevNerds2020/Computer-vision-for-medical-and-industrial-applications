%%
% Load Image
clc; clear; close all;
I = imread('./bilder/Emphysem.png'); % Make sure to provide the correct path
if size(I, 3) == 3
    I = rgb2gray(I); % Convert to grayscale if it is RGB
end

% Step 2: Apply Thresholding
% Choose a suitable threshold method; Otsu's method is a common choice.
level = graythresh(I); % Otsu's thresholding
%L = watershed(I)
%%
I_smooth = imgaussfilt(I, 2);
BW = imbinarize(I_smooth,0.7); % Binary image after thresholding
%edges = edge(BW, 'Canny'); % Apply Canny edge detection
% Step 3: Distance Transform
% Compute the distance transform of the binary image.
D = bwdist(~BW); % Compute distance transform
D = im2uint8(D); % Convert to uint8 for visualization
%D = imcomplement(D);

% Step 4: Applying Watershed Transformation
% Use watershed on the distance transform image
h = 5; % Choose a suitable h-minimum threshold
D_mod = imhmin(D, h); % Suppress minima shallower than h
L = watershed(D_mod); % Apply watershed
L = L + 1; % Add one to ensure that the label for the background is 1
%%
Icomp = imcomplement(I);
h = 8; 
Ifilt = imhmin(Icomp,h);
L = watershed(Ifilt);
%%
% Step 5: Create Segmentation Mask
% Create a mask for the segmented regions
segmented = zeros(size(I));
segmented(L == 0) = 1; % Set watershed lines to 1
segmented = logical(segmented); % Convert to logical array

% Visualize Results
figure;
subplot(2, 3, 1);
imshow(I); title('Original Image');

subplot(2, 3, 2);
imshow(BW); title('Binary Image After Thresholding');

subplot(2, 3, 3);
imshow(D, []); title('Distance Transform');

subplot(2, 3, 4);
imshow(label2rgb(L)); title('Watershed Result');

subplot(2, 3, 5);
imshow(segmented); title('Segmented Alveoli');
%%
% Step 6: Use plotWatershed function to visualize results
plotWatershed(I, L);
