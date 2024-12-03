    %https://www.mathworks.com/help/optim/ug/intlinprog.html
    weights = [3, 7, 4, 12, 8, 10, 9, 14, 10, 12]; % Weight of each object (kg)
    utilities = [3, 5, 2, 11, 4, 6, 2, 15, 12, 9]; % Utility of each object
    max_weight = 60; % Maximum weight capacity of the knapsack (kg)
    
    n = length(weights); % Number of objects
    f = -utilities; % Coefficients for the objective function (negative for maximization)
    A = weights; % Constraint matrix for total weight
    b = max_weight; % Maximum allowable weight
    LB = zeros(n, 1); % Lower bounds (0: item not selected)
    UB = ones(n, 1); % Upper bounds (1: item selected)
    intcon = 1:n; % Integer constraints for variables (must be integers)
    
    [x, max_utility] = intlinprog(f, intcon, A, b, [], [], LB, UB);
    
    fprintf('Selected items:\n');
    disp(find(x == 1));
    fprintf('Maximum utility: %d\n', -max_utility);
    fprintf('Total weight: %d kg\n', sum(weights(x == 1)));
    
    % Plot the result
    % figure;
    % bar(1:n, x);
    % xlabel('Object Index');
    % ylabel('Selection (0 or 1)');
    % title('Knapsack Selection');
    % grid on;