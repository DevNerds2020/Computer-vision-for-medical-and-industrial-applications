close all;

%% Beispielgesichter (Trainingsdaten) laden
CPath = './att_faces';
ReconPath = './recon_faces';

subjects = 40;
images = 10;

filename = sprintf('%s/s%i/%i.pgm', CPath, 1, 1);
Img = im2double(imread(filename));
[six, siy] = size(Img);

F = [];
% fülle Datenmatrix
for sub = 1:subjects
%     if sub ~= 8
    for im = 1:images
        filename = sprintf('%s/s%i/%i.pgm', CPath, sub, im);
        if exist(filename, 'file')
            % Speicher Bilder spaltenweise
            F = [F, reshape(im2double(imread(filename)), [], 1)];
        end
    end
%     end
end

%% a) Erstellung des PCA-Raums

% "Meanface" erstellen und darstellen
mean_face = mean(F, 2);
figure(1);
imagesc(reshape(mean_face, six, siy));
colormap gray;
title('Mean Face');
axis off;

% mittelwertfreie Gesichter generieren
F_centered = F - mean_face;

% Singulärwertzerlegung der mittelwertfreien Gesichter (svd)
% Die svd löst das Eigenwertproblem zu der Matrix F'*F (siehe
% "algebraischer Trick" aus der Vorlesung) und generiert direkt eine
% orthonormale Basis.
[U, S, ~] = svd(F_centered, 'econ');
% U: Eigenvectors, S: Singular values (diagonal matrix)

%% b) Visualisieren Sie 4 Hauptkomponenten (z.B. 1, 50, 100, 300)
% Verwenden Sie imagesc oder normalisieren Sie die Bilder.
figure(2);
components = [1, 50, 100, 300];
for i = 1:4
    subplot(2, 2, i);
    imagesc(reshape(U(:, components(i)), six, siy));
    colormap gray;
    title(['Component ', num2str(components(i))]);
    axis off;
end

%% c) Bildrekonstruktion aus dem Unterraum
filename = sprintf('%s/%i.pgm', ReconPath, 8);
F_original = reshape(im2double(imread(filename)), [], 1);

% Anzahl Eigenfaces
% Testen Sie auch verschiedene Werte!
d = 300;

% ersten d Eigenvektoren (Eigenfaces) auswählen
eigenfaces = U(:, 1:d);

% Mittelwert vom Bild abziehen
F_centered_original = F_original - mean_face;

% Projektion in den Unterraum
projection = eigenfaces' * F_centered_original;

% Rekonstruktion aus dem Unterraum
reconstruction = eigenfaces * projection + mean_face;

% Rekonstruktion darstellen
figure(3);
subplot(1, 2, 1);
imagesc(reshape(F_original, six, siy));
colormap gray;
title('Original Image');
axis off;

subplot(1, 2, 2);
imagesc(reshape(reconstruction, six, siy));
colormap gray;
title(['Reconstruction with ', num2str(d), ' Eigenfaces']);
axis off;

%% d) Rekonstruktion fehlender Daten
filename = sprintf('%s/%i.pgm', ReconPath, 11);
F_corrupted = reshape(im2double(imread(filename)), [], 1);

% Bereich fehlender Daten bestimmen
missing_mask = F_corrupted == 0;

% iterative Rekonstruktion:
% Projektion -> Rekonstruktion -> Bereich mit Daten füllen -> Projektion...
F_reconstructed = F_corrupted;
for iter = 1:10
    F_centered_corrupted = F_reconstructed - mean_face;
    projection = eigenfaces' * F_centered_corrupted;
    F_reconstructed = eigenfaces * projection + mean_face;
    F_reconstructed(missing_mask) = F_reconstructed(missing_mask);
end

% Darstellung der Rekonstruktion
figure(4);
subplot(1, 2, 1);
imagesc(reshape(F_corrupted, six, siy));
colormap gray;
title('Corrupted Image');
axis off;

subplot(1, 2, 2);
imagesc(reshape(F_reconstructed, six, siy));
colormap gray;
title('Reconstructed Image');
axis off;

%% e) Rekonstruktion ohne exakte Trainingsdaten
%  -> Wiederholen Sie obige Schritte, ohne dass Bilder der zu
%  rekonstruierenden Person in den PCA-Raum integriert werden, d.h. laden
%  Sie Bilder von Person 8 nicht zum Training.

F_no_person8 = [];
for sub = 1:subjects
    if sub ~= 8
        for im = 1:images
            filename = sprintf('%s/s%i/%i.pgm', CPath, sub, im);
            if exist(filename, 'file')
                F_no_person8 = [F_no_person8, reshape(im2double(imread(filename)), [], 1)];
            end
        end
    end
end

mean_face_no_person8 = mean(F_no_person8, 2);
F_centered_no_person8 = F_no_person8 - mean_face_no_person8;
[U_no_person8, ~, ~] = svd(F_centered_no_person8, 'econ');

eigenfaces_no_person8 = U_no_person8(:, 1:d);
F_centered_original_no_person8 = F_original - mean_face_no_person8;
projection_no_person8 = eigenfaces_no_person8' * F_centered_original_no_person8;
reconstruction_no_person8 = eigenfaces_no_person8 * projection_no_person8 + mean_face_no_person8;

figure(5);
subplot(1, 2, 1);
imagesc(reshape(F_original, six, siy));
colormap gray;
title('Original Image');
axis off;

subplot(1, 2, 2);
imagesc(reshape(reconstruction_no_person8, six, siy));
colormap gray;
title('Reconstruction without Person 8');
axis off;