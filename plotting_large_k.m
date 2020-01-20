% plotting_large_k
max_power = 6;
for i = 1:max_power
    k = 10^i;
    x = run_nn(k);
    avg_times(i) = x.avg_time;
    avg_lbs(i) = x.average_lb;
    counterexamples(i) = x.num_correct;
end
figure('Name', 'Average Time Taken')
semilogx(10.^[1:max_power], avg_times)
title('Average Time Taken per property')
xlabel('k (number of test inputs)')
ylabel('Average time (s)')
figure('Name', 'Average Lower Bound')
semilogx(10.^[1:max_power], avg_lbs)
title('Average Lower Bound across varying number of input sets')
xlabel('k (number of test inputs)')
ylabel('Average lower bound')
figure('Name', 'Counter-Examples')
semilogx(10.^[1:max_power], counterexamples)
title('Number of properties proven false by counter-example')
xlabel('k (number of test inputs)')
ylabel('Number of properties')