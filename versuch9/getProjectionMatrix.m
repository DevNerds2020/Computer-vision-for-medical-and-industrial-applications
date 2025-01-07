function P = getProjectionMatrix(Xw, Ximg)
    % Construct the matrix A
    n = size(Xw, 1); % Number of points
    A = zeros(2 * n, 12);
    
    for i = 1:n
        X = [Xw(i, :), 1]; % Append 1 to make homogeneous coordinates
        x = Ximg(i, 1); % Extract x-coordinate of image point
        y = Ximg(i, 2); % Extract y-coordinate of image point
        % First row for point i (y-coordinates)
        A(2*i-1, :) = [zeros(1, 4), -X, y * X];
        % Second row for point i (x-coordinates)
        A(2*i, :) = [X, zeros(1, 4), -x * X];
    end
    
    % Solve using SVD
    [~, ~, V] = svd(A);
    p = V(:, end); % Last column of V % flattened form
   
    % Reshape to form P
    P = reshape(p, 4, 3)';
end
