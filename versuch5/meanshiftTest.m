%%
% Load data X5 (or other datasets like X1-X4)
load('test_data_clustering.mat');

% Parameters
bandwidth = 0.5; % Example bandwidth value
visualize = 0; % No visualization for speed

% Apply mean-shift clustering
[L, C] = meanshift(X2, bandwidth, visualize);

% Display results
disp('Cluster Labels:');
disp(L);
disp('Cluster Centroids:');
disp(C);

figure;
hold on;
plotClusterResults(X2, L)

%%
