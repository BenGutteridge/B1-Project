% RUN LPB
tic
filename = 'property000.mat';
i = 1;
no_of_files = 50;
no_digits = 3;
y_upper_bounds = zeros(no_of_files, 1);
y_lower_bounds = zeros(no_of_files, 1);

while i <= no_of_files
    numstr = leading_zeros(i,no_digits);
    filename(9:11) = numstr;
    load(filename)

    [y_min, y_max] = linear_programming_bound(W,b,xmin,xmax);
    y_upper_bounds(i) = y_max;
    y_lower_bounds(i) = y_min;
    txt = strcat('Number of properties completed: ', numstr);
    disp(txt)
    i = i + 1;
end

avg_ub = mean(y_upper_bounds);
avg_lb = mean(y_lower_bounds);

% how many properties are proven true - i.e. have negative upper bounds
tmp = (y_upper_bounds - abs(y_upper_bounds))./(2*y_upper_bounds);
proven_true = sum(tmp);

% how many proven false - i.e. have positive lower bounds
tmp = (y_lower_bounds + abs(y_lower_bounds))./(2*y_lower_bounds);
proven_false = sum(tmp);
toc

%% NEED TO FIX:
% the upper bounds are coming out wrong. not a huge issue but why isn't it
% the same as aob's. Fix this.