% Read input
fid = fopen("input.txt", "r");
data = fread(fid, "*char")';
fclose(fid);

lines = strsplit(strtrim(data), {'\r\n', '\n', '\r'});

total = 0;

% Process each bank
for i = 1:length(lines)
    bank = strtrim(lines{i});
    if isempty(bank)
        continue;
    endif
    
    max_joltage = 0;
    
    % Try each position as the first digit
    for pos1 = 1:(length(bank)-1)
        digit1 = bank(pos1) - '0';  % Convert char to number
        
        % Find the maximum digit after pos1
        max_digit2 = 0;
        for pos2 = (pos1+1):length(bank)
            digit2 = bank(pos2) - '0';
            if digit2 > max_digit2
                max_digit2 = digit2;
            endif
        endfor
        
        joltage = digit1 * 10 + max_digit2;
        if joltage > max_joltage
            max_joltage = joltage;
        endif
    endfor
    
    total = total + max_joltage;
endfor

fprintf('Result: %d\n', total);
