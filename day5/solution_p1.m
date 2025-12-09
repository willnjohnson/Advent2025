% Read input line by line
fid = fopen("input.txt", "r");

% Read ranges
ranges = [];
while true
    line = fgetl(fid);
    if ~ischar(line)
        break;  % EOF
    endif
    
    line = strtrim(line);
    if isempty(line)
        break;  % Found blank line
    endif
    
    parts = strsplit(line, '-');
    range_start = str2double(parts{1});
    range_end = str2double(parts{2});
    ranges = [ranges; range_start, range_end];
endwhile

% Read ingredient IDs
ingredient_ids = [];
while true
    line = fgetl(fid);
    if ~ischar(line)
        break;  % EOF
    endif
    
    line = strtrim(line);
    if ~isempty(line)
        id = str2double(line);
        ingredient_ids = [ingredient_ids; id];
    endif
endwhile

fclose(fid);

% Check which ingredients are fresh
fresh_count = 0;

for i = 1:length(ingredient_ids)
    id = ingredient_ids(i);
    is_fresh = false;
    
    % Check if ID falls in any range
    for j = 1:size(ranges, 1)
        if id >= ranges(j, 1) && id <= ranges(j, 2)
            is_fresh = true;
            break;
        endif
    endfor
    
    if is_fresh
        fresh_count = fresh_count + 1;
    endif
endfor

fprintf('Result: %d\n', fresh_count);
