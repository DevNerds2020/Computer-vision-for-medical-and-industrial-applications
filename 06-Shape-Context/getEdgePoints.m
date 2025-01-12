function X = getEdgePoints(img, nPoints)
% Bestimmt Punkte auf dem "Rand" einer handgeschriebenen Ziffer.
%
% Eingabe: img - Bild der Ziffer
%          nPoints - Anzahl der Punkte
% Ausgabe: X - Punkte auf dem Rand (n_points x 2 - Array)

    % Initialisierung
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    img = double(img);
    
    % Normalisierung
    img = img - min(img(:));
    img = img / max(img(:));
    
    % Bestimme Randpunkte
    c = contourc(img, [0.5, 0.5]);
    X = c(:, c(1, :) ~= 0.5)';
    
    while size(X, 1) < nPoints
        % Interpolieren
        img = interp2(img);
    
        % Bestimme Randpunkte
        c = contourc(img, [0.5, 0.5]);
        X = c(:, c(1, :) ~= 0.5)';
    end
    
    % sample auf Anzahl nPoints
    % d2 = dist(X, X');             % Deep Learning Toolbox (äquivalent zu pdist2)
    d2 = pdist2(X, X, 'euclidean'); % Statistics and Machine Learning Toolbox
    d2 = d2 + diag(Inf*ones(size(X, 1), 1));
    
    while 1
        % finde dichtesten Punkt zu einem beliebigen Nachbarn
        [a, ind1] = min(d2);
        [~, ind2] = min(a);
        ind = ind1(ind2);
    
        % entferne den Punkt
        X(ind, :) = [];
        d2(:, ind) = [];
        d2(ind, :) = [];
        if size(d2, 1) == nPoints
            break;
        end
    end
    
    X(:, 1) = X(:, 1) / size(img, 1);
    X(:, 2) = 1 - X(:, 2) / size(img, 2);
end
