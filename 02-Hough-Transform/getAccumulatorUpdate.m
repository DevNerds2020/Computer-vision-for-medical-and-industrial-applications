function AUpdate = getAccumulatorUpdate(minR, maxR) 

    % Bestimmung einer Maske zur Erhöhung der Akkumulatormatrix:
    % Für jeden Kantenpixel müssen die Zellen der Matrix erhöht werden, die
    % den Kantenpixel generiert haben können. Zur Beschleunigung des
    % Verfahrens kann dies als Maske vorab initialisiert werden.
    
    % 1. Initialisierung der dreidimensionalen Maske (AUpdate) in
    %    geeigneter Größe
    %    1./2. Dimension: Mittelpunkt (m, n) der Kreise
    %    3.    Dimension: Radius (r) des Kreises
    %
    %    Befehl: zeros
    
    sizeDim = 2 * maxR + 1; % Size of each 2D slice to cover circle area
    AUpdate = zeros(sizeDim, sizeDim, maxR - minR + 1); % 3D mask array
    
    % Define center coordinates
    center = maxR + 1;

    % 2. In der Maske für jeden Radius r die Punkte auf 1 setzen, deren
    %    Abstand zum Bildmittelpunkt (gerundet) r entspricht.
    %
    %    mögliche Lösung: (m, n)-Werte der Maske durchlaufen und Abstand zum 
    %    Mittelpunkt (Radius r) bestimmen und das Tripel (m, n, r) in der 
    %    Maske auf 1 setzen, wenn r im relevanten Bereich ist.
    
    for r = minR:maxR
        rIdx = r - minR + 1; % Adjusted index for current radius
        for m = 1:sizeDim
            for n = 1:sizeDim
                % Calculate distance from center
                dist = sqrt((m - center)^2 + (n - center)^2);
                
                % Check if rounded distance matches the current radius
                if round(dist) == r
                    AUpdate(m, n, rIdx) = 1; % Set the point in the mask to 1
                end
            end
        end
    end
end
