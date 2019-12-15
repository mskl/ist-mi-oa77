function [S] = grad_descent_2(X,Y,s0,r0,e)
%grad_descent_2 applies the gradient method
%   Inputs : X,Y,e= dataset,labels,error tolerance
%            s0,r0= initial s, initial r
%   Outputs: S = [X_features+1]*[k] matrix, where S(:,end) is the final
%            value; [S(1:end-1,:); S(end,:)]= [values of s ; values of r] 
%            troughout the method
k=1;
%Compactly defines an affine mapping, so that matricial notation can be
%employed . [s r]*[x;-1] = s'*x - r 
S(:,1)=[s0;r0];
X(end+1,:)=-1;
%define functions f, and its first derivative in order of s'*x
d_f=@(x,s,y)(exp(s'*x)./(1+exp(s'*x))) - y ;
f=@(x,s,y) sum(log(1+ exp(s'*x)) - y.*(s'*x))/length(x);
while(1)
    %calculate gradient
    g=(X*(d_f(X,S(:,k),Y)'))/length(X);
    grad_norm(k)=norm(g);
    if(norm(g) < e)
        break;
    else
        d=-g;
        %backtracking routine
        a(k)=1;
        while(1)
            cond2= f(X,S(:,k),Y)+(10^-4)*g'*(a(k)*d);
            cond1= f(X,S(:,k)+a(k)*d,Y);
            if(cond1<cond2)
                break;
            end
            %step size recalculation
            a(k)=a(k)*0.5;
        end
        % calculation of k(th) iteration of the values of s and r 
        S(:,k+1)=S(:,k)+a(k)*d;
        k=k+1;
    end
end
%Norm graph
figure
semilogy(1:k,grad_norm);
xlabel('$k$','interpreter','latex')
title('$||\nabla{f(s_k,r_k)}||$ (Gradient Method)','interpreter','latex')
grid on;
end