function [y_min, y_max] = linear_programming_bound(W,b,xmin,xmax)
xmin = xmin';
xmax = xmax';
layers = size(b,2);
input_size = size(W{1},2);

% First Pass (k=1)
% don't need to apply relu to the inputs, hence no A or b needed
% x = [z11, z12, x(1), x(2)]
z_min = xmin;
z_max = xmax;
A = [];
bnq = [];
layer_size = size(W{1},1); 
x_size = input_size + layer_size;
Aeq = [eye(layer_size), -W{1}];
beq = b{1};
ub = [Inf*ones(layer_size,1); xmax];
lb = [-Inf*ones(layer_size,1) ;xmin];
z_hat_min = zeros(layer_size,1);
z_hat_max = zeros(layer_size,1);
for i = 1:x_size
    f = zeros(x_size,1);
    f(i) = 1;
    tmp = linprog(f,A,bnq,Aeq,beq,lb,ub);
    z_hat_min(i) = tmp(i);
    f(i) = -1;
    tmp = linprog(f,A,bnq,Aeq,beq,lb,ub);
    z_hat_max(i) = tmp(i);
end
%for i = (layer_size + 1):(layer_size + input_size)
%    z_hat_max(i) = 

disp('zhat max first layer')
disp(z_hat_max)
disp('zhat min first layer')
disp(z_hat_min)

% Second Pass
