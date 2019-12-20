function y = compute_nn_outputs(W, b, X)
n = 1;
zn = X;
% Use matrix operations
while n < size(W,2)
    zn = W{1,n}*zn + b{1,n};
    W_tmp = W{1,n};
    zn = (zn + abs(zn))/2;
    n = n+1;
end
zn = W{1,n}*zn + b{1,n};
W_tmp = W{1,n};
y = zn;

%%
% Start with z0 = X (which is a column vector, 6x1)
% Then take the first set of weights, W{1,1}, and multiply. It's 40x6
% This makes a 40x1, which you then add to a 40x1 b bias
% Then apply the linear thingy - for each of the 40 dimensions, 
% set to zero if it's negative
% take new z1 and premultiply by W{1,2}, which is 40x40
% another 40x1 - add b bias again
% Continue until the last layer - z5?
% 1x19 W * 19x1 z, gives scalar, add final scalar!!