% Read input
coords = dlmread('input.txt', ',');
N = size(coords, 1);

% Compute pairwise distances
% We need distance and indices (i, j)
% Since N=1000, N^2/2 is approx 500,000. We can generate all.

dists = [];
% Preallocate for speed
num_pairs = N * (N - 1) / 2;
dist_list = zeros(num_pairs, 1);
idx1_list = zeros(num_pairs, 1);
idx2_list = zeros(num_pairs, 1);

k = 1;
for i = 1:N
    for j = (i + 1):N
        % Squared distance is enough for sorting and faster to compute
        d2 = sum((coords(i, :) - coords(j, :)) .^ 2);
        dist_list(k) = d2;
        idx1_list(k) = i;
        idx2_list(k) = j;
        k = k + 1;
    end
end

% Sort by distance
[sorted_dists, sort_idx] = sort(dist_list);

% Initialize DSU
parent = 1:N;
set_size = ones(1, N);

% Process top 1000 connections
num_connected = 0;
target_connections = 1000;

for k = 1:min(target_connections, length(sort_idx))
    idx = sort_idx(k);
    u = idx1_list(idx);
    v = idx2_list(idx);
    
    % Find root of u
    while parent(u) ~= u
        parent(u) = parent(parent(u)); % Path compression
        u = parent(u);
    end
    root_u = u;
    
    % Find root of v
    while parent(v) ~= v
        parent(v) = parent(parent(v)); % Path compression
        v = parent(v);
    end
    root_v = v;
    
    if root_u ~= root_v
        % Union
        if set_size(root_u) < set_size(root_v)
            parent(root_u) = root_v;
            set_size(root_v) = set_size(root_v) + set_size(root_u);
        else
            parent(root_v) = root_u;
            set_size(root_u) = set_size(root_u) + set_size(root_v);
        end
    end
end

% Collect all component sizes
final_sizes = [];
for i = 1:N
    if parent(i) == i
        final_sizes = [final_sizes, set_size(i)];
    end
end

% Sort descending
final_sizes = sort(final_sizes, 'descend');

% Multiply top 3
if length(final_sizes) >= 3
    result = prod(final_sizes(1:3));
    fprintf('Result: %d\n', result);
else
    fprintf('Error: Less than 3 circuits found.\n');
end
