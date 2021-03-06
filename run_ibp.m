% run interval bound propagation
tic
filename = 'property000.mat';
i = 1;
no_of_files = 500;
no_digits = size(num2str(no_of_files),2);
y_upper_bounds = zeros(no_of_files, 1);
y_lower_bounds = zeros(no_of_files, 1);

while i <= no_of_files
    numstr = leading_zeros(i,no_digits);
    filename(9:11) = numstr;
    load(filename)

    [y_min, y_max] = interval_bound_propagation(W,b,xmin,xmax);
    y_upper_bounds(i) = y_max;
    y_lower_bounds(i) = y_min;
    
    i = i + 1;
end

avg_ub = mean(y_upper_bounds);
avg_lb = mean(y_lower_bounds);

% how many properties are proven true - i.e. have negative upper bounds
tmp = (y_upper_bounds - abs(y_upper_bounds))./(2*y_upper_bounds);
proven_true = sum(tmp);
time = toc;