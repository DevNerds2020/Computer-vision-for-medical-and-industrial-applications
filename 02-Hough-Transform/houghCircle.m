function [mOut, nOut, rOut] = houghCircle(E, nc, minR, maxR)
% Findet nc Kreise in einem Kantenbild E mit Radius zwischen minR und maxR
% mit Hilfe der Hough-Transformation für Kreise.
%
% Eingabe: E - Kantenbild
%          nc - maximale Anzahl an Kreisen
%          minR, maxR - minimaler/maximaler Radius der gesuchten Kreise
% Ausgabe: [mOut, nOut, rOut] - Parameter der gefundenen Kreise 
%                               (Mittelpunkt, Radius)

    % Initialisierung
    mOut = zeros(1, nc);
    nOut = zeros(1, nc);
    rOut = zeros(1, nc);
      
    % Bestimmung aller Kantenpixel im Kantenbild
    % Befehl: find
    [yEdge, xEdge] = find(E); % Find the coordinates of edge pixels
    
    % Initialisierung der dreidimensionalen (m, n, r) Akkumulatormatrix A 
    % mit geeigneter Quantisierung der Parameter
    % Befehl: zeros
    sizeM = size(E, 1);
    sizeN = size(E, 2);
    A = zeros(sizeM, sizeN, maxR - minR + 1); % 3D accumulator matrix

    % Bestimmung der Update-Maske für die Akkumulatormatrix
    A_update = getAccumulatorUpdate(minR, maxR);    
    
    % Kantenpixel durchlaufen und Akkumulatormatrix erhöhen, d.h.
    % Update-Maske an entsprechender Position addieren.
    % Matlab kann nur Matrizen gleicher Größe addieren, Sie müssen daher
    % den entsprechenden Bereich aus der Akkumulatormatrix auswählen.
    % Achten Sie auch auf eine geeignete Randbehandlung.
    for i = 1:length(xEdge)
        x = xEdge(i);
        y = yEdge(i);
        
        % Loop over each radius
        for r = minR:maxR
            rIdx = r - minR + 1; % Adjusted index for radius in A
            
            % Define region of interest (ROI) in accumulator
            xStart = max(1, x - maxR);
            xEnd = min(sizeM, x + maxR);
            yStart = max(1, y - maxR);
            yEnd = min(sizeN, y + maxR);
            
            % Define corresponding ROI in the update mask
            maskXStart = maxR + 1 - (x - xStart);
            maskXEnd = maxR + 1 + (xEnd - x);
            maskYStart = maxR + 1 - (y - yStart);
            maskYEnd = maxR + 1 + (yEnd - y);
            
            % Add mask to the accumulator matrix in the ROI
            A(xStart:xEnd, yStart:yEnd, rIdx) = A(xStart:xEnd, yStart:yEnd, rIdx) + ...
                                                A_update(maskXStart:maskXEnd, maskYStart:maskYEnd, rIdx);
        end
    end
    
    % finde die nc größten Punkte in der Akkumulatormatrix
    % ensprechende Parameter werden in die Vektoren m, n, r geschrieben
    for it = 1:nc
        [~, ind] = max(A(:));
        [mOut(it), nOut(it), rOut(it)] = ind2sub(size(A), ind);
        rOut(it) = rOut(it) + minR - 1; % Adjust radius to match original value range
        A(mOut(it), nOut(it), rOut(it) - minR + 1) = 0; % Set the maximum point to 0 to find the next largest
    end
end
