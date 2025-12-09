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
grid = char(32 * ones(length(lines), max_len));
for i = 1:length(lines)
    line = lines{i};
    for j = 1:length(line)
        grid(i, j) = line(j);
    endfor
endfor

rows = size(grid, 1);
cols = size(grid, 2);

% Process from right to left
grand_total = 0;
right = cols + 1;

for left = cols:-1:1
    % Check if this column has an operator in the bottom row
    if grid(rows, left) == '+' || grid(rows, left) == '*'
        operation = grid(rows, left);
        
        % This marks the end of a problem block (from left to right-1)
        % Process columns in this block
        numbers = [];
        
        for col = left:(right-1)
            % Read this column top-to-bottom to form a number
            num = 0;
            for row = 1:(rows-1)
                ch = grid(row, col);
                if ch ~= ' '
                    digit = ch - '0';
                    num = num * 10 + digit;
                endif
            endfor
            
            if num > 0 || col == left  % Include 0 if it's the only digit
                numbers = [numbers; num];
            endif
        endfor
        
        % Calculate result
        if ~isempty(numbers)
            if operation == '+'
                result = sum(numbers);
            else
                result = prod(numbers);
            endif
            grand_total = grand_total + result;
        endif
        
        % Move to next problem
        right = left;
    endif
endfor

fprintf('Result: %d\n', grand_total);
