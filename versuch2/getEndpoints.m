function linePoints = getEndpoints(I, theta, rho)
% Bestimmt die Endpunkte der implizit durch theta und rho gegebenen Geraden
%      x*cos(theta) + y*sin(theta) = rho
% im Bild I.
%
% Eingabe: I - Bild
%          theta, rho - Array von Parametersets, die Geraden beschreiben

% Ausgabe: linePoints - nx4-Matrix,
%                       jede Zeile beschreibt eine Gerade mit ihren Start
%                       und Endpunkten: [xStart, xEnd, yStart, yEnd]
    
    if size(rho, 1) == 1
        rho = rho';
    end
    if size(theta, 1) == 1
        theta = theta';
    end

    % Bildgröße
    [m, ~] = size(I);
    
    % Punkt am oberen Bildrand
    linePoints(:, 1) = ones(1, length(theta));
    linePoints(:, 3) = (rho - linePoints(:, 1) .* sind(theta)) ./ cosd(theta);
    
    % Punkt am unteren Bildrand
    linePoints(:, 2) = m * ones(1, length(theta));
    linePoints(:, 4) = (rho - linePoints(:, 2) .* sind(theta)) ./ cosd(theta);
    
    % Anpassung (Bildursprung in (1, 1) nicht (0, 0))
    linePoints = linePoints + 1;
end
