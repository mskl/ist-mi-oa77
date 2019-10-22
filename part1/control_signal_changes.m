function [count] = control_signal_changes(u)
    % t = 1 to t = T ? 1 = (1...79)
    u_shift = [[0;0], u];                       % Prepend 0 to the u array
    deltas = u_shift(1:79) - u(1:79);           % Subtract u(t) - u(t-1)
    count = sum(vecnorm(deltas, 2, 1) > 10^-6); % Count boolean values
end
