% plotting_over_k
k = 1;
max_k = 50;
avg_times = zeros(1,max_k);
avg_lbs = zeros(1,max_k);
counterexamples = zeros(1,max_k);
while k <= max_k
    x = run_nn(k);
    avg_times(k) = x.avg_time;
    avg_lbs(k) = x.average_lb;
    counterexamples(k) = x.num_correct;
    k=k+1;
end
figure('Name', 'Average Time Taken')
plot(avg_times)
title('Average Time Taken per property')
xlabel('k (number of test inputs)')
ylabel('Average time (s)')
figure('Name', 'Average Lower Bound')
plot(avg_lbs)
title('Average Lower Bound across varying number of input sets')
xlabel('k (number of test inputs)')
ylabel('Average lower bound')
figure('Name', 'Counter-Examples')
plot(counterexamples)
title('Number of properties proven false by counter-example')
xlabel('k (number of test inputs)')
ylabel('Number of properties')
