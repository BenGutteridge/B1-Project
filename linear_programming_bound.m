% function [y_min, y_max] = linear_programming_bound(W,b,xmin,xmax)
function [z_hat_min, z_hat_max] = linear_programming_bound(W,b,xmin,xmax)
xmin = xmin';
xmax = xmax';
layers = size(b,2);
input_size = size(W{1},2);

% First Layer (k=1)
% don't need to apply relu to the inputs, hence no A or b needed
% x = [zhat11, zhat12, x(1), x(2)]
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

disp('zhat max first layer')
disp(z_hat_max)
disp('zhat min first layer')
disp(z_hat_min)

z_hat_min = num2cell(z_hat_min, [1,2]);
z_hat_max = num2cell(z_hat_max, [1,2]);

% Second Layer
% x = [zhat21, zhat22, z11, z12, zhat11, zhat12, x(1), x(2)]
old_x_size = x_size;
% need todo these two
A = [];
bnq = [];
old_layer_size = layer_size;
layer_size = size(W{2},1); 
x_size = old_x_size + old_layer_size + layer_size;
Aeq = blkdiag([eye(layer_size), -W{2}],Aeq);
beq = [b{2}; beq];
ub = [Inf*ones(layer_size,1); max(0,z_hat_max{1}(1:old_layer_size)); ...
    z_hat_max{1}];
lb = [-Inf*ones(layer_size,1); max(0,z_hat_min{1}(1:old_layer_size));...
    z_hat_min{1}];


% gradient and y intercept
m = z_hat_max{1}./(z_hat_max{1} - z_hat_min{1});
m = min(max(0,m),1);
M = diag(m(1:old_layer_size));
c = -z_hat_min{1}.*m;
c = max(c,0);
c = c(1:old_layer_size);

A = zeros(layer_size*3,x_size);
% z > 0
A(1:layer_size, layer_size+1:old_layer_size+layer_size) = ...
    -eye(old_layer_size);
% z > z_hat
A(1+layer_size:2*layer_size, layer_size+1:old_layer_size+layer_size) = ...
    -eye(old_layer_size);
A(1+layer_size:2*layer_size, 2*layer_size+1:2*old_layer_size+layer_size) = ...
    eye(old_layer_size);
% z < m*z_hat + c
A(1+2*layer_size:3*layer_size, 2*layer_size+1:2*old_layer_size+layer_size) = ...
    -M;
A(1+2*layer_size:3*layer_size, layer_size+1:old_layer_size+layer_size) = ...
    eye(old_layer_size);

bnq = [zeros(2*layer_size,1);c];

for i = 1:x_size
    f = zeros(x_size,1);
    f(i) = 1;
    tmp = linprog(f,A,bnq,Aeq,beq,lb,ub);
    if isempty(tmp)
        break
    end
    z_hat_min{2}(i) = tmp(i);
    f(i) = -1;
    tmp = linprog(f,A,bnq,Aeq,beq,lb,ub);
    z_hat_max{2}(i) = tmp(i);
end