%% Task 2 
load data1.mat
tic
[S_1,R_1]=grad_descent(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc
figure
scatter(X(1,:),X(2,:),[],Y,'filled')
colormap flag
hold on
x=min(X(1,:)):0.01:max(X(1,:));
plot(x,(-S_1(1,end)*x +R_1(end))/S_1(2,end))

%% Task3
load data2.mat
tic;
[S_2,R_2]=grad_descent(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc
figure
scatter(X(1,:),X(2,:),[],Y,'filled')
colormap flag
hold on
x=min(X(1,:)):0.01:max(X(1,:));
plot(x,(-S_2(1,end)*x +R_2(end))/S_2(2,end))

%% Task4
load data3.mat
tic
[S_3,R_3]=grad_descent(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc
% Available
load data4.mat
tic
[S_4,R_4]=grad_descent(X,Y,-1*ones(length(X(:,1)),1),0,10^-6);
toc