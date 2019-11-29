tau = [10 25 30 40 50 60];
r   = [2  2  2  2  2  2]; 
c   = [10 20 30 30 20 10;
       10 10 10 0  0 -10];
A   = [1.0 0.0 0.1 0.0;
       0.0 1.0 0.0 0.1;
       0.0 0.0 0.9 0.0;
       0.0 0.0 0.0 0.9];
B   = [0.0 0.0;
       0.0 0.0;
       0.1 0.0;
       0.0 0.1];
E   = [1 0 0 0; 
       0 1 0 0];
   
p_initial = [ 0;   5];
p_final   = [15; -15];

lambda = 10^(-1);
U_max = 100;
T = 80;

cvx_begin
variable x(4,T+1);
variable u(2,T);

delta = u(:, 2:T) - u(:, 1:T-1);        

% distance == L2 norm
%   distance - r < 0 => distance < r == clip to 0 with max(0, negative)
%   distance - r > 0 => distance > r == return how far away from the circle

minimize(sum(max(0, vec_sqr_sum(c - x(1:2, tau+1)) - r)) + lambda*sum(norms(delta, 2)));

subject to
    % Initial and end speed need to be 0
    x(:,1)     == [p_initial; [0; 0]]
    x(:,T+1)   == [p_final;   [0; 0]]
    % Make sure that the robot moves using the contrains
    x(:,2:T+1) == A*x(:,1:T) + B*u(:,1:T);
    % Check the actuator force size
    for ux = u
        norm(ux, 2) <= U_max; 
    end
cvx_end

% Check how many times the control signal changes 
count = control_signal_changes(u, T);

% Get the mean deviation
circledev = sum(max(0, vecnorm(c - E*x(:, tau+1)) - r)) / length(tau);
centerdev = sum(vecnorm(x(1:2, tau+1) - c)) / length(tau);

% Plot the figures
fig = figure('Units','Pixels', "Position", [0, 0, 1000, 450]);

% Plot the waypoints and the robot position
ax1 = subplot(1,2,1);
axis equal
hold(ax1,'on');
grid on;
scatter(p_initial(1), p_initial(2), "filled", 'd')
scatter(p_final(1), p_final(2), "filled", 'd')
scatter(x(1, :), x(2, :), 'o', 'MarkerEdgeColor', "blue");
scatter(x(1, tau+1), x(2, tau+1), 200, 'o', 'MarkerEdgeColor', "magenta", 'LineWidth', 1.5);  
axis([-2 34 -17 15])
title(sprintf('Pos for lambda = 10\\^%d', (-1)));
% Plot the circles
for ci = 1:size(c, 2)
    circle(c(1, ci), c(2, ci), r(ci));
end
hold(ax1,'off');

% Plot the control signal
ax2 = subplot(1,2,2);
hold(ax2,'on');
grid on;
plot(u(1,:));
plot(u(2,:));
title(sprintf('changed %d, circledev %0.4f, centerdev %0.4f', count, circledev, centerdev));
hold(ax2,'off');

ha=get(gcf,'children');
set(ha(1),'position',[.51 .04 .47 .92]);
set(ha(2),'position',[.02 .04 .47 .92]);
legend(ax2, {'u_1(t)','u_2(t)'});
fig.PaperSize = [fig.PaperPosition(3) fig.PaperPosition(4)];

filename = "figures/task_6.pdf";        
print(fig, filename, '-dpdf', '-bestfit');
