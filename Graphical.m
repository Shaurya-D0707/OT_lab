clc
clear all
format rat

%% Insert the coefficient matrix and right hand side matrix
A=[1,2;1,1;1,-2];
b=[10;6;1];
C=[2;1];

%% Phase 2: Plotting the graph
x1=0:1:max(b);

x21 = (b(1) - A(1,1)* x1)/ A(1,2);
x22 = (b(2) - A(2,1)* x1)/ A(2,2);
x23 = (b(3) - A(3,1)* x1)/ A(3,2);

x21 = max(0, x21);
x22 = max(0, x22);
x23 = max(0, x23);
plot(x1, x21, 'r', x1, x22, 'k', x1, x23, 'b');

xlabel('Value of x1');
ylabel('Value of x2');
title('x1 vs x2');
legend('x1 +2x2 = 10', 'x1 +x2 = 6', 'x1-2x2 =12');
%% Find corner point with axes, that is line intercept
cx1=find(x1==0);
c1=find(x21==0);

line1=[x1([c1,cx1]);x21([c1,cx1])];

c2=find(x22==0);

line2=[x1([c2,cx1]);x22([c2,cx1])];

c3=find(x23==0);

line3=[x1([c3,cx1]);x23([c3,cx1])];

line1=line1';
line2=line2';
line3=line3';

corpt=unique([line1;line2;line3],'rows');

%% Phase 4: Intersection points of constraints
pt=[0;0];
for i=1:size(A,1)
    for j=i+1:size(A,1)
        A1=A([i,j],:);
        B1=b([i j]);
        x=A1\B1;
        pt=[pt x];
    end
end
ptt=pt';
allpt=[ptt;corpt];

points=unique(allpt,'rows');


%% Feasible Points
for i=1:size(points,1)
    const1(i)=A(1,1)*points(i,1)+A(1,2)*points(i,2)-b(1);
    const2(i)=A(2,1)*points(i,1)+A(2,2)*points(i,2)-b(2);
    const3(i)=A(3,1)*points(i,1)+A(3,2)*points(i,2)-b(3);
end

s1=find(const1>0);
s2=find(const2>0);
s3=find(const3>0);

s=unique([s1 s2 s3]);

points(s,:)=[];

%% Objective function value
value= points*C;
table=[points value];
[obj,index]=max(value);

x1=points(index,1);
x2=points(index,2);

fprintf('objective value is %f at (%f,%f)',obj,x1,x2)
