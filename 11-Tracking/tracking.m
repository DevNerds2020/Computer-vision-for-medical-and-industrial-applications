%% Daten einlesen
% Using built-in VideoReader
vr = VideoReader('converted.avi');

% frames = zeros(vr.Height, vr.Width, 3, vr.NumberOfFrames, 'uint8');
frames = read(vr, 'native');

% % Alternative: Use ffmpeg (https://ffmpeg.org/download.html)
% mkdir('frames')
% system('ffmpeg -i test.avi frames/%04d.png');
% num_frames = numel(dir('frames/')) - 2;
% frames = zeros(480, 640, 3, num_frames, 'uint8');
% for i = 1:num_frames
%     frames(:, :, :, i) = imread(sprintf('frames/%04d.png', i));
% end

frames = frames(:, :, :, 2:end);


%% Aufgabe 1: Block Matcher
figure(1); clf;
imshow(frames(:, :, :, 1));
title('Wähle Startpunkt!')

[x, y] = ginput(1);
x = round(x);
y = round(y);

close all;
p = TDLS(frames, x, y, 25);

%% Pfad
for i = 1:size(p, 2)
    figure(1);
    imshow(frames(:, :, :, i));
    hold on;
    plot(p(1, 1:i), p(2, 1:i), 'w', 'LineWidth', 3);
    hold off;
    drawnow;
end

%% Aufgabe 2: Partikelfilter
close all;
p = particleFilterTracking(frames);

%% Pfad
for i = 1:size(p, 2)
    figure(2);
    imshow(frames(:, :, :, i));
    hold on;
    plot(p(1, 1:i), p(2, 1:i), 'w', 'LineWidth', 3);
    hold off;
    drawnow;
end
