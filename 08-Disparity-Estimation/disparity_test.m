%%
% Matlab testbilder
% I1 = im2double(rgb2gray(imread('scene_left.png')));
% I2 = im2double(rgb2gray(imread('scene_right.png')));

% Stereosequenz
% I1 = im2double(rgb2gray(imread('./bilder/im0.ppm')));
% I2 = im2double(rgb2gray(imread('./bilder/im2.ppm')));

% Random-Dot-Stereogram
% I1 = double(imread('./bilder/random_dot_left.gif'));
% I2 = double(imread('./bilder/random_dot_right.gif'));

%I1 = double(imread('./bilder/random_dot_left_2.jpg'));
%I2 = double(imread('./bilder/random_dot_right_2.jpg'));

% Magic Eye (Random-Dot-Autostereogram)
 I1 = im2double(imread('./bilder/test.jpg'));
 I2 = conv2(I1, [zeros(1, 60), 1], 'same');

% I1 = im2gray(im2double(imread('./bilder/test2.jpg')));
% I2 = conv2(I1, [zeros(1, 350), 1], 'same');

% figure(1); clf;
% subplot(121); imshow(I1);
% subplot(122); imshow(I2);

%% Aufgabe 1a - pixelweiser Vergleich
Ver = 'NCC';
Auf = 2;
D = myDisparity(I1, I2, 10,3, Ver, Auf);

figure(2); clf;
imagesc(D); colormap(gray); axis image;

figure(3); clf;
[X, Y] = meshgrid(1:size(I1, 2), 1:size(I2, 1));
surf(X, Y, D); shading flat; axis ij;
