function [ S ] = Newton_method( X,Y,s0,r0,e )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
k=1;

S(:,1)=[s0;r0];
X(end+1,:)=-1;
f=@(x,s,y) (1/length(x))*sum(log(1+ exp(s'*x)) - y.*(s'*x));
d_f=@(x,s,y)(exp(s'*x)./(1+exp(s'*x))) - y ;
h=@(x,s) exp(s'*x)./((1+exp(s'*x)).^2) ;
while(1)
    g= X*(d_f(X,S(:,k),Y))'/length(X);
    grad_norm(k)=norm(g);
    if(norm(g) < e)
        break;
    else
        hess= X*diag(h(X,S(:,k)))*X'/length(X);
        d= -(hess)^-1*g;
        a(k)=1;
        while(1)
            cond2= f(X,S(:,k),Y)+(10^-4)*g'*(a(k)*d);
            cond1= f(X,S(:,k)+a(k)*d,Y);
            if(cond1<cond2)
                break;
            end
            a(k)=a(k)*0.5;
        end    
        S(:,k+1)=S(:,k)+a(k)*d;
        k=k+1;
    end
end
figure
semilogy(1:k,grad_norm);
xlabel('k');
title('to complete')
grid on;

figure

end

