% RUN BAB
tic
filename = 'property000.mat';
i = 1;
no_of_files = 500;
no_digits = 3;
FLAGS = NaN(1,500);
runtimes = zeros(1,500);
iterations = zeros(1,500);

options = optimset('linprog');
options.Display = 'off';

while i <= no_of_files
    numstr = leading_zeros(i,no_digits);
    filename(9:11) = numstr;
    load(filename)

%     [FLAGS(i), runtimes(i), iterations(i)] = ...
%         branch_and_bound_2(W,b,xmin,xmax);
     [FLAGS(i), runtimes(i), iterations(i), resets(i)] = ...
         branch_and_bound_3(W,b,xmin,xmax);
%      [FLAGS(i), runtimes(i)] = ...
%          branch_and_bound(W,b,xmin,xmax);
    txt = strcat('Number of properties completed: ', numstr);
    disp(txt)
    i = i + 1;
end

load('groundtruth.mat')
number_correct = (groundtruth == FLAGS);

total_runtime = sum(runtimes);