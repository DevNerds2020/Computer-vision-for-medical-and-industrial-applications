%% Generate random 3D points
n = 50;
X = zeros(3, n);

sx = 3;   tx = 5;
sy = 1;   ty = -3;
sz = 0.5; tz = -2;

X(1, :) = sx * randn(1, n) + tx;
X(2, :) = sy * randn(1, n) + ty;
X(3, :) = sz * randn(1, n) + tz;

% Apply rotations
w1 = 60; w2 = 30; w3 = 0;
R1 = [cosd(w1) -sind(w1) 0; sind(w1) cosd(w1) 0; 0 0 1];
R2 = [cosd(w2) 0 sind(w2); 0 1 0; -sind(w2) 0 cosd(w2)];
R3 = [1 0 0; 0 cosd(w3) -sind(w3); 0 sind(w3) cosd(w3)];
X = R3 * R2 * R1 * X;

figure(1);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); axis equal;
title('Original 3D Points');

%% Compute principal components (PCA)
mean_X = mean(X, 2);
X_centered = X - mean_X;
cov_matrix = (1 / (n - 1)) * (X_centered * X_centered');
[eig_vectors, eig_values_matrix] = eig(cov_matrix);
eig_values = diag(eig_values_matrix);

%% b) Project onto 2D using the two largest eigenvectors
principal_axes_2D = eig_vectors(:, 1:2);  % Two largest eigenvectors
projection_2D = principal_axes_2D' * X_centered;

% Reconstruct the 2D data
reconstructed_2D = principal_axes_2D * projection_2D + mean_X;

% Plot original 3D and reconstructed 2D points
figure(2);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_2D(1, :), reconstructed_2D(2, :), reconstructed_2D(3, :), 'or');
for i = 1:n
    plot3([X(1, i), reconstructed_2D(1, i)], ...
          [X(2, i), reconstructed_2D(2, i)], ...
          [X(3, i), reconstructed_2D(3, i)], 'k--');
end
hold off;
legend('Original Points', 'Reconstructed 2D Points');
title('3D to 2D Projection and Reconstruction');

%% c) Project onto 1D using the largest eigenvector
principal_axis_1D = eig_vectors(:, 1);  % The largest eigenvector
projection_1D = (principal_axis_1D' * X_centered)';  % Project each point onto the principal axis

% Reconstruct the 1D data by scaling the principal axis
reconstructed_1D = (projection_1D * principal_axis_1D')' + mean_X;

% Plot original 3D and reconstructed 1D points
figure(3);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_1D(1, :), reconstructed_1D(2, :), reconstructed_1D(3, :), 'og');
for i = 1:n
    plot3([X(1, i), reconstructed_1D(1, i)], [X(2, i), reconstructed_1D(2, i)], [X(3, i), reconstructed_1D(3, i)], 'k--');
end
hold off;
legend('Original Points', 'Reconstructed 1D Points');
title('3D to 1D Projection and Reconstruction');

%% d) Reconstruct the 2D data from 1D and plot
reconstructed_2D_from_1D = principal_axes_2D * (principal_axes_2D' * reconstructed_1D) + mean_X;

% Plot original 3D and reconstructed 2D points from 1D projection
figure(4);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_2D_from_1D(1, :), reconstructed_2D_from_1D(2, :), reconstructed_2D_from_1D(3, :), 'ob');
for i = 1:n
    plot3([X(1, i), reconstructed_2D_from_1D(1, i)], ...
          [X(2, i), reconstructed_2D_from_1D(2, i)], ...
          [X(3, i), reconstructed_2D_from_1D(3, i)], 'k--');
end
hold off;
legend('Original Points', 'Reconstructed 2D from 1D');
title('Reconstruction of 2D from 1D Projection');

%% e) Reconstruct the 3D data from the reconstructed 2D data
reconstructed_3D_from_2D = reconstructed_2D_from_1D + mean_X;

% Plot original 3D and reconstructed 3D points from 2D
figure(5);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_3D_from_2D(1, :), reconstructed_3D_from_2D(2, :), reconstructed_3D_from_2D(3, :), 'og');
for i = 1:n
    plot3([X(1, i), reconstructed_3D_from_2D(1, i)], ...
          [X(2, i), reconstructed_3D_from_2D(2, i)], ...
          [X(3, i), reconstructed_3D_from_2D(3, i)], 'k--');
end
hold off;
legend('Original Points', 'Reconstructed 3D from 2D');
title('Reconstruction of 3D from 2D');
