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

% DP State: Number of timelines at each column for the current row step
% Initially, 1 timeline enters just below S
current_counts = zeros(1, cols);
current_counts(start_col) = 1;

total_completed = 0;

% Iterate rows
for r = (start_row + 1):rows
    next_counts = zeros(1, cols);
    
    % Find active columns
    active_indices = find(current_counts > 0);
    
    for i = 1:length(active_indices)
        c = active_indices(i);
        count = current_counts(c);
        
        cell = grid(r, c);
        
        if cell == '^'
            % Split logic
            % Left branch
            if c - 1 >= 1
                next_counts(c - 1) = next_counts(c - 1) + count;
            else
                total_completed = total_completed + count;
            endif
            
            % Right branch
            if c + 1 <= cols
                next_counts(c + 1) = next_counts(c + 1) + count;
            else
                total_completed = total_completed + count;
            endif
        else
            % Pass through
            next_counts(c) = next_counts(c) + count;
        endif
    endfor
    
    current_counts = next_counts;
endfor

% Add particles that exited the bottom
total_completed = total_completed + sum(current_counts);

fprintf('Result: %.0f\n', total_completed);
