clc
clear all
%Simplex Method - Big M

% Define Big M
M = 1000;

% Cost vector (including artificial variables with -M penalty)
cost = [-2 -1 0 0 -M -M 0];

% Constraint matrix with slack and artificial variables
A = [3 1  0  0  1  0  3;
     4 3 -1  0  0  1  6;
     1 2  0  1  0  0  3];

% Initial Basis (artificial variables and slack)
bv = [5 6 4];  

% Variable names
Var = {'x1','x2','s1','s2','A1','A2','sol'};

% Calculate Zj - Cj
zjcj = cost(bv)*A - cost;

% Initial Simplex Table
simplex_table = [zjcj; A];
Table = array2table(simplex_table, 'VariableNames', Var)

% Start iterations
RUN = true;
while RUN
    if any(zjcj(1:end-1)<0)
        fprintf('The current BFS is not optimal.\n')
        fprintf('\n=== Next Iteration ===\n')

        % Find entering variable (most negative Zj - Cj)
        zc = zjcj(1:end-1);
        [enter_val, pivot_col] = min(zc);

        if all(A(:, pivot_col) <= 0)
            error('LPP is unbounded');
        else
            sol = A(:, end);
            column = A(:, pivot_col);
            ratio = zeros(size(A, 1), 1);

            for i = 1:size(A, 1)
                if column(i) > 0
                    ratio(i) = sol(i) / column(i);
                else
                    ratio(i) = inf;
                end
            end

            [leaving_val, pivot_row] = min(ratio);
            fprintf('Pivot element is in row %d\n', pivot_row);

            % Update basis
            bv(pivot_row) = pivot_col;
            pivot_key = A(pivot_row, pivot_col);

            % Row operations
            A(pivot_row, :) = A(pivot_row, :) / pivot_key;
            for i = 1:size(A, 1)
                if i ~= pivot_row
                    A(i, :) = A(i, :) - A(i, pivot_col) * A(pivot_row, :);
                end
            end

            % Update Zj - Cj
            zjcj = cost(bv) * A - cost;
            next_table = [zjcj; A];
            Table = array2table(next_table, 'VariableNames', Var)

            % Print current BFS
            BFS = zeros(1, size(A, 2));
            BFS(bv) = A(:, end);
            BFS(end) = zjcj(end);
            current_bfs = array2table(BFS, 'VariableNames', Var)
        end
    else
        RUN = false;
        fprintf('The current BFS is optimal.\n');
        z = input('Enter 0 for minimization or 1 for maximization: ');

        if z == 0
            obj_value = -zjcj(end);
        else
            obj_value = zjcj(end);
        end
        fprintf('The final optimal value is: %f\n', obj_value);
    end
end