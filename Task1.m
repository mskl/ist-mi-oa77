%declaring variables & initialization
for i=1:7
    lambda= 10^(-3+i);
    T = 80;
    U_max = 100;
    p_initial = [0 ; 5];
    p_final = [15 ; -15];
    w = [10 20 30 30 20 10;
        10 10 10 0  0 -10 ];
    t = T;
    tau = [10 25 30 40 50 60];
    A = [1 0 0.1 0;
        0 1 0 0.1;
        0 0 0.9 0;
        0 0 0   0.9];
    B = [0   0;
        0   0;
        0.1 0;
        0   0.1];
    E = [1 0 0 0 ; % ITS THE ONLY WAY, otherwise matrix calculations wouldnt be possible
        0 1 0 0];

    cvx_begin
    variable x(4,t);
    variable u(2,t);
    % cost function-> i made a function so we could square elementwise and then sum the columns in a matrix 
    minimize(sum(vec_sqr_sum(E*x(:,tau) - w)) + lambda* sum (vec_sqr_sum(u(2:t-1)-u(1:t-2)))) 
    subject to
    x(1:2,1)== p_initial
    x(1:2,T)== p_final
    %for t = 1:79
    x(:,2:t) == A*x(:,1:t-1) + B*u(:,1:t-1);
    norm(u(:,1:t-1)) <= U_max
    %end
    cvx_end
    
    figure();
    plot(x(1,:),x(2,:));
    title (sprintf('Pos for lambda = %f',lambda));
    figure()
    plot(u(1,:),u(2,:));
    title (sprintf('Control Signal for lambda = %f',lambda));
    clear all
end