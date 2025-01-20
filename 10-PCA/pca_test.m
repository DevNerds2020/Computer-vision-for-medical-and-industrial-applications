%% a)
% Punkte generieren und plotten
n = 50;
X = zeros(3, n);

sx = 3;   tx = 5;
sy = 1;   ty = -3;
sz = 0.5; tz = -2;

X(1, :) = sx * randn(1, n) + tx;
X(2, :) = sy * randn(1, n) + ty;
X(3, :) = sz * randn(1, n) + tz;

w1 = 60;
w2 = 30;
w3 = 0;

R1 = [cosd(w1) -sind(w1) 0; sind(w1) cosd(w1) 0; 0 0 1];
R2 = [cosd(w2) 0 sind(w2); 0 1 0; -sind(w2) 0 cosd(w2)];
R3 = [1 0 0; 0 cosd(w3) -sind(w3); 0 sind(w3) cosd(w3)];

X = R3 * R2 * R1 * X;

figure(1);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); axis equal;

%% b)
% Hauptkomponenten bestimmen (Eigenwerte und Eigenvektoren der
% Kovarianzmatrix der Punktmenge berechnen)
mean_X = mean(X, 2);
X_centered = X - mean_X;
cov_matrix = (1 / (n - 1)) * (X_centered * X_centered');
[eig_vectors, eig_values_matrix] = eig(cov_matrix);
eig_values = diag(eig_values_matrix);

%% c)
% Hauptachsen (Eigenvektoren) plotten und deren Länge mit dem zugehörigen
% Eigenwert gewichten
figure(2);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
for i = 1:3
    line = [mean_X, mean_X + eig_vectors(:, i) * eig_values(i)];
    plot3(line(1, :), line(2, :), line(3, :), 'r', 'LineWidth', 2);
end
hold off;
%% d)
% Projektion auf eine der Hauptachsen über Skalarprodukt
% Tipp: Eigenvektoren haben die Länge 1
principal_axis = eig_vectors(:, 3); % Choosing the axis with the largest eigenvalue
projection_1D = (principal_axis' * X_centered)'; % Project each point onto the principal axis

% Varianz in der Projektion
var_projection = var(projection_1D);

%% e)
% Rekonstruktion aus 1D-Unterraum und Plot
reconstructed_1D = (projection_1D * principal_axis')' + mean_X;

figure(3);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_1D(1, :), reconstructed_1D(2, :), reconstructed_1D(3, :), 'or');
for i = 1:n
    plot3([X(1, i), reconstructed_1D(1, i)], ...
          [X(2, i), reconstructed_1D(2, i)], ...
          [X(3, i), reconstructed_1D(3, i)], 'k--');
end
hold off;

%% f)
% Projektion in den 2D-Unterraum der ersten beiden Hauptkomponenten und Rekonstruktion
principal_axes_2D = eig_vectors(:, 2:3); % Using the two largest eigenvalues
projection_2D = principal_axes_2D' * X_centered;
reconstructed_2D = principal_axes_2D * projection_2D + mean_X;

% mittlerer quadratischer Rekonstruktionsfehler
reconstruction_error = mean(sum((X - reconstructed_2D).^2, 1));

figure(4);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_2D(1, :), reconstructed_2D(2, :), reconstructed_2D(3, :), 'og');
for i = 1:n
    plot3([X(1, i), reconstructed_2D(1, i)], [X(2, i), reconstructed_2D(2, i)], [X(3, i), reconstructed_2D(3, i)], 'k--');
end
hold off;

disp(['Mean Squared Reconstruction Error: ', num2str(reconstruction_error)]);


%% Reconstruct 3D points from 2D-reconstructed points and compute error
% Project the reconstructed 2D points back to 3D using the principal axes
reconstructed_3D_from_2D = principal_axes_2D * (principal_axes_2D' * X_centered) + mean_X;

% Compute the mean squared error between the original and re-reconstructed 3D points
reconstruction_error_3D = mean(sum((X - reconstructed_3D_from_2D).^2, 1));

% Plot original and re-reconstructed points in 3D
figure(5);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_3D_from_2D(1, :), reconstructed_3D_from_2D(2, :), reconstructed_3D_from_2D(3, :), 'om');
for i = 1:n
    plot3([X(1, i), reconstructed_3D_from_2D(1, i)], ...
          [X(2, i), reconstructed_3D_from_2D(2, i)], ...
          [X(3, i), reconstructed_3D_from_2D(3, i)], 'k--');
end
hold off;
legend('Original Points', 'Reconstructed from 2D');
disp(['Mean Squared Reconstruction Error (3D from 2D): ', num2str(reconstruction_error_3D)]);
%%
% Compute the mean squared error between the original and initially reconstructed 3D points
reconstruction_error_3D = mean(sum((X - reconstructed_3D_from_2D).^2, 1));

% Plot original and initially reconstructed points in 3D
figure(5);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_3D_from_2D(1, :), reconstructed_3D_from_2D(2, :), reconstructed_3D_from_2D(3, :), 'om');
for i = 1:n
    plot3([X(1, i), reconstructed_3D_from_2D(1, i)], ...
          [X(2, i), reconstructed_3D_from_2D(2, i)], ...
          [X(3, i), reconstructed_3D_from_2D(3, i)], 'k--');
end
hold off;
legend('Original Points', 'Initially Reconstructed Points');
disp(['Mean Squared Reconstruction Error (Initial 3D Reconstruction): ', num2str(reconstruction_error_3D)]);
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

% Projection of data onto the principal components (PCs)
projection_matrix = eig_vectors' * X_centered;

% Reconstruct the data using the projection matrix and the principal components
reconstructed_3D_from_PCA = eig_vectors * projection_matrix + mean_X;

% Compute mean squared reconstruction error
reconstruction_error_3D = mean(sum((X - reconstructed_3D_from_PCA).^2, 1));

% Plot original and reconstructed points in 3D
figure(2);
plot3(X(1, :), X(2, :), X(3, :), 'xb'); hold on; axis equal;
plot3(reconstructed_3D_from_PCA(1, :), reconstructed_3D_from_PCA(2, :), reconstructed_3D_from_PCA(3, :), 'om');
for i = 1:n
    plot3([X(1, i), reconstructed_3D_from_PCA(1, i)], ...
          [X(2, i), reconstructed_3D_from_PCA(2, i)], ...
          [X(3, i), reconstructed_3D_from_PCA(3, i)], 'k--');
end
hold off;
legend('Original Points', 'Reconstructed Points from PCA');
title('3D Reconstruction Using PCA');
disp(['Mean Squared Reconstruction Error (PCA): ', num2str(reconstruction_error_3D)]);
