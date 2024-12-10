function [p1, p2, C, D] = DTW(v1, v2, weight, maxDisp)
% Dynamic Time Warping
% 
% Eingabe: v1, v2  - Zeilenvektoren, enthalten Merkmale
%          weight  - Strafterm für "Verdeckung"
%          maxDisp - maximal zu untersuchende Disparität
% Ausgabe: p1, p2  - Zeilenvektoren, gibt (optimale) Pfade durch die
%                    Vektoren an
%          C - Kostenmatrix
%          D - Distanzmatrix
    
    n1 = size(v1, 2);
    n2 = size(v2, 2);
    
    % Bestimmung Kostenmatrix C
    C = zeros(n1, n2);
    for i = 1:n1
        for j = 1:n2
            %C(i, j) = (v1(i) - v2(j))^2;
            C(i, j) = sum((v1(:, i) - v2(:,j)).^2); % Compare entire window
        end
    end
    
    
    D = inf * ones(n1, n2);
    M = zeros(n1, n2);

    %init first itme
    D(1, 1) = C(1, 1);

    %first row, can only get values from left
    for j = 2:n2
        D(1, j) = D(1, j - 1) + weight * C(1, j);
        M(1, j) = 3;
    end

    % First columnm, can only get values from up
    for i = 2:n1
        D(i, 1) = D(i - 1, 1) + weight * C(i, 1);
        M(i, 1) = 2;
    end


    for i = 2:n1
        for j = 2:n2
            if abs(i - j) <= maxDisp
                lo = C(i, j) + D(i - 1, j - 1);
                o = weight * C(i, j) + D(i - 1, j);
                l = weight * C(i, j) + D(i, j - 1);
                [D(i, j), direction] = min([lo, o, l]);
                M(i, j) = direction;
            end
        end
    end

    i = n1;
    j = n2;
    p1 = [];
    p2 = [];

    while i > 1 || j > 1
        p1 = [i, p1];
        p2 = [j, p2];

        if M(i, j) == 1
            i = i - 1;
            j = j - 1;
        elseif M(i, j) == 2
            i = i - 1;
        elseif M(i, j) == 3
            j = j - 1;
        else
            disp("error");
            break;
        end
    end

    p1 = [1 p1];
    p2 = [1 p2];

    %p1 = flip(p1);
    %p2 = flip(p2);
end
