function [count] = control_signal_changes(u, T)
    delta = u(:, 2:T) - u(:, 1:T-1);        
    count = sum(norms(delta, 2) > 10^-6);
end
