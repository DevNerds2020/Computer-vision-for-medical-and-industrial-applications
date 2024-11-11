function ecken = harrisCorner(I, sigma_I, sigma_M, schwellwert)
% Implementiert einen Harris-Corner-Detektor.
    
    % 1. Konvertierung des Eingangsbildes in double.
    I = double(I);
    
    % 2. Glättung des Bildes mit Gauss-Filter (sigma_I).
    
    
      % TODO
    
    
    % 3. Strukturtensor M = [Iu^2, Iu*Iv; Iu*Iv, Iv^2] bilden.
    % a) Ableitung in x-Richtung (Sobel, ...)
    
    
      % TODO
    
    
    % b) Ableitung in y-Richtung (Sobel, ...)
    
    
      % TODO
    
    
    % c) Elemente des Strukturtensors bestimmen. Diese sollten in 
    %    einzelnen Matrizen gespeichert werden.
    
    
      % TODO
    
    
    % 4. Aufsummierung des Strukturtensors M mit Gaussfilter (sigma_M), d.h.
    %    Glättung der einzelnen Bestandteile.
    
    
      % TODO
    
    
    % 5. Auswertung des Strukturtensors. 
    % a) Bestimmung der Detektorantwort R, um die explizite Berechnung der
    %    Eigenwerte zu vermeiden.
    %
    %    R = det(M) - kappa*trace(M)^2
    %
    %    Hinweis:
    %    det(M) = Iu^2 * Iv^2 - (Iu*Iv)^2
    %    trace(M) = Iu^2 + Iv^2
    kappa = 0.04;   % Standardwert
    
    
      % TODO
    
    
    % b) Werte unterhalb des Schwellwertes auf 0 setzen.
    %    Befehl: find, alternativ "logical indexing"
    
    
      % TODO
    
    
    % c) Bestimmung der lokalen Maxima in einer 8er-Nachbarschaft.
    %    Befehl: imregionalmax,
    %    alternativ elementweise Bestimmung (Nichtmaxima auf 0 setzen)
    
    
      % TODO
    
    
    % 6. Ecken bestimmen
    %    Befehl: find
    
    
      % TODO
    
end

