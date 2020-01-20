W{1} = [1 1;1 -1];
W{2} = [3 -1;1 2];
W{3} = [3 -2];
b{1} = [2;1];
b{2} = [1;3];
b{3} = 0;
x_min = [-2;-2];
x_max = [2;2];

% Task 1
k = 1;
input_vector_size = 2;
X = generate_inputs(x_min', x_max', k, input_vector_size);

value = compute_nn_outputs(W,b,X);

% Task 2
[y_min_t2, y_max_t2] = interval_bound_propagation(W, b, x_min', x_max');

% Task 3
[ymin, ymax] = linear_programming_bound(W, b, x_min, x_max);
