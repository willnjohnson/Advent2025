% Read input
data = dlmread('input.txt', ',');

x = data(:, 1);
y = data(:, 2);

% Vectorized calculation for efficiency
% Calculate absolute differences + 1 for all pairs
% dx will be an NxN matrix where dx(i,j) = abs(x(i) - x(j)) + 1
dx = abs(x - x') + 1;
dy = abs(y - y') + 1;

% Calculate areas
areas = dx .* dy;

% Find the maximum area
% max(areas(:)) finds the maximum element in the entire matrix
max_area = max(areas(:));

% Display the result using fprintf for clean output without scientific notation if possible
fprintf('Result: %d\n', max_area);
