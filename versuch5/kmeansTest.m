%%
% Schritt 1: Laden der Daten aus der Datei test_data_clustering.mat
load('test_data_clustering.mat');  % Annahme: X1, X2, X3, X4 sind in der Datei enthalten

% Check sizes of each dataset
disp('Size of X1:')
disp(size(X1))

disp('Size of X2:')
disp(size(X2))

disp('Size of X3:')
disp(size(X3))

disp('Size of X4:')
disp(size(X4))

% Kombinieren der Datensätze X1, X2, X3, X4 zu einer einzigen Datenmatrix X
X4_trimmed = X4(:, 1:2);  % Use only the first 2 columns of X4
X = [X1; X2; X3; X4_trimmed];  % Now concatenate all datasets

% Schritt 2: Festlegung der Clusteranzahl
k = 4;  % Da wir 4 Gruppen erwarten

% Schritt 3: Setzen der Gewichte auf 1 für alle Datenpunkte
w = ones(size(X, 1), 1);  % Alle Gewichte auf 1 setzen

% Schritt 4: Anwendung der kmeans-Funktion
L = kmeans(X, w, k);  % Clusterzuweisungen mit der kmeans-Funktion

% Schritt 5: Visualisierung der Ergebnisse mit plotClusterResults
plotClusterResults(X, L);  % Ergebnisse plotten

%%
load('test_data_clustering.mat');  % Annahme: X1, X2, X3, X4 sind in der Datei enthalten
testinput = X2;
%%
elbowMethod(testinput, 1, 10);

%%
k = 3;  % Da wir 4 Gruppen erwarten
w = ones(size(testinput, 1), 1);  % Alle Gewichte auf 1 setzen
L = kmeans(testinput, w, k);  % Clusterzuweisungen mit der kmeans-Funktion
L2 = kmeansUpdated(testinput, w, k, 1000, 10);
%%
plotClusterResults(testinput, L);  % Ergebnisse plotten
%%
plotClusterResults(testinput, L2)
%%
segmentImageWithKMeans('./bilder/lena.png', 5)