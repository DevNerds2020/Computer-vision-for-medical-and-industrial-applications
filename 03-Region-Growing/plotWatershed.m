function plotWatershed(I, S)
% Stellt das Ergebnis einer Wasserscheidentransformation dar.
%
% Eingabe: I - Bild
%          S - Wasserscheidentransformation

subplot(121);
imshow(label2rgb(S));

subplot(122);
if size(I, 3) == 1
    I2 = cat(3, I, I, I);
else
    I2 = I;
end

S = S <= 0;
S = imdilate(S, ones(3));
if isa(I2, 'double')
    I2(S) = 1;
    I2(find(S) + numel(S)) = 0.5;
    I2(find(S) + 2*numel(S)) = 0;
else
    I2(S) = 255;
    I2(find(S) + numel(S)) = 128;
    I2(find(S) + 2*numel(S)) = 0;
end

imshow(I2);
end
