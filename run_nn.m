% Run the Program
function outputs = run_nn(k)

filename = 'property000.mat';
i = 1;
no_of_files = 500;
input_vector_size = 6;
no_digits = size(num2str(no_of_files),2);
y_star_lb = zeros(no_of_files, 1);
results = zeros(no_of_files, 1);
tic
while i <= no_of_files
    numstr = leading_zeros(i,no_digits);
    filename(9:11) = numstr;
    load(filename)

    X = generate_inputs(xmax, xmin, k, input_vector_size);
    y = compute_nn_outputs(W,b,X);
    y_star_lb(i) = max(y);
    %mean_lb(i) = mean(y);
    
    % if lower bound is positive, property proven false by counter-example
    if y_star_lb(i) <= 0
            results(i) = 1;
    else
            results(i) = 0;
    end
    i = i + 1;
end
time = toc;
outputs.avg_time = time/no_of_files;
outputs.average_lb = mean(y_star_lb);
outputs.num_correct = compare_with_groundtruth(results);


% TODO
% Plot avg time
% Plot avg lower bound
% Plot no. of properties for which counter-example is found

