% Read input
fid = fopen("input.txt", "r");
data = fread(fid, "*char")';
fclose(fid);

inp = strsplit(data, ",");

% Use a set (implemented as a map) to track unique invalid numbers
invalid_nums = containers.Map('KeyType', 'double', 'ValueType', 'logical');

for k = 1:length(inp)
    ids = strtrim(inp{k});
    ranges = strsplit(ids, "-");
    A = str2double(ranges{1});
    B = str2double(ranges{2});

    % For each total number of digits
    for total_digits = 2:12
        % For each pattern length (must divide total_digits)
        for pattern_len = 1:floor(total_digits/2)
            % Check if pattern_len divides total_digits evenly
            if mod(total_digits, pattern_len) ~= 0
                continue;
            endif
            
            reps = total_digits / pattern_len;
            
            % Must repeat at least twice
            if reps < 2
                continue;
            endif
            
            % Calculate multiplier using geometric series formula
            if pattern_len == 1
                multiplier = (10^total_digits - 1) / 9;
            else
                multiplier = (10^total_digits - 1) / (10^pattern_len - 1);
            endif
            
            % Find X such that N = X * multiplier is in [A, B]
            lowX  = ceil(A / multiplier);
            highX = floor(B / multiplier);
            
            % X must have exactly pattern_len digits (no leading zeros)
            minX = 10^(pattern_len - 1);
            maxX = 10^pattern_len - 1;
            
            Xstart = max(lowX, minX);
            Xend   = min(highX, maxX);
            
            if Xstart <= Xend
                % Add each valid number to the set
                for X = Xstart:Xend
                    num = X * multiplier;
                    invalid_nums(num) = true;
                endfor
            endif
        endfor
    endfor
endfor

% Sum all unique invalid numbers
res = sum(cell2mat(keys(invalid_nums)));

fprintf('Result: %d\n', res);
