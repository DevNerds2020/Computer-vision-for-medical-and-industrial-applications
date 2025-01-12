function [X] = getPoints(img)
    % Initialize the points matrix
    X = zeros(8, 2);
    h = size(img, 1);
    w = size(img, 2);
    
    % Create a figure for user interaction
    fig = figure();
    figure(fig);
    imshow(img);
    title('Instructions: Left-click to assign points. Press numbers 1-8. Right-click to finish.');

    % Set up the text overlay
    text(0, h + 15, 'Instructions:', 'FontSize', 12, 'Color', 'red');
    text(0, h + 30, '1. Click on the image to place a point.', 'FontSize', 10);
    text(0, h + 45, '2. Assign the point a number (1-8) using the keyboard.', 'FontSize', 10);
    text(0, h + 60, '3. Right-click when done.', 'FontSize', 10);

    % Interactive loop for user input
    while true
        % Wait for mouse click
        [x, y, button] = ginput(1);
        
        % Handle button clicks
        if isempty(button)
            continue; % Skip if no input detected
        end
        
        switch button
            case {1} % Left-click to mark points
                if x >= 1 && x <= w && y >= 1 && y <= h
                    fprintf('Click detected at (%.2f, %.2f). Assign a number (1-8).\n', x, y);
                else
                    disp('Point outside the image boundary. Try again.');
                end
            case {49, 50, 51, 52, 53, 54, 55, 56} % Numbers 1-8
                idx = button - 48; % Convert ASCII to number
                if x >= 1 && x <= w && y >= 1 && y <= h
                    X(idx, :) = [x, y];
                    fprintf('Point %d set at (%.2f, %.2f).\n', idx, x, y);
                else
                    disp('Point outside the image boundary. Try again.');
                end
            case {3} % Right-click to finish
                disp('Point selection finished.');
                break;
            otherwise
                disp('Invalid input. Use numbers 1-8 to assign points or right-click to finish.');
        end

        % Update visualization
        imshow(img); hold on;
        validIdx = find(any(X, 2));
        plot(X(validIdx, 1), X(validIdx, 2), 'xr', 'MarkerSize', 20, 'LineWidth', 3);
        text(X(validIdx, 1), X(validIdx, 2), cellstr(num2str(validIdx)), ...
            'VerticalAlignment', 'bottom', 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
        hold off;
    end

    % Close the figure
    close(fig);
    
    % Validate the output
    if all(all(X == 0))
        error('No points were marked. Please try again.');
    end
end
