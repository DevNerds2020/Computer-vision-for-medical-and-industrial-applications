% Testet den Harris-Corner-Detektor.
I = imread('./bilder/blox.gif');
ecken = harrisCorner(I, 1, 4, 1e6);

% Darstellung
figure(1); clf;
subplot(121); imshow(I);
subplot(122); imshow(I);

hold on;        % ermöglicht weitere Objekte in die figure zu zeichnen

% Ecken markieren
% Hinweis: Bilder werden in Matlab als Array in einem ij-Koordinatensystem
% dargestellt, mit dem Nullpunkt in der linken, oberen Ecke. Die i-Achse
% verläuft senkrecht, die j-Achse waagerecht.


    % TODO


hold off;