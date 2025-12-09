% Read input
coords = dlmread('input.txt', ',');
N = size(coords, 1);

% Compute pairwise distances
num_pairs = N * (N - 1) / 2;
dist_list = zeros(num_pairs, 1);
idx1_list = zeros(num_pairs, 1);
idx2_list = zeros(num_pairs, 1);

k = 1;
for i = 1:N
    for j = (i + 1):N
        % Squared distance is enough for sorting
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
num_sets = N;

% Iterate through sorted edges
for k = 1:length(sort_idx)
    idx = sort_idx(k);
    u = idx1_list(idx);
    v = idx2_list(idx);
    
    % Find root of u
    root_u = u;
    while parent(root_u) ~= root_u
        root_u = parent(root_u);
    end
    % Path compression for u
    temp = u;
    while parent(temp) ~= temp
        next_node = parent(temp);
        parent(temp) = root_u;
        temp = next_node;
    end
    
    % Find root of v
    root_v = v;
    while parent(root_v) ~= root_v
        root_v = parent(root_v);
    end
    % Path compression for v
    temp = v;
    while parent(temp) ~= temp
        next_node = parent(temp);
        parent(temp) = root_v;
        temp = next_node;
    end
    
    if root_u ~= root_v
        % Union
        parent(root_u) = root_v;
        num_sets = num_sets - 1;
        
        % Check if this was the last merge needed
        if num_sets == 1
            x1 = coords(u, 1);
            x2 = coords(v, 1);
            result = x1 * x2;
            % fprintf('Last connection between indices %d and %d\n', u, v);
           % fprintf('Coordinates: [%d, %d, %d] and [%d, %d, %d]\n', coords(u,:), coords(v,:));
            fprintf('Result: %d\n', result);
            break;
        end
    end
end
