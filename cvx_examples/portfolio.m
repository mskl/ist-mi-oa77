% portfolio.m; uses package CVX from http://cvxr.com/cvx
n = 10; % number of stocks
r = 1+0.3*rand(n-1,1); % generate random returns
r=[r;1];%thelastoneisarisk?freeasset
T = 1000; % set budget

% solve the optimization problem
cvx begin quiet
    variable x(n);
    maximize(r'*x);

    %subject to
    x >= 0;
    sum(x) == T;
    for i = 1:n
        for j = i+1:n
            x(i) + x(j) <= 0.8*T;
        end;
    end;
cvx end;

figure(1); clf; % plot solution
subplot(1,2,1); stem(r,'LineWidth',5);
title('rates of return r');
subplot(1,2,2); stem(x,'r','LineWidth',5);
title('optimal portfolio x');
%print ?depsc portfolioexample;