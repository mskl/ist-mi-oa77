for i = 1:7
    lambda = 10^(-3+i);
    U_max = 100;
    T = 80;
    t = T+1;
    
    %   0 ? t ? 80
    %   0    1    2 ...    79    80 = 81 values
    %   1    2    3 ...    80    81 = 81 values in matlab indexing
    % ----------------------------------------------------------- 
    % x(1) x(2) x(3)...  x(80) x(81)
    % ----------------------------------------------------------- 
    %   0                        15
    %   5                       -15
    
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

    cvx_begin
        variable x(4,t);
        variable u(2,t);

        % square elementwise and then sum the columns in a matrix 
        delta = [u, [0;0]] - [[0;0], u];
        minimize(square_pos(norm(E*x(:,tau) - w, 2)) + lambda*norm(delta, 2));
        subject to
            x(1:2,01) == p_initial % t=01
            x(1:2,81) == p_final   % t=81
            x(:,2:t)  == A*x(:,1:t-1) + B*u(:,1:t-1);
            for g = u
               norm(g, 2) <= U_max; 
            end
            cvx_end
    
    % Check how many times the control signal changes 
    count = control_signal_changes(u);
    
    % Get the mean deviation
    meandev = get_mean_dev(E, tau, x, w);
    
    % Plot the figures
    figure1=figure("Position", [50, 50, 1000, 400]);
    
    % Plot the waypoints and the robot position
    ax1 = subplot(1,2,1);
    hold(ax1,'on');
    scatter(p_initial(1), p_initial(2), "filled", 'd')
    scatter(p_final(1), p_final(2), "filled", 'd')
    scatter(x(1, :),x(2, :), 'o', 'MarkerEdgeColor', "blue");
    scatter(w(1, :), w(2, :), 300, "square", "MarkerEdgeColor", "red", 'LineWidth', 2);
    scatter(x(1, tau), x(2, tau), 200, 'o', 'MarkerEdgeColor', "magenta", 'LineWidth', 1.5);  
    title (sprintf('Pos for lambda = pow(10, %d)',(-3+i)));
    %xlim(ax1,[-1 31]);
    %ylim(ax1,[-16 11]);
    hold(ax1,'off');
    
    % Plot the control signal
    ax2 = subplot(1,2,2);
    hold(ax2,'on');
	plot(u(1,:));
    plot(u(2,:));
	title (sprintf('changed %d, dev %0.3f', count, meandev));
    hold(ax2,'off');    
end





