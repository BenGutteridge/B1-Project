function [z_min, z_max] = linear_ReLU(z_hat_min, z_hat_max)

q = z_hat_max./(z_hat_max-z_hat_min);

f_ub = [-1;0;-1;0];
f_lb = [1;0;1;0];
%A = [-1 1;1 -q];
A = [-1 1 0 0;...
    1 -q(1) 0 0;...
    0 0 -1 1;...
    0 0 1 -q(2)];
b = [0;-z_hat_min(1).*q(1);0;-z_hat_min(2).*q(2)];
lb = [0;z_hat_min(1);0;z_hat_min(2)];
ub = [z_hat_max(1);z_hat_max(1);z_hat_max(2);z_hat_max(2)];

x_ub = linprog(f_ub,A,b,[],[],lb,ub);
z_max = [x_ub(1);x_ub(3)];

x_lb = linprog(f_lb,A,b,[],[],lb,ub);
z_min = [x_lb(1);x_lb(3)];