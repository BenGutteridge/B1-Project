% Run the Program
filename = 'property000.mat';
i = 1;
k = 100;
no_of_files = 500;
no_digits = size(num2str(no_of_files),2);
mean_lb = zeros(no_of_files, 1);
results = zeros(no_of_files, 1);
tic
while i <= no_of_files
    numstr = leading_zeros(i,no_digits);
    filename(9:11) = numstr;
    load(filename)

    X = generate_inputs(xmax, xmin, k);
    y = compute_nn_outputs(W,b,X);
    mean_lb(i) = mean(y);
    checker = y + abs(y);
    % ie the negative ones become zero, only positive ones nonzero
%     if sum(abs(checker)) == 0
%         disp('Property is true (no counter-example exists)')
%     else
%         disp('Property is false (counter-examples exist)')
%     end
    if sum(abs(checker)) == 0
        results(i) = 1;
    else
        results(i) = 0;
    end
    i = i + 1;
end
time = toc;
average_time = time/no_of_files;

final_results = compare_with_groundtruth(results);


% TODO
% Sort out the 000 thing
% 

