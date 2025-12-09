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
    
    % We need to select exactly 12 digits to maximize the number
    % Greedy approach: at each position, pick the largest digit that
    % still leaves enough digits to complete 12 total
    
    needed = 12;  % digits we need to select
    available = length(bank);  % total digits available
    selected = [];
    pos = 1;
    
    while needed > 0
        % We need 'needed' more digits
        % We have (available - pos + 1) digits left to choose from
        % We must leave at least (needed - 1) digits after this choice
        
        % Find the largest digit in the range where we can still pick it
        % We can pick from pos to (available - needed + 1)
        max_digit = -1;
        best_pos = pos;
        
        for j = pos:(available - needed + 1)
            digit = bank(j) - '0';
            if digit > max_digit
                max_digit = digit;
                best_pos = j;
            endif
        endfor
        
        % Select this digit
        selected = [selected, max_digit];
        needed = needed - 1;
        pos = best_pos + 1;
    endwhile
    
    % Convert selected digits to a number
    joltage = 0;
    for j = 1:length(selected)
        joltage = joltage * 10 + selected(j);
    endfor
    
    total = total + joltage;
endfor

fprintf('Result: %d\n', total);
