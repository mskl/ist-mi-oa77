function [S,r] = grad_descent(X,Y,s0,r0,e)
%grad_descent Summary of this function goes here
%   Detailed explanation goes here
k=1;
x1=X(1,:);
x2=X(2,:);
S(:,1)=s0;
r(1)=r0;
while(1)
    h_S=S(:,k)'*X -r(k);
    aux_exp= exp(h_S);
    f_s=1+aux_exp;
    aux_exp= aux_exp./(f_s) - Y;
    g= (1/length(X))*[sum(x1.*aux_exp) ; sum(x2.*aux_exp) ; sum(-aux_exp) ] ;
    grad_norm(k)=norm(g);
    if(norm(g) < e)
        break;
    else
        d(:,k)= -g;
        a(k)=1; %backtracking(1,10^-4,0.5);
        while(1)
            cond2=sum(log(f_s) - Y.*h_S) + g' *a(k) *d(:,k); 
            auxS=S(:,k) + a(k)*d(1:2,k);
            auxr=r(k) + a(k)*d(3,k);
            cond1=sum(log(1+exp(auxS'*X-auxr))-Y.*(auxS'*X-auxr))/length(X);
            if( cond1 < cond2)
                break;
            end
            a(k)=0.5*a(k);
        end
        S(:,k+1)= auxS;
        r(k+1)= auxr;
        k=k+1;
    end
end
figure
scatter(X(1,:),X(2,:),[],Y,'filled')
colormap flag
hold on
x=min(X(1,:)):0.01:max(X(1,:));
plot(x,(-S(1,end)*x +r(end))/S(2,end))

figure
%plot(1:1:k ,grad_norm)
%set(gca, 'YScale', 'log')
semilogy(1:k,grad_norm);
grid on;
end