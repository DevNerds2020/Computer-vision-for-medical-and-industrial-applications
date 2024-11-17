function plotClusterResults(X, L)

    hold on;
    c = colormap(hsv(max(L)));
    c = c(randperm(size(c, 1)), :);
    if min(size(X)) == 2
        for it = 1:max(L)
            plot(X(L == it, 1), X(L == it, 2), '.', ...
                 'MarkerEdgeColor', c(it, :), ...
                 'MarkerSize', 20);
        end
    else
        for it = 1:max(L)
            plot3(X(L == it, 1), X(L == it, 2), X(L == it, 3), '.', ...
                  'MarkerEdgeColor', c(it, :), ...
                  'MarkerSize', 20);
        end
    end
    hold off;
    axis equal;

end 
