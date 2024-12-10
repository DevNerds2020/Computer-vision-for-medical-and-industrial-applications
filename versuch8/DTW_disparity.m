clear all;
close all;
clc;

%%
% Matlab testbilder
 %I1 = im2double(rgb2gray(imread('scene_left.png')));
 %I2 = im2double(rgb2gray(imread('scene_right.png')));

% Stereosequenz
I1 = im2double(rgb2gray(imread('./bilder/im0.ppm')));
I2 = im2double(rgb2gray(imread('./bilder/im2.ppm')));

% Random-Dot-Stereogram
% I1 = double(imread('./bilder/random_dot_left.gif'));
% I2 = double(imread('./bilder/random_dot_right.gif'));

% I1 = double(imread('./bilder/random_dot_left_2.jpg'));
% I2 = double(imread('./bilder/random_dot_right_2.jpg'));

% Magic Eye (Random-Dot-Autostereogram)
% I1 = im2double(imread('./bilder/test.jpg'));
% I2 = conv2(I1, [zeros(1, 60), 1], 'same');

figure(1); clf;
subplot(121); imshow(I1);
subplot(122); imshow(I2);

%%
D = zeros(size(I1));
occlusionWeight = 1;
maxDisp = 10;
windowSize = 9;

windowSize = 2*floor(windowSize/2) + 1; % muss ungerade sein
for i = 1 + (windowSize - 1) / 2:size(I1, 1) - (windowSize - 1) / 2
    v1 = zeros(windowSize^2, size(I1, 2));
    v2 = v1;
    for j = 1 + (windowSize - 1) / 2:size(I1, 2) - (windowSize - 1) / 2
        v1(:, j) = reshape(I1(i-(windowSize - 1)/2:i+(windowSize - 1)/2, j-(windowSize - 1)/2:j+(windowSize - 1)/2), [], 1);
        v2(:, j) = reshape(I2(i-(windowSize - 1)/2:i+(windowSize - 1)/2, j-(windowSize - 1)/2:j+(windowSize - 1)/2), [], 1);
    end
    
    if mod(i, 10) == 1
        disp(['Zeile ', num2str(i), ' von ', num2str(size(I1, 1))]);
    end
    [p1, p2] = DTW(v2, v1, occlusionWeight, maxDisp);
    
    for j = 1 + (windowSize - 1) / 2:size(I1, 2) - (windowSize - 1) / 2
        D(i, j) = find(p1 == j, 1, 'first') - find(p2 == j, 1, 'first');
    end
end

%%
figure(2); clf;
imagesc(D); colormap(gray); axis image; axis off;

figure(3); clf;
[X, Y] = meshgrid(1:size(I1, 2), 1:size(I2, 1));
surf(X, Y, D); shading flat; axis ij;
