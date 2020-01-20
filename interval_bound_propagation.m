function [y_min, y_max] = interval_bound_propagation(W,b,x_min,x_max)

n = 1;  % current layer
zn_min = x_min';
zn_max = x_max';

while n < size(W,2)
    
    W_p = (W{1,n} + abs(W{1,n}))*0.5;
    W_n = (W{1,n} - abs(W{1,n}))*0.5;
    zn_max_hat = W_p*zn_max + W_n*zn_min + b{1,n};
    zn_min_hat = W_p*zn_min + W_n*zn_max + b{1,n};
    %ReLU
    zn_max = (zn_max_hat + abs(zn_max_hat))/2;
    zn_min = (zn_min_hat + abs(zn_min_hat))/2;
    % increment layer
    n = n+1;
end
% output layer (no ReLU)
W_p = (W{1,n} + abs(W{1,n}))/2;
W_n = (W{1,n} - abs(W{1,n}))/2;
y_max = W_p*zn_max + W_n*zn_min + b{1,n};
y_min = W_p*zn_min + W_n*zn_max + b{1,n};


