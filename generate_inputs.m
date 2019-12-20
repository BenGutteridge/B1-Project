function output = generate_inputs(xmin, xmax, k)
input_size = 6;
% n.b. xmin and xmax are column vectors
output = ((rand(k,input_size).*(xmax - xmin)) + xmin)';


