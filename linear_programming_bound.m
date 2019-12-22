function [y_min, y_max] = linear_programming_bound(W,b,x_min,x_max)

n = 1;
zn_min = x_min';
zn_max = x_max';

% Use matrix operations
while n < size(W,2)
    
    W_p = (W{1,n} + abs(W{1,n}))*0.5;
    W_n = (W{1,n} - abs(W{1,n}))*0.5;
    zn_max_hat = W_p*zn_max + W_n*zn_min + b{1,n};
    zn_min_hat = W_p*zn_min + W_n*zn_max + b{1,n};
    
    [zn_min,zn_max] = linear_ReLU(zn_min_hat, zn_max_hat);
    
    n = n+1;
end

W_p = (W{1,n} + abs(W{1,n}))/2;
W_n = (W{1,n} - abs(W{1,n}))/2;
y_max = W_p*zn_max + W_n*zn_min + b{1,n};
y_min = W_p*zn_min + W_n*zn_max + b{1,n};


