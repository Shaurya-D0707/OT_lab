clc;
clear all;
%Steepest Descent 

syms x1
syms x2


% Define the symbolic function
f1 = x1 - x2 + 2*x1^2 + 2*x1*x2 + x2^2;

% Convert symbolic function to numerical function
fx = matlabFunction(f1, 'Vars', {x1, x2});
fobj = @(X) fx(X(1), X(2));

% Gradient and Hessian
grad = gradient(f1, [x1 x2]);
G1 = matlabFunction(grad, 'Vars', {x1, x2});
Gx = @(X) G1(X(1), X(2));

H1 = hessian(f1, [x1 x2]);
Hx = matlabFunction(H1, 'Vars', {x1, x2});

% Initialization
X0 = [0 0];
maxiter = 10;
tol = 1e-3;
iter = 0;
X = [];

% Steepest Descent Loop
while norm(Gx(X0)) > tol && iter < maxiter
    X = [X; X0];
    S = Gx(X0);
    H = Hx(X0);
    lambda = (S' * S) / (S' * H * S);
    Xnew = X0 - lambda * S';   % note: gradient descent subtracts the gradient direction
    X0 = Xnew;
    iter = iter + 1;
end

% Final output
X = [X; X0];
disp('Minimum point estimate:');
disp(X0);
