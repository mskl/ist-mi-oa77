function [S,r] = grad_descent(X,Y,s0,r0,e)
%grad_descent Summary of this function goes here
%   Detailed explanation goes here
k=1;

S(:,1)=s0;
r(1)=r0;
aux_ones=-1*ones(1,length(X));
while(1)
    h_S=S(:,k)'*X -r(k);
    aux_exp= exp(h_S);
    f_s=1+aux_exp;
    aux_exp= aux_exp./(f_s) - Y;
    
    g = X*aux_exp';
    g=[g; sum(-aux_exp)] / length(X);

    grad_norm(k)=norm(g);
    if(norm(g) < e)
        break;
    else
        d(:,k)= -g;
        a(k)=1; %backtracking(1,10^-4,0.5);
        while(1)
            cond2=sum(log(f_s) - Y.*h_S) + g' *a(k) *d(:,k); 
            auxS=S(:,k) + a(k)*d(1:end-1,k);
            auxr=r(k) + a(k)*d(end,k);
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
semilogy(1:k,grad_norm);
xlabel('k');
title('to complete')
grid on;
end