% first three tasks only differ a little bit
% 1 - l2^2
% 2 - l2
% 3 - l1
version = 1;

for i = 2
    lambda = 10^(-3+i);
    U_max = 100;
    T = 80;
    
    % ------------------------------------------------------------------
    %     0       ?       ?       ?  ...    ?       15  | 
    %     5       ?       ?       ?  ...    ?      -15  |
    % ------------------------------------------------------------------
    %   x(1) -> x(2) -> x(3) -> x(4) ... x(79) -> x(80) | 81 values
    %       t(1)    t(2)    t(3)     ...     t(80)      | 80 values
    % ------------------------------------------------------------------

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
        variable x(4,T+1);
        variable u(2,T);
        
        delta = u(:, 2:T) - u(:, 1:T-1);        
        if version == 1
            minimize(sum(sum_square(E*x(:,tau+1) - w)) + lambda*sum(sum_square(delta))) 
        elseif version == 2
            % Not corrected
            minimize(sum(sum_square(E*x(:,tau+1) - w)) + lambda*norm(delta, 2));
        elseif version == 3
            % Not corrected
            minimize(sum(sum_square(E*x(:,tau+1) - w)) + lambda*norm(delta, 1));
        end
        
        subject to
            % Also set the speed to 0
            x(:,1)     == [p_initial; [0; 0]]
            x(:,T+1)   == [p_final;   [0; 0]]
            x(:,2:T+1) == A*x(:,1:T) + B*u(:,1:T);
            for ux = u
                norm(ux, 2) <= U_max; 
            end
        cvx_end
    
    % Check how many times the control signal changes 
    count = control_signal_changes(u);
    
    % Get the mean deviation
    meandev = sum(vecnorm(x(1:2, tau+1) - w, 2, 1)) / length(tau);
    
    % Plot the figures
    figure1=figure("Position", [50, 50, 1000, 400]);
    
    % Plot the waypoints and the robot position
    ax1 = subplot(1,2,1);
    hold(ax1,'on');
    scatter(p_initial(1), p_initial(2), "filled", 'd')
    scatter(p_final(1), p_final(2), "filled", 'd')
    scatter(x(1, :), x(2, :), 'o', 'MarkerEdgeColor', "blue");
    scatter(w(1, :), w(2, :), 300, "square", "MarkerEdgeColor", "red", 'LineWidth', 2);
    scatter(x(1, tau+1), x(2, tau+1), 200, 'o', 'MarkerEdgeColor', "magenta", 'LineWidth', 1.5);  
    title (sprintf('Pos for lambda = pow(10, %d)',(-3+i)));
    hold(ax1,'off');
    
    % Plot the control signal
    ax2 = subplot(1,2,2);
    hold(ax2,'on');
	plot(u(1,:));
    plot(u(2,:));
	title (sprintf('changed %d, dev %0.5f', count, meandev));
    hold(ax2,'off');    
end





