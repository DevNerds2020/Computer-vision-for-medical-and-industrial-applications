% Findet Geraden in einem Bild mit Hilfe der Matlab-eigenen Funktionen zur
% Hough-Transformation

%% Bild einlesen und darstellen
I = im2double(imread('./bilder/wire_bond1.tif'));
if size(I, 3) > 1
    I = rgb2gray(I);
end

figure(1); clf; subplot(2, 2, 1);
imshow(I);
title('Bild');

%% Kantenbild erstellen und darstellen
%
%  Befehle: edge, imshow/image/imagesc
edges = edge(I, 'canny'); % Kantenbild mit Canny-Methode erstellen
figure(1); subplot(2, 2, 3); % (sub)figure anwählen
imshow(edges);
title('Kantenbild');

%% Hough-Transformation und Darstellung der Akkumulatormatrix
%
%  Befehle: hough, imagesc
[H, T, R] = hough(edges); % Hough-Transformation
figure(1); subplot(2, 2, [2, 4]); % (sub)figure anwählen
imagesc(T, R, H); % Akkumulatormatrix anzeigen
title('Akkumulatormatrix');
xlabel('\theta (Degrees)');
ylabel('\rho (Pixels)');
colormap(gca, hot); % Farbskala auf "hot" setzen
colorbar;

%% Maxima der Akkumulatormatrix H bestimmen
%  und in Darstellung plotten
%
%  Befehle: houghpeaks, plot
P = houghpeaks(H, 10, 'Threshold', 0.3 * max(H(:))); % Maxima finden
figure(1); subplot(2, 2, [2, 4]); % (sub)figure anwählen
hold on;
plot(T(P(:, 2)), R(P(:, 1)), 's', 'color', 'blue'); % Maxima plotten
hold off;

%% Geraden zu den entsprechenden Maxima in das Bild plotten
%
%  getEndpoints(I, theta, rho) gibt Endpunkte der implizit gegebenen
%  Geraden mit den Parametern theta und rho zurück. Die relevanten
%  Parameter können mit der Rückgabe von houghpeaks aus R und T bestimmt 
%  werden.
%
%  Befehl: plot
figure(1); subplot(2, 2, 1); % (sub)figure anwählen
hold on;
for k = 1:size(P, 1)
    theta = T(P(k, 2));
    rho = R(P(k, 1));
    endpoints = getEndpoints(I, theta, rho); % Endpunkte erhalten
    plot([endpoints(1, 1), endpoints(2, 1)], [endpoints(1, 2), endpoints(2, 2)], 'LineWidth', 2, 'Color', 'green'); % Geraden plotten
end
hold off;
%%
figure(1); subplot(2, 2, 1); % Select (sub)figure
hold on;
for k = 1:size(P, 1)
    theta = T(P(k, 2));
    rho = R(P(k, 1));
    
    % Convert theta to radians
    thetaRad = deg2rad(theta);

    % Calculate endpoints based on theta and rho
    % Define x range (image width)
    x = [1, size(I, 2)];
    % Calculate corresponding y values using the line equation
    y = (rho - x * cos(thetaRad)) / sin(thetaRad);
    
    % Plot the line only if endpoints are within image bounds
    if all(y >= 1 & y <= size(I, 1))
        plot(x, y, 'LineWidth', 2, 'Color', 'green'); % Plot lines
    end
end
hold off;


