clc
clear all
%Transportation Problems

c = [11 20 7 8; 21 16 10 12; 8 12 18 9];
a = [50 40 70];
b = [30 25 35 40];
m = size(c,1);
n = size(c,2);

if sum(a)==sum(b)
    fprinttf('Given transportation problem is unbalanced \n');
else 
    fprintf('Given transporation problem is unbalanced \n');
    if sum(a)<sum(b)
        c(end+1,:) = zeros(1,length(b));
        a(end+1) = sum(b)-sum(a);
    else
        c(:,end+1) = zeros(length(a),1);
        b(end+1) = sum(a) - sum(b)
    end
end

X = zeros(m,n);
InitialC = c;
BFS = m+n-1
for i =1:size(c,1)
    for j = 1:size(c,2)
cpq = min(c(:))


[p1,q1] = find(cpq == c)
xpq = min(a(p1),b(q1))
[val,ind] = max(xpq)
p = p1(ind)
q = q1(ind)
Y = min(a(p),b(q))
X(p,q) = Y
a(p) = a(p) - Y
b(q) = b(q) - Y
c(p,q) = Inf

    end
end

array2table(X)

TotalBFS = length(nonzeros(X))
if TotalBFS==BFS
    fprintf('initial BFS is Non-Degenerate\n')
else
    fprintf('Initial BFS is Degenerate\n')
end
z=0
for i=1:size(c,1)
    for j=1:size(c,2)
        z=z+InitialC(i,j)*X(i,j)
    end
end
fprintf('Min Cost is %f\n',z)


