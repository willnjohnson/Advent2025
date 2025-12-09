% Read the input file
fid = fopen('input.txt', 'r');
lines = textscan(fid, '%s');
fclose(fid);
lines = lines{1};

% Initialize dial position and counter
position = 50;
zero_count = 0;

% Process each rotation
for i = 1:length(lines)
    instruction = lines{i};
    
    % Parse direction and distance
    direction = instruction(1);
    distance = str2num(instruction(2:end));
    
    % Count how many times we pass through 0 during this rotation
    % Count each click, not just the final position
    if direction == 'L'
        % Moving left (decreasing)
        for step = 1:distance
            position = mod(position - 1, 100);
            if position == 0
                zero_count = zero_count + 1;
            endif
        endfor
    else  % direction == 'R'
        % Moving right (increasing)
        for step = 1:distance
            position = mod(position + 1, 100);
            if position == 0
                zero_count = zero_count + 1;
            endif
        endfor
    endif
endfor

fprintf('Result: %d\n', zero_count);
