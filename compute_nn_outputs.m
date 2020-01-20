function y = compute_nn_outputs(W, b, X)
n = 1;  %current layer
zn = X;
while n < size(W,2)
    zn = W{1,n}*zn + b{1,n};    % apply weights and biases
    zn = (zn + abs(zn))/2;      % ReLU function
    n = n+1;
end
zn = W{1,n}*zn + b{1,n};        % ReLU not present at output
y = zn;
end