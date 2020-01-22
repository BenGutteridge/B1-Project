function [flag, bab_time, i] = branch_and_bound_2(W, b, xmin, xmax)
tic
%% ORDER
% set up output bounds for the whole domain (regular lpb)
%while:
    % find the max of the upper bounds (just 1 at first), 
    % if it's negative we've proved the thing true
    % if we can't prove it true this way we create new subdomains
    % find the longest dimension with s function
    % define new x input max and mins - two of them, for the two subdomains
    % fill up the x1 and x2 vectors accoriding to rules in the notes
    % find the bounds of the new subdomains using lpb
    % see if the lower bounds are positive, if so we've got a false property
    % update subdomain input bounds (XMIN and XMAX)
    % update subdomain output bounds
% at the end
RESTART = 1;
RESTARTED = 0;

% flag for whether we have reached a definitive answer
COMPLETE = 0;

% how the bounds are determined in each partitioning
LOWER = 2;
UPPER = 1;
% 0: Unsound Method
% 1: Interval Bound Propagation
% 2: Linear Programming Bound
% initiating
flag = NaN;

while RESTART == 1
RESTART = 0;

% set up output bounds for the whole domain
if UPPER == 2
    [ymin, ymax] = linear_programming_bound(W,b,xmin,xmax);
elseif UPPER == 1
    [ymin, ymax] = interval_bound_propagation(W,b,xmin,xmax);
end
YMAX = ymax;
YMIN = ymin;
XMIN = xmin;
XMAX = xmax;

i = 0;
while COMPLETE == 0
    if i == 500
        %UPPER = 2;
        RESTART = 1;
        RESTARTED = 1;
        disp('RESETTING')
        flag = NaN;
        bab_time = toc
        COMPLETE = 1;
        break
    end
    i = i + 1;
    disp(strcat('Iteration: ',num2str(i)))
    % idx is the index of the subdomain with the largest output ub, xbar
    [ymax, idx1] = max(YMAX);
    if ymax < 0
        COMPLETE = 1;
        % proven true
        flag = 1;
        break
    end
    xbarmin = XMIN(idx1,:);
    xbarmax = XMAX(idx1,:);
    
% if we can't prove it true this way we create new subdomains
    % idx2 is index of dimension with longest relative length
    S = (xbarmax-xbarmin)./(xmax-xmin);
    [~, idx2] = max(S);
    
    % x1bar and x2bar are xbar split up so the lower one x1bar shares its
    % min with xbar and x2bar shares its max with xbar
    x1barmin = xbarmin;
    x2barmax = xbarmax;
    
    % why does this look like an average
    x1barmax = xbarmax;
    x2barmin = xbarmin;
    x1barmax(idx2) = (xbarmin(idx2) + xbarmax(idx2))/2;
    x2barmin(idx2) = (xbarmin(idx2) + xbarmax(idx2))/2;

    
    % find the bounds of the new subdomains using lpb
    if UPPER == 2
        [y2min, y2max] = ...
            linear_programming_bound(W, b, x2barmin, x2barmax);
        [y1min, y1max] = ...
            linear_programming_bound(W, b, x1barmin, x1barmax);
    
    elseif UPPER == 1
        [y2min, y2max] = ...
            interval_bound_propagation(W, b, x2barmin, x2barmax);
        [y1min, y1max] = ...
            interval_bound_propagation(W, b, x1barmin, x1barmax);
    
    else
        
    end
        
    
    
    % see if we have found a counter-example
    if (y1min > 0) || (y2min > 0)
        flag = 0;
        COMPLETE = 1;
        break
    end

    % if not, we create a new partiion. split xbar into x1bar and x2bar
    % and run again!
    
    % update subdomain input bounds (XMIN and XMAX)
    XMIN = [...
        XMIN(1:idx1-1,:); ...
        x1barmin;...
        x2barmin;...
        XMIN(idx1+1:size(XMIN,1),:)...
        ];

    XMAX = [...
        XMAX(1:idx1-1,:); ...
        x1barmax;...
        x2barmax;...
        XMAX(idx1+1:size(XMAX,1),:)...
        ];
  
     % update subdomain output bounds
     YMIN = [...
        YMIN(1:idx1-1,:); ...
        y1min;...
        y2min;...
        YMIN(idx1+1:size(YMIN,1))...
        ];

    YMAX = [...
        YMAX(1:idx1-1,:); ...
        y1max;...
        y2max;...
        YMAX(idx1+1:size(YMAX,1))...
        ];
    
end

end
if RESTARTED == 1
    disp('Restarted')
end
if flag == 1
    disp('Property is true, no counter-example exists')
elseif flag == 0
    disp('Property is false, a counter-example exists')
else
    disp('error')
end
bab_time = toc
end