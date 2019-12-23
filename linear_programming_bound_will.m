% WILL'S
%% MAIN FUNCTION
function [ymin, ymax] = linear_programming_bound_will(W, b, xmin, xmax,no_layers)
    % initialise the first set of bounds
    z_hat_min = {xmin'};
    z_hat_max = {xmax'};
    lb = {};
    ub = {};
    
   
    % loops 5 times, once per layer
    for layer_idx = 1:no_layers
        % box_bounds produces upper and lower bounds for a particular layer 
        [lb{layer_idx}, ub{layer_idx}] = box_bounds(z_hat_min, z_hat_max, ...
            b, layer_idx);
        % the input is 6 elements. The second layer is 40. The ub and lb we
        % now have are 46 long, with 40 +/- infs and then the bounds of the
        % input
        % this should give us some idea of our x vector - namely i think
        % the first 40 elements must be the 40 elements of the first layer
        % while the final 6 represent the inputs
        [Aeq, beq] = get_eq(W, b, layer_idx);
        [A, ble] = get_ineq(W, b, z_hat_min, z_hat_max, layer_idx, no_layers);
        
        l = length(b{layer_idx});
        % what seems to be happening here is making a second element in the
        % z_hat_min cell which is the sam as the first, ie just the input
        % ranges, but then chucking 40 zeros at the start of it
        z_hat_min{layer_idx+1} = [zeros(l, 1); z_hat_min{layer_idx}]';
        z_hat_max{layer_idx+1} = [zeros(l, 1); z_hat_max{layer_idx}]';
        if layer_idx == 2
            throwaway = 1;
        end
        
        % it's an L not a one
        % as in it's a goddamn linprog for every element, maximising or
        % minimising that element each time
        for idx=1:l
            f = get_f(length(lb{layer_idx}), idx);
            tmp = linprog(f, A, ble, Aeq, beq, ...
                          lb{layer_idx}, ub{layer_idx});
            z_hat_min{layer_idx+1}(idx) = tmp(idx);
            
            f = -f;
            tmp = linprog(f, A, ble, Aeq, beq, ...
                          lb{layer_idx}, ub{layer_idx});
            z_hat_max{layer_idx+1}(idx) = tmp(idx);
        end
        z_hat_max{layer_idx+1} = z_hat_max{layer_idx+1}';
        z_hat_min{layer_idx+1} = z_hat_min{layer_idx+1}';
    end
    
    ymin = z_hat_min{no_layers+1}(1);
    ymax = z_hat_max{no_layers+1}(1);
    
end

%% BOX BOUNDS
function [l_bound, u_bound] = box_bounds(z_hat_min, z_hat_max, b, layer_idx)
    % so it's the entire set of input bounds - the one element in the cell
    % is the bound vector
    lb_cell = {z_hat_min{1}};
    ub_cell = {z_hat_max{1}};
    
    % loops 2-5
    % okay so this step is skipped on the first go, from x to z1
    for idx=2:layer_idx
       output_size = length(z_hat_min{idx}) - length(z_hat_min{idx-1});
       z_min = z_hat_min{idx}(1:output_size);
       z_max = z_hat_max{idx}(1:output_size);
       
       lb_cell{2*idx-2} = z_min;
       ub_cell{2*idx-2} = z_max;
       lb_cell{2*idx-1} = max(z_min, 0);
       ub_cell{2*idx-1} = max(z_max, 0);
       s = size(ub_cell{2*idx-2});
       inf_vec = Inf * ones(s(1), 1);
    end
    % s is the size of the idx-th weight vector
    s = size(b{layer_idx});
    % making a vector of ininities with same dimensions as the bias vec?
    inf_vec = Inf * ones(s(1), 1);
    % putting the vector of infinities in the lb and ub cells, before the
    % actual ones from the previous layer
    lb_cell{2*layer_idx} = -inf_vec;
    ub_cell{2*layer_idx} =  inf_vec;
    
    lb_cell = flip(lb_cell);
    ub_cell = flip(ub_cell);
    
    % turns the cell into one vector
    l_bound = vertcat(lb_cell{:});
    u_bound = vertcat(ub_cell{:});
end

%% get_eq
function [Aeq, beq] = get_eq(W, b, layer_idx)
% this one is for applying the weights and biases - ie the equations
    Aeq_cell = {};
    for idx=1:layer_idx
        [n_rows, n_cols] = size(W{idx});
        Aeq_cell{idx} = [eye(n_rows), -W{idx}];
    end
    Aeq_cell = flip(Aeq_cell);
    Aeq = blkdiag(Aeq_cell{:});
    % so what we've made here is a matrix of all of the weights - diagonal
    % for the first 40, i.e. the 40 elements of the first layer, and then
    % the last 6 is W(1), except negative because this has to be Ax < b and
    % both the inputs and the first layer variables are in x
    % beq is literally just the bias vector for the first layer extracted
    % from b
    beq = vertcat(b{layer_idx:-1:1});
end

%% get_ineq
function [A, ble] = get_ineq(W, b, z_hat_min, z_hat_max, layer_idx, no_layers)
    A_cell = {};
    ble_cell = {};
    for idx=2:layer_idx
        [n_rows, n_cols] = size(b{idx-1});
        M = get_M(z_hat_min, z_hat_max, b, idx);
        c = get_c(z_hat_min, z_hat_max, b, idx);
        
        A_cell{idx} = [-eye(n_rows), zeros(n_rows);
                       -eye(n_rows), eye(n_rows);
                        eye(n_rows), -M];
        ble_cell{idx} = [zeros(2*n_rows, 1); c];
    end
    
    A_cell = flip(A_cell);
    ble_cell = flip(ble_cell);
    
    A = blkdiag(A_cell{:});
    [A_rows, A_cols] = size(A);
    
    if length(A)
        [b_rows, b_cols] = size(b{layer_idx});
        Z_left = zeros(A_rows, b_rows);

        Z_right = zeros(A_rows, no_layers+1);

        A = [Z_left, A, Z_right];
    end
    
    ble = vertcat(ble_cell{:});
end

function M = get_M(z_hat_min, z_hat_max, b, layer_idx)
    output_size = length(b{layer_idx-1});
    z_min = z_hat_min{layer_idx}(1:output_size);
    z_max = z_hat_max{layer_idx}(1:output_size);
    m = z_max./(z_max - z_min);
    m = min(max(m, 0), 1);
    M = diag(m);
end

function c = get_c(z_hat_min, z_hat_max, b, layer_idx)
    output_size = length(b{layer_idx-1});
    z_min = z_hat_min{layer_idx}(1:output_size);
    z_max = z_hat_max{layer_idx}(1:output_size);
    m = z_max./(z_max - z_min);
    m = min(max(m, 0), 1);
    c = - m .* z_min;
    c = max(0, c);
end

function f = get_f(len, idx)
    f = zeros(len, 1);
    f(idx) = 1;
end
