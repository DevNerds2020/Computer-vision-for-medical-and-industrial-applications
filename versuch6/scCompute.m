%{
P: A n×2n \times 2 matrix containing nn reference points. For each point in PP, the Shape Context is computed.
X: A m×2m \times 2 matrix containing mm points to be analyzed relative to the points in PP.
nBinsTheta: Number of angular bins for dividing the circle around a point into regions.
nBinsR: Number of radial bins for dividing distances into logarithmic intervals.
rMin: Minimum radius for the radial bins.
rMax: Maximum radius for the radial bins.

Goal: Compute a 2D histogram (Shape Context) for each point in PPP based on the spatial distribution of points in XXX.
Output: A normalized 3D histogram SCSCSC, where the third dimension corresponds to each point in PPP.
Key Steps:
Compute distances and assign radial bins.
Compute angles and assign angular bins.
Count the number of points in each radial-angular bin.
Normalize the histogram to form a probability distribution.
%}
function SC = scCompute(P, X, nBinsTheta, nBinsR, rMin, rMax)
    
    n = size(P, 1);      % Anzahl Punkte in P (Aufgabe 1: n = 1)
    m = size(X, 1);      % Anzahl Punkte in X
    
    % Bestimme Abstände der Punkte X zu den Punkten P.
    % Berechne den Abstand r_i = ||x_i - P||_2 für jedes x_i in X relativ zu jedem Punkt in P
    r = zeros(m, n); % Matrix, um Abstände zu speichern
    for i = 1:n
        r(:, i) = sqrt(sum((X - P(i, :)).^2, 2)); % Abstand berechnen
    end
    
    % Ordne die Punkte in X den verschiedenen Bins zu, d.h. abhängig von
    % dem Abstand zu den Punkten in P werden die Punkte zusammengefasst
    % und in die Bins 1 bis nBinsR eingeteilt.
    
    % a) Bestimme die Grenzen zwischen den Bins.
    %    in Matlab: logspace
    binEdgesR = logspace(log10(rMin), log10(rMax), nBinsR + 1);
    
    % b) Weise Punkte in X den entsprechenden Bins zu, d.h. rLabel(i, j)
    %    gibt an, in welchem Bin der Punkt X(i, :) in Bezug auf P(j, :)
    %    liegt.
    rLabel = zeros(m, n); % Matrix, um Bin-Labels zu speichern
    for i = 1:n
        rLabel(:, i) = discretize(r(:, i), binEdgesR); % Bin-Zuweisung
    end
    
    % Bestimme Richtung der Punkte in X relativ zu den Punkten P, d.h. den 
    % Winkel zwischen X(i, :) - P(j, :) und der x-Achse.
    % in Matlab: atan2
    theta = zeros(m, n); % Matrix, um Winkel zu speichern
    for i = 1:n
        diff = X - P(i, :); % Differenzvektor
        theta(:, i) = atan2(diff(:, 2), diff(:, 1)); % Winkel berechnen
    end
    
    % Ordne die Punkte in X den Bins zu
    % a) Bestimme Grenzen zwischen den Bins
    %    in Matlab: linspace
    binEdgesTheta = linspace(-pi, pi, nBinsTheta + 1);
    
    % b) Weise Punkte in X den entsprechenden Bins zu
    thetaLabel = zeros(m, n); % Matrix, um Winkel-Bin-Labels zu speichern
    for i = 1:n
        thetaLabel(:, i) = discretize(theta(:, i), binEdgesTheta); % Bin-Zuweisung
    end
    
    % Histogramm bestimmen, Bins auszählen
    SC = zeros(nBinsR, nBinsTheta, n);
    for it_r = 1:nBinsR
        for it_theta = 1:nBinsTheta
            SC(it_r, it_theta, :) = reshape(sum((thetaLabel == it_theta).*(rLabel == it_r), 1), 1, 1, n);
        end
    end
    % Histogramm normalisieren -> Wahrscheinlichkeiten
    SC = SC ./ (repmat(sum(sum(SC, 1), 2), [size(SC, 1), size(SC, 2), 1]) + eps);
end
