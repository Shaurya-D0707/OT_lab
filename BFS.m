clc
clear all
format short 

%%Phase 1: Input Parameters
c = [2 3 4 7];
A = [2 3 -1 4; 1 2 6 -7];
b = [8; -3];

%c = [2 3];
%A = [2 3; 1 1; 5 6];
%b = [8;-3;4];
%%Phase 2: Find Dimensions
n = size(A,2); %Unknowns
m = size(A, 1); %Constraints

if n>m
    nCm = nchoosek(n,m); %Total no. of basic solutions 
    p=nchoosek(1:n,m); %Pairs of basic Solutions
    sol = [];
    for i=1:nCm
        y=zeros(n,1);
        A1 = A(:,p(i,:));
        X=A1\b; %IMPORTANT: use "\", not "/"
        %Feasibility Conditions
        if all(X>=0 & X ~=Inf & X~=-Inf)
            y(p(i,:)) = X; %Find all possible BFS
            sol = [sol y];
        end 
    end 
else
error("No. of Variables are less than the Constraints.")
end

%%Phase 3: Solve Objective Function
Z = c*sol;
[obj, index] = max(Z); %Find Optimal Value of Z
BFS = sol(:, index); %Find Optimal Solution

optval = [BFS' obj];
opt_BFS = array2table(optval,'VariableNames',{'x1','x2','x3','x4','Z'})

