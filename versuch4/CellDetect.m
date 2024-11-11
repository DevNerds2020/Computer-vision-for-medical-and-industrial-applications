clear all;
close all;
clc;

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


    % TODO


% Histogramm bestimmen
% Befehl: imhist


    % TODO


% Schwellwerte aus Histogramm bestimmen (manuell oder automatisch) und
% Zellen-Labelbild aus der Durchschnittszelle definieren, z.B.
% Wert  1 - Zellkern (helle Bereiche)
% Wert -1 - Zellwand (dunkle Bereiche)
% Wert  0 - übrige Bereiche


    % TODO


%% Bestimmung der Verteilungsfunktionen
%  Als Merkmal wird die Differenz des mittleren Grauwerts von Zellkern und
%  Zellwand verwendet. Es wird die Annahme getroffen dieses Merkmal ist
%  normalverteilt.

% Merkmal für die positiven Beispiele bestimmen, d.h. in jedem Beispielbild
% wird der Mittelwert im Bereich des Zellkerns und der Zellwand bestimmt
% und abschließend voneinander abgezogen.
% Die entsprechenden Bereiche sind durch die definierte Zellmaske gegeben.

for it = 1:size(pos_images, 3)
    im = pos_images(:, :, it);

    
    % TODO
    
    
end

% Bestimme Mittelwert und Varianz der postiven Beispiele


    % TODO


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

for it = 1:size(neg_images, 3)
    im = neg_images(:, :, it);

    
    % TODO
    
    
end

% Bestimme Mittelwert und Varianz der negativen Beispiele


    % TODO


%% Schwellwert für die Klassifikation bestimmen

% Verteilungen (positive und negative Beispiele) plotten


    % TODO


% Schwellwert bestimmen, der eine (optimale) Trennung zwischen Zelle und
% Hintergrund auf der Basis des Merkmals angibt und im Plot markieren


    % TODO


%% Bild(ausschnitte) klassifizieren und gefundene Zellen markieren

% Testbild laden
img = im2double(rgb2gray(imread('CellDetectPreFreeze.jpg')));

% Bild mit einem "Sliding Window" absuchen und Zellen über die Differenz des
% mittleren Grauwerts der maskierten Zellbestandteile und den Schwellwert detektieren.
% Zur Beschleunigung ist es ausreichend, das Fenster in 5er-Schritten weiterzuschieben.

    
    % TODO


% Bild und gefundene Zellen darstellen

    
    % TODO
    
    
