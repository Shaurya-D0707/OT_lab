clc
clear all
%Simplex Method

cost=[5 3 0 0 0];
a=[3 5 1 0; 5 2 0 1];
b=[15 ;10];
A=[a b];
bv=[3 4];
Var={'x1','x2','s1','s2','sol'};
zjcj=cost(bv)*A-cost;
simplex_table=[zjcj;A];
Table=array2table(simplex_table,'VariableNames',Var);
RUN=true;
while RUN
if any(zjcj(1:end-1)<0)
    fprintf('the current bfs is not optimal\n')
    fprintf('\n===the next iteration result===\n')
    zc=zjcj(1:end-1);
    [enter_val,pivot_col]=min(zc);

    if all(A(:,pivot_col)<=0)
        error ('LPP IS UNBOUNDED')
    else
        sol = A(:,end);
        column=A(:,pivot_col);
        for i=1:size(A,1)
            if column(i)>0
                ratio(i)=sol(i)/column(i);
            else
                ratio(i)=inf;
            end
        end
        [leaving_value,pivot_row]=min(ratio);
        fprintf('the min ratio element is %d corresponding to the row %d\n',leaving_value)
        fprintf('leaving variable is %d\n',pivot_row)
    end
bv(pivot_row)=pivot_col;
pvt_key=A(pivot_row,pivot_col);
A(pivot_row,:)=A(pivot_row,:)./pvt_key;
for i=1:size(A,1)
    if i~=pivot_row
A(i,:)=A(i,:)-A(i,pivot_col).*A(pivot_row,:);
    end
end
zjcj=cost(bv)*A-cost;
next_table=[zjcj;A];
Table=array2table(next_table,'VariableNames',Var);
BFS=zeros(1,size(A,2));
BFS(bv)=A(:,end);
BFS(end)=zjcj(end);
current_bfs=array2table(BFS,'VariableNames',Var);
else
    RUN=false;
    fprintf('the current BFs is optimal\n')
    z=input('enter o for min and 1 for max \n');
    if z==0
        obj_value=-zjcj(end);
    else
        obj_value=zjcj(end);
    end
    fprintf('the final optimal value is %f\n',obj_value)
end
end