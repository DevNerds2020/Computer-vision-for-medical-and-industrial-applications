clear all;
close all;
clc;

%% Daten laden
load('ShapeContextData.mat')

%% Shape Context für alle Trainingsdaten bestimmen
%  Einfache Variante: Bestimme Histogramm für Bildmittelpunkt

% setze Parameter
nBinsTheta = 12;  % 12 bins for angles
nBinsR = 5;       % 5 bins for radial distances
rMin = 0.05;      % Minimum radius
rMax = 0.5;       % Maximum radius

% Shape Context der Trainingsdaten bestimmen
SC_train = zeros(nBinsR, nBinsTheta, size(train_data, 3));
for it = 1:size(train_data, 3)
    img = train_data(:, :, it);
    
    X = getEdgePoints(img, 50);
    % disp(['Number of edge points: ', num2str(size(X, 1))]);

    
    SC_train(:, :, it) = scCompute([0.5, 0.5], X, nBinsTheta, nBinsR, rMin, rMax);
end

%% Shape Context für alle Testdaten bestimmen und klassifizieren

% Konfusionsmatrix
% K(i,j) gibt an, als welche Ziffern j die Testdaten i erkannt wurden, d.h.
% bei einer perfekten Klassifikation ist nur die Hauptdiagonale ~= 0
K = zeros(10);

for it = 1:size(test_data, 3)
    img = test_data(:, :, it);
    X = getEdgePoints(img, 50);

    % Compute Shape Context for the test data
    SC = scCompute([0.5, 0.5], X, nBinsTheta, nBinsR, rMin, rMax);

    % Debugging: Display size and bin consistency for test and train
    disp(['SC (test data) size: ', mat2str(size(SC))]);
    
    HC = zeros(1, size(SC_train, 3));
    for it_train = 1:size(SC_train, 3)
        % Debugging inside the train loop
        disp(['SC_train(:, :, it_train) size: ', mat2str(size(SC_train(:, :, it_train)))]);
        disp(['nBinsR (test): ', num2str(size(SC, 1)), ' vs nBinsR (train): ', num2str(size(SC_train(:, :, it_train), 1))]);
        disp(['nBinsTheta (test): ', num2str(size(SC, 2)), ' vs nBinsTheta (train): ', num2str(size(SC_train(:, :, it_train), 2))]);

        % Compute histogram cost
        HC(it_train) = histCost(SC, SC_train(:, :, it_train));
    end
    
    % Nearest neighbor classification
    [~, ind] = min(HC);
    K(label_test(it)+1, label_train(ind)+1) = K(label_test(it)+1, label_train(ind)+1) + 1;
end

%% Darstellung Konfusionsmatrix
figure; clf; hold on;

for x = 1:10
    for y = 1:10
        c = 'black';
        if x == y
            c = 'blue';
        elseif K(x, y) > 0
            c = 'red';
        end
        text(x-1.15, y-0.85, num2str(K(x, y)), 'color', c, 'FontSize', 18);
    end
    plot([x - 0.5, x - 0.5], [-0.5, 9.5], 'k');
    plot([-0.5, 9.5], [x - 0.5, x - 0.5], 'k');
end

hold off;
axis ij;
set(gca, 'TickDir', 'out');
axis([-0.5, 9.5, -0.5, 9.5]);
xlabel('tatsächliche Ziffer');
ylabel('erkannte Ziffer');
title(['Fehlklassifikationen: ', num2str(sum(K(:))-sum(diag(K))), ' von ', num2str(sum(K(:)))]);
