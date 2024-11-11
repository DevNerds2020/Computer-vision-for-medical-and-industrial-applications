function plotCircle(m, n, r)

hold on;
for i = 1:length(r)
    rectangle('Position', [m(i) - r(i), n(i) - r(i), 2 * r(i), 2 * r(i)], ...
              'Curvature', [1, 1], ...
              'EdgeColor', [1, 0.5, 0], ...
              'LineWidth', 2);
    plot(m(i), n(i), 'x', 'Color', [1, 0.5, 0]);
end
hold off;

end
