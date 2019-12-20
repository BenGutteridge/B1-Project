W{1} = [1 1;1 -1];
W{1} = [1 1;1 -1];
W{2} = [3 -1;1 2];
W{3} = [3 -2];
b{1} = [2;1];
b{2} = [1;3];
b{3} = 0;

k = 1;
X = generate_inputs([-2 -2], [2 2], k);

value = compute_nn_outputs(W,b,X);