% Read input
fid = fopen("input.txt", "r");
lines = {};

while true
    line = fgetl(fid);
    if ~ischar(line)
        break;
    endif
    lines{end+1} = line;
endwhile
fclose(fid);

% Find grid dimensions
rows = length(lines);
cols = length(lines{1});

% Create matrix
grid = char(zeros(rows, cols));
for i = 1:rows
    grid(i, :) = lines{i};
endfor

% Find starting position S
start_col = 0;
start_row = 0;
for r = 1:rows
    c = find(grid(r, :) == 'S');
    if ~isempty(c)
        start_row = r;
        start_col = c(1);
        break;
    endif
endfor

active_cols = [start_col];
split_count = 0;

% Simulate downward movement row by row
for r = (start_row + 1):rows
    next_cols = [];
    current_active = unique(active_cols); % Ensure unique beams
    
    for i = 1:length(current_active)
        c = current_active(i);
        
        % Check bounds
        if c < 1 || c > cols
            continue;
        endif
        
        cell = grid(r, c);
        
        if cell == '^'
            % Splitter: beam stops, new beams at left and right
            split_count = split_count + 1;
            
            % Add left beam
            if c - 1 >= 1
                next_cols = [next_cols, c - 1];
            endif
            
            % Add right beam
            if c + 1 <= cols
                next_cols = [next_cols, c + 1];
            endif
        else
            % Empty space (or theoretically S if encountered): beam continues straight
            next_cols = [next_cols, c];
        endif
    endfor
    
    active_cols = next_cols;
    
    % If no beams left, stop
    if isempty(active_cols)
        break;
    endif
endfor

fprintf('Result: %d\n', split_count);
