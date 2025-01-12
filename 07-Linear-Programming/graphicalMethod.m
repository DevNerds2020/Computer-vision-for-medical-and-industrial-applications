function graphicalMethod(f, A, b)
    % This function graphically solves a 2D linear optimization problem
    % max f' * x subject to Ax <= b and x >= 0.

    % Check that the problem is two-dimensional
    if length(f) ~= 2 || size(A, 2) ~= 2
        error('This function only supports 2D linear optimization problems.');
    end

    % Scale the objective function
    scaling_factor = max(b) / max(f); % You can adjust this as needed
    f_scaled = f * scaling_factor;

    % Define a grid for plotting constraints and the feasible region
    x1_range = linspace(0, max(b ./ max(A, [], 2)) * 1.1, 500); % Adjust range based on constraints
    x2_range = linspace(0, max(b ./ max(A, [], 2)) * 1.1, 500);
    [X1, X2] = meshgrid(x1_range, x2_range);

    % Plot the constraints
    figure;
    hold on;
    for i = 1:size(A, 1)
        x2_boundary = (b(i) - A(i, 1) * x1_range) / A(i, 2);
        plot(x1_range, x2_boundary, 'DisplayName', sprintf('Constraint %d', i));
    end

    % Highlight the feasible region
    feasible_mask = all(A * [X1(:) X2(:)]' <= b, 1) & (X1(:) >= 0)' & (X2(:) >= 0)';
    X1_feasible = X1(feasible_mask);
    X2_feasible = X2(feasible_mask);
    scatter(X1_feasible, X2_feasible, 1, 'g', 'filled', 'DisplayName', 'Feasible Region');

    % Plot the scaled objective vector (direction of optimization)
    quiver(0, 0, f_scaled(1), f_scaled(2), 'r', 'LineWidth', 2, 'DisplayName', 'Objective Direction (Scaled)');

    % Add labels and legends
    xlabel('x_1');
    ylabel('x_2');
    title('Graphical Solution of Linear Optimization Problem');
    legend('show');
    grid on;
    hold off;

    % Interactive selection of points
    disp('Click points in the feasible region to evaluate the objective function.');
    disp('Right-click to finish selection.');

    max_value = -inf;
    best_point = [];
    while true
        [x1, x2, button] = ginput(1);
        if isempty(button) || button ~= 1
            break;
        end

        % Check if the selected point is feasible
        point = [x1; x2];
        if all(A * point <= b) && all(point >= 0)
            obj_value = f' * point; % Use the original f for actual calculations
            fprintf('Point (%.2f, %.2f) is valid. Objective value: %.2f\n', x1, x2, obj_value);
            if obj_value > max_value
                max_value = obj_value;
                best_point = point;
            end
        else
            fprintf('Point (%.2f, %.2f) is not feasible.\n', x1, x2);
        end
    end

    % Display the result
    if ~isempty(best_point)
        fprintf('Maximum valid objective value: %.2f at point (%.2f, %.2f)\n', max_value, best_point(1), best_point(2));
    else
        disp('No feasible points selected.');
    end
end