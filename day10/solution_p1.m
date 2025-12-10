% Read input
fid = fopen('input.txt', 'r');

total_min_presses = 0;

while ~feof(fid)
    line = fgetl(fid);
    if ~ischar(line) || isempty(line)
        continue;
    end
    
    % Parse Target State [##..]
    tokens = regexp(line, '\[([#\.]+)\]', 'tokens');
    if isempty(tokens)
        continue;
    end
    lights_str = tokens{1}{1};
    L = length(lights_str);
    target = zeros(L, 1);
    for i = 1:L
        if lights_str(i) == '#'
            target(i) = 1;
        end
    end
    
    % Parse Buttons (...)
    [btn_tokens] = regexp(line, '\(([\d,]+)\)', 'tokens');
    num_buttons = length(btn_tokens);
    
    % Matrix A: Each column is a button
    A = zeros(L, num_buttons);
    
    for b = 1:num_buttons
        indices_str = btn_tokens{b}{1};
        % Split by comma
        parts = strsplit(indices_str, ',');
        for k = 1:length(parts)
            val = str2double(parts{k});
            % Indices are 0-based in problem, convert to 1-based for Octave
            idx = val + 1;
            if idx >= 1 && idx <= L
                A(idx, b) = 1;
            end
        end
    end
    
    % Find minimum presses
    % Solve Ax = target (mod 2)
    [L, num_buttons] = size(A);
    
    % Vectorized Brute Force
    % Generate all 2^N combinations
    % X will be num_buttons x 2^num_buttons
    num_combinations = 2^num_buttons;
    vals = 0:(num_combinations - 1);
    
    % Create combinatorics matrix X efficiently
    X = zeros(num_buttons, num_combinations);
    for b = 1:num_buttons
        X(b, :) = bitget(vals, b);
    end
    
    % Calculate all outcomes at once: Res = A * X (mod 2)
    Res = mod(A * X, 2);
    
    % Find columns that match target
    % Compare Res (L x 2^N) with target (L x 1)
    % Using bsxfun for compatibility, though modern Octave handles broadcasting
    Matches = all(bsxfun(@eq, Res, target), 1);
    
    if any(Matches)
        % Filter X to only matching columns
        MatchingX = X(:, Matches);
        % Calculate presses (hamming weight) for matches
        presses = sum(MatchingX, 1);
        min_presses = min(presses);
        
        total_min_presses = total_min_presses + min_presses;
    end
end

fclose(fid);

fprintf('Result: %d\n', total_min_presses);
