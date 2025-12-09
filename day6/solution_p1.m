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

% Find the maximum line length
max_len = 0;
for i = 1:length(lines)
    if length(lines{i}) > max_len
        max_len = length(lines{i});
    endif
endfor

% Create a grid (pad shorter lines with spaces)
grid = char(32 * ones(length(lines), max_len));  % 32 is space
for i = 1:length(lines)
    line = lines{i};
    for j = 1:length(line)
        grid(i, j) = line(j);
    endfor
endfor

rows = size(grid, 1);
cols = size(grid, 2);

% Identify problem columns (columns that are NOT all spaces)
problem_cols = [];
for col = 1:cols
    has_content = false;
    for row = 1:rows
        if grid(row, col) ~= ' '
            has_content = true;
            break;
        endif
    endfor
    if has_content
        problem_cols = [problem_cols, col];
    endif
endfor

% Group consecutive columns into problems
problems = {};
if ~isempty(problem_cols)
    start_col = problem_cols(1);
    for i = 2:length(problem_cols)
        % If there's a gap, we have a new problem
        if problem_cols(i) ~= problem_cols(i-1) + 1
            % Save previous problem
            problems{end+1} = [start_col, problem_cols(i-1)];
            start_col = problem_cols(i);
        endif
    endfor
    % Don't forget the last problem
    problems{end+1} = [start_col, problem_cols(end)];
endif

% Process each problem
grand_total = 0;

for p = 1:length(problems)
    col_range = problems{p};
    start_col = col_range(1);
    end_col = col_range(2);
    
    % Extract all numbers and operation from this problem's columns
    numbers = [];
    operation = '';
    
    for row = 1:rows
        % Get the entire row segment for this problem
        segment = strtrim(grid(row, start_col:end_col));
        
        if ~isempty(segment)
            if strcmp(segment, '+') || strcmp(segment, '*')
                operation = segment;
            else
                % Try to parse as number
                num = str2double(segment);
                if ~isnan(num)
                    numbers = [numbers; num];
                endif
            endif
        endif
    endfor
    
    % Calculate result for this problem
    if ~isempty(numbers) && ~isempty(operation)
        if operation == '+'
            result = sum(numbers);
        else  % operation == '*'
            result = prod(numbers);
        endif
        grand_total = grand_total + result;
    endif
endfor

fprintf('Result: %d\n', grand_total);
