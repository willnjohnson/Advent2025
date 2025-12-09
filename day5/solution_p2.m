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

fclose(fid);

% Sort ranges by start position
[~, idx] = sort(ranges(:, 1));
ranges = ranges(idx, :);

% Merge overlapping ranges
merged = [];
current_start = ranges(1, 1);
current_end = ranges(1, 2);

for i = 2:size(ranges, 1)
    if ranges(i, 1) <= current_end + 1
        % Overlapping or adjacent - extend current range
        current_end = max(current_end, ranges(i, 2));
    else
        % Non-overlapping - save current range and start new one
        merged = [merged; current_start, current_end];
        current_start = ranges(i, 1);
        current_end = ranges(i, 2);
    endif
endfor

% Don't forget the last range
merged = [merged; current_start, current_end];

% Count total IDs in merged ranges
total_count = 0;
for i = 1:size(merged, 1)
    count = merged(i, 2) - merged(i, 1) + 1;
    total_count = total_count + count;
endfor

fprintf('Result: %d\n', total_count);
