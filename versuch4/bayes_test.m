%%
clc; clear; close all;
%% Laden der Daten
load('genderData.mat');
    
%% Schätzung der Parameter der Verteilungen
% Male statistics
mean_height_male = mean(height_m_in_cm);
var_height_male = var(height_m_in_cm);
mean_weight_male = mean(weight_m_in_kg);
var_weight_male = var(weight_m_in_kg);

% Female statistics
mean_height_female = mean(height_f_in_cm);
var_height_female = var(height_f_in_cm);
mean_weight_female = mean(weight_f_in_kg);
var_weight_female = var(weight_f_in_kg);

% Display results
disp('Male Mean and Variance (Height, Weight):');
disp([mean_height_male, var_height_male; mean_weight_male, var_weight_male]);

disp('Female Mean and Variance (Height, Weight):');
disp([mean_height_female, var_height_female; mean_weight_female, var_weight_female]);
    
%% Darstellung der geschätzen Verteilungen
% Male covariance matrix
cov_matrix_male = cov([height_m_in_cm, weight_m_in_kg]);

% Female covariance matrix
cov_matrix_female = cov([height_f_in_cm, weight_f_in_kg]);

% Display covariance matrices
disp('Covariance Matrix for Males:');
disp(cov_matrix_male);

disp('Covariance Matrix for Females:');
disp(cov_matrix_female);
    
%% Naiver Bayes Klassifikator
%  Variablen unabhängig, eindimensionale Normalverteilungen
% Define range for plotting
height_range = 140:1:200;
weight_range = 40:1:100;

% Calculate 1D PDFs for height and weight (Male and Female)
pdf_height_male = normpdf(height_range, mean_height_male, sqrt(var_height_male));
pdf_weight_male = normpdf(weight_range, mean_weight_male, sqrt(var_weight_male));
pdf_height_female = normpdf(height_range, mean_height_female, sqrt(var_height_female));
pdf_weight_female = normpdf(weight_range, mean_weight_female, sqrt(var_weight_female));

% Plot 1D distributions
figure;
subplot(2,1,1);
plot(height_range, pdf_height_male, 'b-', height_range, pdf_height_female, 'r-');
title('Height Distribution');
xlabel('Height (cm)');
ylabel('Probability Density');
legend('Male', 'Female');

subplot(2,1,2);
plot(weight_range, pdf_weight_male, 'b-', weight_range, pdf_weight_female, 'r-');
title('Weight Distribution');
xlabel('Weight (kg)');
ylabel('Probability Density');
legend('Male', 'Female');

% Plot 2D distribution for height and weight (using surf and contour)
[X, Y] = meshgrid(height_range, weight_range);
Z_male = mvnpdf([X(:) Y(:)], [mean_height_male, mean_weight_male], cov_matrix_male);
Z_female = mvnpdf([X(:) Y(:)], [mean_height_female, mean_weight_female], cov_matrix_female);
Z_male = reshape(Z_male, length(weight_range), length(height_range));
Z_female = reshape(Z_female, length(weight_range), length(height_range));

figure;
subplot(1,2,1);
surf(height_range, weight_range, Z_male);
title('Male Height-Weight Distribution');
xlabel('Height (cm)');
ylabel('Weight (kg)');
zlabel('Probability Density');

subplot(1,2,2);
surf(height_range, weight_range, Z_female);
title('Female Height-Weight Distribution');
xlabel('Height (cm)');
ylabel('Weight (kg)');
zlabel('Probability Density');   
%% Bayes Klassifikator
%  Variablen abhängig, mehrdimensionale Normalverteilung
% Define individuals to classify
individuals = [182, 79; 188, 130; 195, 95];

% Prior probabilities
p_male = 0.5;
p_female = 0.5;

% Classify each individual
for i = 1:size(individuals, 1)
    % Extract features for the i-th person
    height = individuals(i, 1);
    weight = individuals(i, 2);
    
    % Calculate probabilities for each class using 1D Normal PDFs
    p_male_given_data = p_male * normpdf(height, mean_height_male, sqrt(var_height_male)) * normpdf(weight, mean_weight_male, sqrt(var_weight_male));
    p_female_given_data = p_female * normpdf(height, mean_height_female, sqrt(var_height_female)) * normpdf(weight, mean_weight_female, sqrt(var_weight_female));
    
    % Decide based on the higher probability
    if p_male_given_data > p_female_given_data
        disp(['Individual ', num2str(i), ' classified as Male']);
    else
        disp(['Individual ', num2str(i), ' classified as Female']);
    end
end
%%
for i = 1:size(individuals, 1)
    % Extract features for the i-th person
    x = individuals(i, :);
    
    % Calculate probabilities for each class using multivariate Normal PDF
    p_male_given_data = p_male * mvnpdf(x, [mean_height_male, mean_weight_male], cov_matrix_male);
    p_female_given_data = p_female * mvnpdf(x, [mean_height_female, mean_weight_female], cov_matrix_female);
    
    % Decide based on the higher probability
    if p_male_given_data > p_female_given_data
        disp(['Individual ', num2str(i), ' classified as Male with Full Bayes']);
    else
        disp(['Individual ', num2str(i), ' classified as Female with Full Bayes']);
    end
end