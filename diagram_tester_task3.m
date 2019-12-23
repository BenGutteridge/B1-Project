% diagram_tester_task3
% x = [z1; z1_hat; x(1); x(2)]

%% LAYER 1 NODE 1
Aeq = [0 1 -1 -1];
beq = 2;
z_hat_max = 6;
z_hat_min = -2;
q = z_hat_max/(z_hat_max - z_hat_min);   % so i guess we need to do this as well
A=zeros(4,4);
A(1:2,1:2) = [1 -q;-1 1];
b = [-q*z_hat_min;0;0;0];
ub = [z_hat_max;z_hat_max;2;2];
lb = [0;z_hat_min;-2;-2];
f_ub=[-1;0;0;0];
f_lb=[1;0;0;0];

x_ub = linprog(f_ub,A,b,Aeq,beq,lb,ub);
z11_ub = x_ub(1);
x_lb = linprog(f_lb,A,b,Aeq,beq,lb,ub);
z11_lb = x_lb(1);

%% LAYER 1 NODE 2
Aeq = [0 1 -1 1];
beq = 1;
z_hat_max = 5;
z_hat_min = -3;
q = z_hat_max/(z_hat_max - z_hat_min);   % so i guess we need to do this as well
A=zeros(4,4);
A(1:2,1:2) = [1 -q;-1 1];
b = [-q*z_hat_min;0;0;0];
ub = [z_hat_max;z_hat_max;2;2];
lb = [0;z_hat_min;-2;-2];
f_ub=[-1;0;0;0];
f_lb=[1;0;0;0];

x_ub = linprog(f_ub,A,b,Aeq,beq,lb,ub);
z12_ub = x_ub(1);
x_lb = linprog(f_lb,A,b,Aeq,beq,lb,ub);
z12_lb = x_lb(2);

%% LAYER 2 NODE 1

% x = [z2; z2_hat; z1(1); z1(2); x(1); x(2)]

Aeq = [0 1 -3 1 0 0;];
beq = 1;
z_hat_max = 19;
z_hat_min = -4;
q = z_hat_max/(z_hat_max - z_hat_min);   % so i guess we need to do this as well
A=zeros(4,4);
A(1:2,1:2) = [1 -q;-1 1];
b = [-q*z_hat_min;0;0;0];
ub = [z_hat_max;z_hat_max;2;2];
lb = [0;z_hat_min;-2;-2];
f_ub=[-1;0;0;0];
f_lb=[1;0;0;0];

x_ub = linprog(f_ub,A,b,Aeq,beq,lb,ub);
z21_ub = x_ub(1);
x_lb = linprog(f_lb,A,b,Aeq,beq,lb,ub);
z21_lb = x_lb(1);

%% LAYER 2 NODE 2
Aeq = [0 1 -1 -2];
beq = 3;
z_hat_max = 19;
z_hat_min = 3;  % they're both positive - gotta do something special
q = z_hat_max/(z_hat_max - z_hat_min);
A=zeros(4,4);
A(1:2,1:2) = [1 -q;-1 1];
b = [-q*z_hat_min;0;0;0];
ub = [z_hat_max;z_hat_max;2;2];
lb = [0;z_hat_min;-2;-2];
f_ub=[-1;0;0;0];
f_lb=[1;0;0;0];

x_ub = linprog(f_ub,[],[],Aeq,beq,lb,ub);
z22_ub = x_ub(1);
x_lb = linprog(f_lb,A,b,Aeq,beq,lb,ub);
z22_lb = x_lb(1);