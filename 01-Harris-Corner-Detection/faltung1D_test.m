% Script zur Einführung in die eindimensionale Faltung

%% Testfunktion

% generiere Stützstellen, an denen die Funktion ausgewertet werden soll
dx = 0.5;
xs = -5:dx:5;

x = 1/4 * sqrt(abs(xs));
% x = xs.^3 + xs + 1;

%% Faltung

% Filterkern f
f = 1/dx * [1/2, 0, -1/2];

% TODO b)

y = conv(x, f, 'same');

%% Darstellung

figure(1);
clf;

subplot(1, 2, 1);
plot(xs, x, '-b.');
title('Funktion');
subplot(1, 2, 2);
plot(xs, y, '-b.');
title(['Ergebnis mit Filter ', mat2str(f)]);

%% Randbehandlung
% TODO c)
