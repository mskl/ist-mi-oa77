results = [];
T = 80;

p_initial = [ 0;   5];
p_final   = [15; -15];

w = [10 20 30 30 20 10;
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
 
U_max = 15;

for task = [7 9 10]
    cvx_begin
        variable x(4,T+1);
        variable u(2,T);

        delta = u(:, 2:T) - u(:, 1:T-1);   

        % Feasibility problem
        if (task == 7)     
            % minimize(U_max); returns 38.8989
            minimize(0);
        % Theoretical question where ve prove that theta is non-convex
        elseif (task == 8) 
            % minimize(sum(theta(E*x(:, tau+1) - w)))
        % The L_2^2 norm
        elseif (task == 9)
            minimize(sum(vec_sqr_sum(E*x(:,tau+1) - w)));
        % The L_2 norm
        elseif (task == 10)
            minimize(sum(norms(E*x(:,tau+1) - w, 2)));
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
            if (task == 7)
                for ti = 1:length(tau)
                    E*x(:, tau(ti)) ==  w(:, ti);
                end
            end
        cvx_end

    % Check how many times the control signal changes 
    count = control_signal_changes(u, T);

    captures = robot_waypoint_captures(x, w, tau);

    % Get the mean deviation
    meandev = sum(vecnorm(x(1:2, tau+1) - w, 2, 1)) / length(tau);

    % Save the values
    results = [results; [-1, count, meandev]];

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
    title("robot position");
    hold(ax1,'off');

    ax2 = subplot(1, 2, 2);
    hold(ax2,'on');
    grid on;
    plot(u(1,:));
    plot(u(2,:));
    title (sprintf('changed %d, captures %d, dev %0.5f', count, captures, meandev));
    hold(ax2,'off');    

    ha=get(gcf,'children');
    set(ha(1),'position',[.51 .04 .47 .92]);
    set(ha(2),'position',[.02 .04 .47 .92]);
    legend(ax2, {'u_1(t)','u_2(t)'});
    fig.PaperSize = [fig.PaperPosition(3) fig.PaperPosition(4)];

    filename = "figures/task_" + task + ".pdf";        
    print(fig, filename, '-dpdf', '-bestfit');
end

