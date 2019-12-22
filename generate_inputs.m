function output = generate_inputs(xmin, xmax, k, input_vector_size)
% n.b. xmin and xmax are column vectors
output = ((rand(k,input_vector_size).*(xmax - xmin)) + xmin)';


