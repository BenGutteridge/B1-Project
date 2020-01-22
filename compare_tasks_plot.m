% final project time taken
% load('FINAL_RESULTS.mat')
% plot(runtimes)
% hold on
% plot(ones(1,500)*mean(runtimes))
% plot(ones(1,500)*129.6)
% load('FINAL_RESULTS_k=100000.mat')
% plot(runtimes)
% xlabel('Property')
% ylabel('Time Taken (s)')
% title('Improved branch and bound: time taken per property')
% legend('Time taken',...
%     strcat('Mean time taken (improved) = ', num2str(mean(runtimes))),...
%     strcat('Mean time taken (original) = ', num2str(18*60*60/500)),...
%     'Improved B&B, k = 100,000')



% compare task1 and task 2
% % clear
% load('lpb_y_lower_bounds')
% load('lpb_y_upper_bounds')
% y_ub_lpb = y_upper_bounds;
% y_lb_lpb = y_lower_bounds;
% % 
% % load('task1_results_500')
% % load('task2_results')
% % load('task1_results_10000')
% load('task1_results_1000')
% % 
% % 
% figure(1)
% %plot(task1_results_500.lb)
% hold on
% plot(task1_results_1000.lb)
% %plot(task1_results_10000.lb)
% plot(y_lower_bounds)
% plot(y_upper_bounds)
% plot(mean(y_lower_bounds)*ones(1,500))
% plot(mean(y_upper_bounds)*ones(1,500))
% 
% 
% 
% 
% 
% title('Comparing Unsound Method and Interval Bound Propagation')
% legend('Unsound Method: Lower bound on y* (k = 1000)',...
%     'Interval Bound Propagation: Lower bound on output',...
%     'Interval Bound Propagation: Upper bound on output',...
%     strcat('IBP Average LB = ', num2str(mean(y_lower_bounds))),...
%     strcat('IBP Average UB = ', num2str(mean(y_upper_bounds))),...
%     'LPB LB',...
%     'LPB UB')
% ylabel('Output')
% xlabel('Property')
% hold off

% figure(2)
% plot(task1_results_1000.lb, 'Color', [0.8500    0.3250    0.0980])
% hold on
% plot(y_lb_lpb)
% plot(y_ub_lpb, 'Color', [  0.4660    0.6740    0.1880])
% 
% 
% 
% title('Linear Programming')
% legend(...
%     'Unsound Method: LB on y*',...
%     'LPB UB (LB on y*)')
% ylabel('Output')
% xlabel('Property')

figure(4)
%axis([0 500 -400 350])
a = load('task2_results');
plot(a.y_lower_bounds)
hold on
plot(a.y_upper_bounds)
load('task1_results_1000');
plot(task1_results_1000.lb)
plot(mean(a.y_lower_bounds)*ones(1,500))
plot(mean(a.y_upper_bounds)*ones(1,500))



legend('IBP lower bound',...
    'IPB upper bound',...
    'Unsound method: y* lower bound, k=1000',...
    strcat('IBP Average LB = ', num2str(mean(a.y_lower_bounds))),...
    strcat('IBP Average UB = ', num2str(mean(a.y_upper_bounds))))
title('Comparing Unbound Method and Interval Bound Propagation')
xlabel('Property')
ylabel('Bounds')