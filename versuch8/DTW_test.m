clear all;
close all;
clc;

v1 = [1, 2, 3, 4, 5,  8,  9, 11, 8, 5, 3, 1];
v2 = [1, 2, 6, 8, 9, 10, 12,  9, 6, 3];

[p1, p2, C, D] = DTW(v1, v2, 1, 3);

figure(1); clf;
subplot(121);
imagesc(C); axis xy; axis image;
hold on; plot(p2, p1, '.r', 'MarkerSize', 20); hold off;
xlabel('Kostenmatrix');

subplot(122);
imagesc(D); axis xy; axis image;
hold on; plot(p2, p1, '.r', 'MarkerSize', 20); hold off;
xlabel('Distanzmatrix');
