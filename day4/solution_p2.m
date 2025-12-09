% Read input
fid = fopen("input.txt", "r");
data = fread(fid, "*char")';
fclose(fid);

lines = strsplit(strtrim(data), {'\r\n', '\n', '\r'});

% Build grid
rows = length(lines);
cols = 0;
for i = 1:rows
    if length(lines{i}) > cols
        cols = length(lines{i});
    endif
endfor

% Create grid
grid = char(zeros(rows, cols));
for i = 1:rows
    line = lines{i};
    for j = 1:length(line)
        grid(i, j) = line(j);
    endfor
endfor

% Define 8 directions (row_offset, col_offset)
directions = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% Function to count adjacent rolls for a position
function count = count_adjacent(grid, i, j, rows, cols, directions)
    count = 0;
    for d = 1:8
        ni = i + directions(d, 1);
        nj = j + directions(d, 2);
        
        if ni >= 1 && ni <= rows && nj >= 1 && nj <= cols
            if grid(ni, nj) == '@'
                count = count + 1;
            endif
        endif
    endfor
endfunction

% Keep removing accessible rolls until no more can be removed
total_removed = 0;
changed = true;

while changed
    changed = false;
    
    % Find all accessible rolls in this iteration
    to_remove = [];
    
    for i = 1:rows
        for j = 1:cols
            if grid(i, j) == '@'
                adjacent_rolls = count_adjacent(grid, i, j, rows, cols, directions);
                
                if adjacent_rolls < 4
                    to_remove = [to_remove; i, j];
                endif
            endif
        endfor
    endfor
    
    % Remove all accessible rolls
    if ~isempty(to_remove)
        changed = true;
        for k = 1:size(to_remove, 1)
            grid(to_remove(k, 1), to_remove(k, 2)) = '.';
            total_removed = total_removed + 1;
        endfor
    endif
endwhile

fprintf('Result: %d\n', total_removed);
