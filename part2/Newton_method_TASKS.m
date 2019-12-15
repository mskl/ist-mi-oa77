map = [1 0 0
       0 0 1];
%% Task 2 
load data1.mat
tic
[S_1]=Newton_method(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc
figure
scatter(X(1,:),X(2,:),[],Y,'o')
colormap(map)
hold on
x=min(X(1,:)):0.01:max(X(1,:));
plot(x,(-S_1(1,end)*x +S_1(end,end))/S_1(2,end),'--','color','green')
xlim([x(1)+0.05 x(end)+0.05])
ylim([-inf +inf])
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')

%% Task3
load data2.mat
tic;
[S_2]=Newton_method(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc
figure
scatter(X(1,:),X(2,:),[],Y,'o')
colormap(map)
hold on
x=min(X(1,:)):0.01:max(X(1,:));
plot(x,(-S_2(1,end)*x +S_2(end,end))/S_2(2,end),'--','color','green')
xlim([x(1)+0.05 x(end)+0.05])
ylim([-inf +inf])
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')

%% Task4
load data3.mat
tic
[S_3]=Newton_method(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc
% Available
load data4.mat
tic
[S_4]=Newton_method(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc