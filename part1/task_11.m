tau = [10 25 30 40 50 60];
w   = [10 20 30 30 20 10;
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

U_max = 15;
T = 80;

results = [];
prev_x = zeros(4, T+1);

for m = [0:9]
    cvx_begin
        % Last dimension stores the m
        variable x(4,T+1);
        variable u(2,T);

        % The task 10 ? minimize(sum(norms(E*x(:,tau+1) - w, 2)));
        if m == 0
            minimize(sum(norms(E*x(:,tau+1) - w)));  
        else
            minimize(sum(norms(E*x(:,tau+1) - w) ./ (norms(E*prev_x(:,tau+1) - w) + 10^-6))); 
        end
        subject to
            % Initial and end speed need to be 0
            x(:,1)     == [p_initial; [0; 0]];
            x(:,T+1)   == [p_final;   [0; 0]];
            % Make sure that the robot moves using the contrains
            x(:,2:T+1) == A*x(:,1:T) + B*u(:,1:T);
            % Check the actuator force size
            for ux = u
                norm(ux, 2) <= U_max; 
            end
    cvx_end
    
    % Save the values for the next iteration
    prev_x = x;

    % Check how many times the control signal changes 
    count = control_signal_changes(u, T);

    captures = robot_waypoint_captures(x, w, tau);

    % Get the mean deviation
    meandev = sum(vecnorm(x(1:2, tau+1) - w, 2, 1)) / length(tau);

    % Save the values
    results = [results; [m, captures, meandev]];

    fig = figure('Units','Pixels', "Position", [0, 0, 1000, 450]);
    ax1 = subplot(1,2,1);
    hold(ax1,'on');
    grid on;
    scatter(p_initial(1), p_initial(2), "filled", 'd')
    scatter(p_final(1), p_final(2), "filled", 'd')
    scatter(x(1, :), x(2, :), 'o', 'MarkerEdgeColor', "blue");
    scatter(w(1, :), w(2, :), 300, "square", "MarkerEdgeColor", "red", 'LineWidth', 2);
    scatter(x(1, tau+1), x(2, tau+1), 200, 'o', 'MarkerEdgeColor', "magenta", 'LineWidth', 1.5);  
    axis([-2 34 -17 15])
    title(sprintf("robot position for m=%d", m));
    hold(ax1,'off');

    ax2 = subplot(1, 2, 2);
    hold(ax2,'on');
    grid on;
    plot(u(1,:));
    plot(u(2,:));
    title (sprintf('captured %d, dev %0.5f', captures, meandev));
    hold(ax2,'off');    

    ha=get(gcf,'children');
    set(ha(1),'position',[.51 .04 .47 .92]);
    set(ha(2),'position',[.02 .04 .47 .92]);
    legend(ax2, {'u_1(t)','u_2(t)'});
    fig.PaperSize = [fig.PaperPosition(3) fig.PaperPosition(4)];

    if m ~= -1
        filename = "figures/task11/task_11_" + m + ".pdf";        
        print(fig, filename, '-dpdf', '-bestfit');
    end
end
