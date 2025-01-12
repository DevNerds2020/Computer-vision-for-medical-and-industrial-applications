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