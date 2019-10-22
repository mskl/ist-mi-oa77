%declaring variables & initialization
for i = 1:1
    lambda = 10^(-3+i);
    T = 80;
    t = T;
    U_max = 100;
    
    p_initial = [ 0;   5];
    p_final   = [15; -15];
    
    w = [10 20 30 30 20 10;
         10 10 10 0  0 -10 ];
    
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

        % cost function-> i made a function so we could square elementwise 
        % and then sum the columns in a matrix 
        minimize(sum(vec_sqr_sum(E*x(:,tau) - w)) + lambda* sum (vec_sqr_sum(u(2:t-1)-u(1:t-2)))) 
        subject to
            x(1:2,1) == p_initial
            x(1:2,T) == p_final
            x(:,2:t) == A*x(:,1:t-1) + B*u(:,1:t-1); % for t = 1:79
            norm(u(:,1:t-1)) <= U_max
    cvx_end
    
    % Plot the positions of the robot
    ax = axes('Parent',figure);
    hold(ax,'on');
    % The initial and end position
    scatter(p_initial(1), p_initial(2), "filled", 'd')
    scatter(p_final(1), p_final(2), "filled", 'd')
    % The waypoints
    scatter(w(1, :), w(2, :), 300, "square", "MarkerEdgeColor", "red", 'LineWidth', 2);
    % The positions
    scatter(x(1, :),x(2, :), 'o', 'MarkerEdgeColor', "blue");
    % The positions at tau - MIGHT BE WRONG BY 1
    scatter(x(1, tau), x(2, tau), 200, 'o', 'MarkerEdgeColor', "magenta", 'LineWidth', 1.5);  
    title (sprintf('Pos for lambda = %f',lambda));
    xlim(ax,[-1 31]);
    ylim(ax,[-16 11]);
    hold(ax,'off');
end

function [ norm_col ] = vec_sqr_sum(A)
%vec_sqr_sum squares elementwise and sums all the columns for a matrix 
    A= A.^2;
    for i= 1: length(A(1,:))
        aux=sum(A(:,i));
        norm_col(i) = aux;
    end
end