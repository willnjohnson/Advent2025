% Read input
fid = fopen('input.txt', 'r');

total_presses = 0;

while ~feof(fid)
    line = fgetl(fid);
    if ~ischar(line) || isempty(line)
        continue;
    end
    
    % Parse Buttons (...) to build Matrix A
    % The regex finds all (1,2,3) groups
    [btn_tokens] = regexp(line, '\(([\d,]+)\)', 'tokens');
    if isempty(btn_tokens)
        continue;
    end
    num_buttons = length(btn_tokens);
    
    % Parse Targets {...} to build Vector b
    [tgt_tokens] = regexp(line, '\{([\d,]+)\}', 'tokens');
    if isempty(tgt_tokens)
        continue;
    end
    tgt_str = tgt_tokens{1}{1};
    b_vec = str2double(strsplit(tgt_str, ','))';
    num_targets = length(b_vec);
    
    % Build A
    A = zeros(num_targets, num_buttons);
    for col = 1:num_buttons
        indices_str = btn_tokens{col}{1};
        parts = strsplit(indices_str, ',');
        for k = 1:length(parts)
            val = str2double(parts{k});
            row = val + 1; % 1-based indexing
            if row <= num_targets
                A(row, col) = 1;
            end
        end
    end
    
    % Setup ILP for glpk
    % Min c'*x subject to A*x = b, x >= 0, x integer
    
    c = ones(num_buttons, 1);
    
    % Constraint types: 'S' for Equality (Ax = b)
    ctype = repmat('S', num_targets, 1);
    
    % Variable types: 'I' for Integer
    vartype = repmat('I', num_buttons, 1);
    
    % Lower bounds: 0
    lb = zeros(num_buttons, 1);
    % Upper bounds: empty (Inf)
    ub = [];
    
    % Sense: 1 for Minimization
    sense = 1;
    
    % Run glpk
    % [xopt, fmin, errnum, extra] = glpk (c, A, b, lb, ub, ctype, vartype, sense)
    [x, fmin, errnum] = glpk(c, A, b_vec, lb, ub, ctype, vartype, sense);
    
    if errnum == 0
        total_presses = total_presses + fmin;
    end
end

fclose(fid);

fprintf('Result: %d\n', total_presses);
