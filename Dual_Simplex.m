clc
clear all
%Dual Simplex Method

cost = [-5 -6 0 0 0];
a = [-1 -1 1 0;
     -4 -1 0 1];
b = [-2; -4];
A = [a b];
bv = [3 4];

Var = {'x1','x2','s1','s2','sol'};

zjcj = cost(bv) * A - cost;
simplex_table = [zjcj; A];
Table = array2table(simplex_table, 'VariableNames', Var);
disp('Initial Simplex Table:')
disp(Table)

RUN = true;
while RUN
    if any(A(:, end) < 0)
        fprintf('\nCurrent solution is not feasible. Applying Dual Simplex...\n');

        %Check for Most -ve RHS
        [min_val, pivot_row] = min(A(:, end));
        fprintf('Most negative RHS value: %f at row %d\n', min_val, pivot_row);
         
        row = A(pivot_row, 1:end-1);
        zc = zjcj(1:end-1);

        ratio = inf(1, size(A, 2) - 1);  % Initialize Ratio to inf 

        %Calculation for Entering Variable: Min Ratio
        for j = 1:length(row)
            if row(j) < 0
                ratio(j) = abs(zc(j) / row(j));
            end
        end

        [min_ratio, pivot_col] = min(ratio);
        fprintf('Pivot column: %d, Min ratio: %.2f\n', pivot_col, min_ratio);

        bv(pivot_row) = pivot_col;

        % Row Operations
        pivot_key = A(pivot_row, pivot_col);
        A(pivot_row, :) = A(pivot_row, :) / pivot_key;

        for i = 1:size(A, 1)
            if i ~= pivot_row
                A(i, :) = A(i, :) - A(i, pivot_col) * A(pivot_row, :);
            end
        end

        %Update Zj - Cj row
        zjcj = cost(bv) * A - cost;

        % Show updated table
        next_table = [zjcj; A];
        Table = array2table(next_table, 'VariableNames', Var);
        disp(Table);

    else
        RUN = false;
        fprintf('\nOptimal solution found!\n');
        optimal_bfs = zeros(1, length(cost));
        optimal_bfs(bv) = A(:, end);
        chk = input('Enter 0 for min, 1 for max: ');
        if chk == 1
            optimal_value = zjcj(end);
        else 
            optimal_value = - zjcj(end);
        end

        fprintf('Optimal values:\n');
        for i = 1:length(Var)-1
            fprintf('%s = %.2f\n', Var{i}, optimal_bfs(i));
        end
        fprintf('Optimal objective value (Max Z): %.2f\n', optimal_value);
    end
end
