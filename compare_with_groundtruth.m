function num_correct = compare_with_groundtruth(input)

% 1x500 vector of whether each state is proven true (1) by counter-example
% or false (0) by lack thereof

load('groundtruth.mat');

% n.b. 0 means counter-example, 1 means no counter-example
% for corresponding elements in input and gt:
% if gt = 0 and input = 0
%   counter-example found, brilliant
% if gt = 0 and input = 1
%   failed to find existing counter-example (true positive)
% if gt = 1 and input = 0
%   ERROR, a counter-example has been found where there is none (false
%   negative)
% if gt = 1 and input = 1
%   no counter-example found, but doesn't prove that there isn't one

% can combine these as binary, i.e the above four possibilities are
% 00, 01, 10, 11 (0-3) to get a vector of results below
results = input' + 2*groundtruth;

num_correct = sum((zeros(size(input'))) == results);
num_errors = sum((zeros(size(input'))+2) == results);
num_fails = sum((zeros(size(input'))+1) == results);
num_insufficient = sum((zeros(size(input'))+3) == results);
disp('No. of errors:')
disp(num_errors)
disp('No PROVEN FALSE:')
disp(num_correct)
disp('No INSUFFICIENTLY PROVEN TRUE:')
disp(num_insufficient)
disp('No. FAILED TO PROVE FALSE')
disp(num_fails)



