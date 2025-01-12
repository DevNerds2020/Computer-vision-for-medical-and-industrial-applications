function segmentImageWithKMeans(imagePath, k)
    % Load grayscale image
    img = imread(imagePath);
    if size(img, 3) == 3
        img = rgb2gray(img); % Convert to grayscale if RGB
    end
    
    % Compute histogram of gray levels
    [counts, grayLevels] = imhist(img);
    
    % Prepare data for k-means
    X = (0:255)';        % Gray levels as data points (0-255)
    w = counts;          % Weights from histogram (frequency of each gray level)

    % Apply k-means clustering to the gray levels
    L = kmeans(X, w, k); % L maps each gray level to a cluster (1 to k)

    % Compute cluster centers (mean gray levels for each cluster)
    clusterCenters = zeros(k, 1);
    for i = 1:k
        % Weighted mean of gray levels in cluster i
        clusterCenters(i) = sum(X(L == i) .* w(L == i)) / sum(w(L == i));
    end

    % Map each pixel in the image to its cluster center
    segmentedImg = zeros(size(img)); % Preallocate for segmented image
    for i = 1:numel(grayLevels)
        segmentedImg(img == grayLevels(i)) = clusterCenters(L(i));
    end

    % Display original and segmented images
    figure;
    subplot(1, 2, 1);
    imshow(img, []);
    title('Original Image');
    
    subplot(1, 2, 2);
    imshow(uint8(segmentedImg), []);
    title('Segmented Image');
end
