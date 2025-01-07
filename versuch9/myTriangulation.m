function X = myTriangulation(x1, x2, P1, P2)
    % Number of points
    n = size(x1, 1);
    X = zeros(n, 3); % Reconstructed 3D points

    for i = 1:n
        % Cross-product equations for point i
        A = [
            x1(i, 1) * P1(3, :) - P1(1, :);
            x1(i, 2) * P1(3, :) - P1(2, :);
            x2(i, 1) * P2(3, :) - P2(1, :);
            x2(i, 2) * P2(3, :) - P2(2, :)
        ];
        
        % Solve the system using SVD
        [~, ~, V] = svd(A);
        X_h = V(:, end); % Homogeneous solution
        X(i, :) = X_h(1:3)' ./ X_h(4); % Normalize
    end
end
