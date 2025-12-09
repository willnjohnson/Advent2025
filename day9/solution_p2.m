% Read input
data = dlmread('input.txt', ',');

x = data(:, 1);
y = data(:, 2);
N = length(x);

% Construct Edges
% Edges connect i to i+1 (and N to 1)
% Identify if Vertical or Horizontal
v_edges_x = [];
v_edges_y1 = [];
v_edges_y2 = [];

h_edges_y = [];
h_edges_x1 = [];
h_edges_x2 = [];

for i = 1:N
    j = mod(i, N) + 1;
    x1 = x(i); y1 = y(i);
    x2 = x(j); y2 = y(j);
    
    if x1 == x2
        % Vertical
        if y1 ~= y2 % Ignore zero length if any
             v_edges_x(end+1) = x1;
             v_edges_y1(end+1) = min(y1, y2);
             v_edges_y2(end+1) = max(y1, y2);
        end
    elseif y1 == y2
        % Horizontal
        if x1 ~= x2
             h_edges_y(end+1) = y1;
             h_edges_x1(end+1) = min(x1, x2);
             h_edges_x2(end+1) = max(x1, x2);
        end
    else
        error('Diagonal connection found! Tiles must be aligned.');
    end
end

% Flatten arrays for vectorization
v_x = v_edges_x(:);
v_y1 = v_edges_y1(:);
v_y2 = v_edges_y2(:);

h_y = h_edges_y(:);
h_x1 = h_edges_x1(:);
h_x2 = h_edges_x2(:);

max_area = 0;

% Iterate over all pairs
for i = 1:N
    for j = (i+1):N
        
        x_min = min(x(i), x(j));
        x_max = max(x(i), x(j));
        y_min = min(y(i), y(j));
        y_max = max(y(i), y(j));
        
        width = x_max - x_min + 1;
        height = y_max - y_min + 1;
        area = width * height;
        
        if area <= max_area
            continue;
        end
        
        % Check 1: Edge Intersections
        % A polygon edge intersects the rectangle's INTERIOR
        
        % Vertical edges crossing the rectangle horizontally?
        % Vertical edge at vx, range [vy1, vy2]
        % Crosses if x_min < vx < x_max AND y interval overlaps (y_min, y_max)
        % Overlap cond: max(vy1, y_min) < min(vy2, y_max)
        
        tc_v = (v_x > x_min) & (v_x < x_max); % Strictly between X
        if any(tc_v)
             % Check Y overlap for these candidates
             overlaps_v = (max(v_y1(tc_v), y_min) < min(v_y2(tc_v), y_max));
             if any(overlaps_v)
                 continue;
             end
        end
        
        % Horizontal edges crossing the rectangle vertically?
        % Horizontal edge at hy, range [hx1, hx2]
        % Crosses if y_min < hy < y_max AND x interval overlaps (x_min, x_max)
        
        tc_h = (h_y > y_min) & (h_y < y_max); % Strictly between Y
        if any(tc_h)
             overlaps_h = (max(h_x1(tc_h), x_min) < min(h_x2(tc_h), x_max));
             if any(overlaps_h)
                 continue;
             end
        end
        
        % Check 2: Center Inside Polygon
        % Midpoint
        mx = (x_min + x_max) / 2;
        my = (y_min + y_max) / 2;
        
        % Ray casting to the right (increasing x)
        % Count vertical edges where:
        % 1. edge X > mx
        % 2. edge Y range covers my (vy1 <= my <= vy2) -> since my is .5, strict < is fine vs endpoints
        %    vy1 <= my < vy2 standard definition
        
        crossings = (v_x > mx) & (v_y1 <= my) & (v_y2 > my);
        num_crossings = sum(crossings);
        
        if mod(num_crossings, 2) == 1
            % Inside!
            max_area = area;
        end
    end
end

fprintf('Result: %d\n', max_area);
