task = 7;

% Needs to be at least 39 to work
% The motor is too weak to find a feasible solution
U_max = 39;
T = 80;
t = T+1;

p_initial = [ 0;   5];
p_final   = [15; -15];

w   = [10 20 30 30 20 10;
       10 10 10 0  0 -10];
tau = [10 25 30 40 50 60];

A = [1.0 0.0 0.1 0.0;
     0.0 1.0 0.0 0.1;
     0.0 0.0 0.9 0.0;
     0.0 0.0 0.0 0.9];
B = [0.0 0.0;
     0.0 0.0;
     0.1 0.0;
     0.0 0.1];
E = [1 0 0 0 ; 
     0 1 0 0];

cvx_begin
variable x(4,t);
variable u(2,t);

% there might be a problem with the last index
delta = [u, [0;0]] - [[0;0], u];

if (task == 7)
    minimize(0);
elseif (task == 8) 
    % theta is non-convex, dumb me
    minimize(sum(theta(E*x(:, tau) - w)))
end

subject to
    x(:,1)    == [p_initial; [0; 0]]
    x(:,t)    == [p_final;   [0; 0]]
    x(:,2:t)  == A*x(:,1:t-1) + B*u(:,1:t-1);
    
    for g = u
       norm(g, 2) <= U_max; 
    end
    
    if (task == 7)
        for ti = 1:length(tau)
            E*x(:, tau(ti)) ==  w(:, ti)
        end
    end
    cvx_end

count = control_signal_changes(u);
centerdev = get_mean_dev(tau, x, w);

% Plot the figures
figure1=figure("Position", [50, 50, 1000, 400]);

% Plot the waypoints and the robot position
ax1 = subplot(1,2,1);
hold(ax1,'on');
scatter(p_initial(1), p_initial(2), "filled", 'd')
scatter(p_final(1), p_final(2), "filled", 'd')
scatter(x(1, :), x(2, :), 'o', 'MarkerEdgeColor', "blue");
scatter(x(1, tau), x(2, tau), 200, 'o', 'MarkerEdgeColor', "magenta", 'LineWidth', 1.5);  
title (sprintf('Pos'));
hold(ax1,'off');

% Plot the control signal
ax2 = subplot(1,2,2);
hold(ax2,'on');
plot(u(1,:));
plot(u(2,:));
title (sprintf('changed %d, centerdev %0.3f', count, centerdev));
hold(ax2,'off');


