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

% Count accessible rolls
% A roll is accessible if it has fewer than 4 adjacent rolls
accessible_count = 0;

% Define 8 directions (row_offset, col_offset)
directions = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

for i = 1:rows
    for j = 1:cols
        % Check if this position has a roll
        if grid(i, j) == '@'
            % Count adjacent rolls
            adjacent_rolls = 0;
            
            for d = 1:8
                ni = i + directions(d, 1);
                nj = j + directions(d, 2);
                
                % Check bounds
                if ni >= 1 && ni <= rows && nj >= 1 && nj <= cols
                    if grid(ni, nj) == '@'
                        adjacent_rolls = adjacent_rolls + 1;
                    endif
                endif
            endfor
            
            % If fewer than 4 adjacent rolls, it's accessible
            if adjacent_rolls < 4
                accessible_count = accessible_count + 1;
            endif
        endif
    endfor
endfor

fprintf('Result: %d\n', accessible_count);
