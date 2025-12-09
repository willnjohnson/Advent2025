% Read input
fid = fopen("input.txt", "r");
data = fread(fid, "*char")';
fclose(fid);

inp = strsplit(data, ",");

res = 0;

for k = 1:length(inp)
    ids = strtrim(inp{k});
    ranges = strsplit(ids, "-");
    A = str2double(ranges{1});
    B = str2double(ranges{2});

    for digits = 2:2:12
        half = digits / 2;

        p = 10^half + 1;    % multiplier to construct repeated-number

        % Find X such that N = X*10^half + X is inside [A, B]
        lowX  = ceil(A / p);
        highX = floor(B / p);

        % X must have exactly "half" digits
        minX = 10^(half-1);
        maxX = 10^half - 1;

        Xstart = max(lowX,  minX);
        Xend   = min(highX, maxX);

        if Xstart <= Xend
            count = Xend - Xstart + 1;
            sumX  = (Xstart + Xend) * count / 2;

            res += p * sumX;
        end
    end
end

fprintf('Result: %d\n', res);
