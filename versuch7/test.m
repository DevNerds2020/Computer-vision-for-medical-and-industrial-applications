% Test cases
%% Case i
f = [30; 20];
A = [2, 1; 1, 1; 1, 0];
b = [1500; 1200; 500];
fprintf('Case i:\n');
graphicalMethod(f, A, b);

%% Case ii
f = [12; 7];
A = [2, 1; 3, 2];
b = [10000; 16000];
fprintf('Case ii:\n');
graphicalMethod(f, A, b);

%% Case iii
f = [2; 5];
A = [1, 4; 3, 1; 1, 1; 0, 1];
b = [24; 21; 9; 4];
fprintf('Case iii:\n');
graphicalMethod(f, A, b);

% a) Solving the optimization problems using linprog

%% Case i
f = [30; 20]; % Negate for maximization
A = [2, 1; 1, 1; 1, 0];
b = [1500; 1200; 500];
LB = [0; 0]; % Non-negativity constraint
fprintf('Case i:\n');
[x_i, fval_i] = linprog(f, A, b, [], [], LB);
disp('Optimal solution (x):');
disp(x_i);
disp('Maximum objective value:');
disp(-fval_i);

figure;
plot([0, b(1)/A(1,2)], [b(1)/A(1,1), 0], '-r'); hold on;
plot([0, b(2)/A(2,2)], [b(2)/A(2,1), 0], '-g');
plot([b(3)/A(3,1), b(3)/A(3,1)], [0, b(2)/A(2,2)], '-b');
fill([0, b(3)/A(3,1), 0], [0, 0, b(1)/A(1,2)], 'y', 'FaceAlpha', 0.3);
plot(x_i(1), x_i(2), 'ko', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('x1'); ylabel('x2'); title('Case i: Feasible Region and Optimal Solution');
grid on; legend({'Constraint 1', 'Constraint 2', 'Constraint 3', 'Feasible Region', 'Optimal Solution'});

%% Case ii
f = -[12; 7]; % Negate for maximization
A = [2, 1; 3, 2];
b = [10000; 16000];
LB = [0; 0];
fprintf('Case ii:\n');
[x_ii, fval_ii] = linprog(f, A, b, [], [], LB);
disp('Optimal solution (x):');
disp(x_ii);
disp('Maximum objective value:');
disp(-fval_ii);

figure;
plot([0, b(1)/A(1,2)], [b(1)/A(1,1), 0], '-r'); hold on;
plot([0, b(2)/A(2,2)], [b(2)/A(2,1), 0], '-g');
fill([0, b(1)/A(1,2), b(2)/A(2,2)], [b(1)/A(1,1), 0, 0], 'y', 'FaceAlpha', 0.3);
plot(x_ii(1), x_ii(2), 'ko', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('x1'); ylabel('x2'); title('Case ii: Feasible Region and Optimal Solution');
grid on; legend({'Constraint 1', 'Constraint 2', 'Feasible Region', 'Optimal Solution'});

%% Case iii
f = -[2; 5]; % Negate for maximization
A = [1, 4; 3, 1; 1, 1; 0, 1];
b = [24; 21; 9; 4];
LB = [0; 0];
fprintf('Case iii:\n');
[x_iii, fval_iii] = linprog(f, A, b, [], [], LB);
disp('Optimal solution (x):');
disp(x_iii);
disp('Maximum objective value:');
disp(-fval_iii);

figure;
plot([0, b(1)/A(1,2)], [b(1)/A(1,1), 0], '-r'); hold on;
plot([0, b(2)/A(2,2)], [b(2)/A(2,1), 0], '-g');
plot([0, b(3)/A(3,2)], [b(3)/A(3,1), 0], '-b');
plot([0, 0], [0, b(4)/A(4,2)], '-m');
fill([0, 0, b(1)/A(1,2)], [0, b(4)/A(4,2), 0], 'y', 'FaceAlpha', 0.3);
plot(x_iii(1), x_iii(2), 'ko', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('x1'); ylabel('x2'); title('Case iii: Feasible Region and Optimal Solution');
grid on; legend({'Constraint 1', 'Constraint 2', 'Constraint 3', 'Constraint 4', 'Feasible Region', 'Optimal Solution'});

%% b) Solving the political campaign optimization problem
f = [1; 1; 1; 1]; % Cost for each campaign theme in 1000€
% Contribution to votes in thousands
Votes = [-2, 5, 3; 8, 2, -5; 0, 0, 10; 10, 0, -2]; % Themes (rows) x Regions (columns)
Population = [100; 200; 50]; % Population in thousands
Threshold = 0.5 * Population; % Minimum votes needed (50% of each region)

% Reformulating the constraints
A_eq = Votes; % Votes contribution (themes x regions)
b_eq = Threshold; % Minimum votes required for each region

LB = [0; 0; 0; 0]; % Non-negativity constraint

fprintf('Political Campaign Problem:\n');
[x_campaign, min_cost] = linprog(f, [], [], A_eq', b_eq, LB); % Transpose A_eq to align with f
disp('Optimal spending (in 1000€):');
disp(x_campaign);
disp('Minimum cost (in €):');
disp(min_cost * 1000);

% Plotting results for Political Campaign Problem
% figure;
% bar(x_campaign);
% xlabel('Campaign Theme'); ylabel('Spending (in 1000€)');
% title('Optimal Spending per Campaign Theme');
% grid on;