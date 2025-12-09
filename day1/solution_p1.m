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
    
    % Apply rotation
    if direction == 'L'
        position = mod(position - distance, 100);
    else  % direction == 'R'
        position = mod(position + distance, 100);
    endif
    
    % Check if dial points at 0
    if position == 0
        zero_count = zero_count + 1;
    endif
endfor

fprintf('Result: %d\n', zero_count);
