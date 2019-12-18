% uses package CVX from http://cvxr.com/cvx
n = 10; % choose n = number of planes
a = sort(100*rand(n,1)); % generate landing intervals
b = a+10+5*rand(n,1);

figure(1); clf; % plot landing intervals
for i=1:n
    plot([a(i) b(i)],[ i i],'LineWidth',2); hold on;
end;
axis([ 0 max(b)+1 0 n+1 ]);

% solve optimization problem
cvx_begin quiet
    variable x(n,1);

    % build cost function
    f= x(2)-x(1);
    for i = 3:n
        f= min(f,x(i)-x(i-1));
    end;
    maximize(f);
    % subject t
    x(1:n-1) <= x(2:n); x >= a; x >= b;
cvx_end;
plot(x,1:n,'r.','MarkerSize',25); % plot solution