% Number of discrete steps
t = 80;

% Maximum size of the force applied
umax=100;

% Waypoint positions
waypoints = [[10 10]; [20 10]; [30 10]; [30 0]; [20 0]; [10 -10]];
waypoint_times = [10 25 30 40 50 60];

% Initial and target location of the robot
pinitial = [0 5];
pfinal = [15 -15];

% Concat all of the points to plot them
all_points = [pinitial; waypoints; pfinal];

% Plot the graph
hold on
scatter(pinitial(1), pinitial(2), "filled", 'd')
scatter(pfinal(1), pfinal(2), "filled", 'd')
scatter(waypoints(:, 1), waypoints(:, 2))
plot(all_points(:, 1), all_points(:, 2))
legend("waypoint position")
hold off

A=[[1 0 0.1 0]; [0 1 0 0.1]; [0 0 0.9 0]; [0 0 0 0.9];];
B=[[0 0]; [0 0]; [0.1 0]; [0 0.1];];

% p(t) ... position at time t
% v(t) ... velocity at time t
% u(t) ... force applied at time t

% solve the optimization problem
cvx_begin quiet
    variable u(t, 2)
    % xi(t) ? R4 is state of robot i at discrete-time t = 0,1,2,...
    % Note that x(t) is a four-dimensional vector: x(t) ? R4, for 0 ? t ? T
    variable x(t, 4)
    
    minimize(loss_func(x, u, 10, waypoints, t));   % Optimize the position of the robot

    % Subject to:
    for ti = 1:(t-1)
        sx = x(ti, :);
        su = u(ti, :);
        sxt = x(ti+1, :);
        bt = B';
        sxt == A*sx + B*su';
    end
    
    % position of the robot matches the movement updates
    x(1) == pinitial;
    x(t) == pfinal;
    
    for i = 1:t
       norm(u(i)) <= umax;
    end   
cvx_end;


function loss = loss_func(x, u, l, w, t)
    E=[[1 0 0 0]; [0 1 0 0];];

    loss = 0;
    for k = 1:length(w)
        loss = loss + sum_square(E*x(k) - w(k));
    end
    
    for k = 1:t
       loss = loss + l*sum_square(u(t) - u(t-1)); 
    end
end