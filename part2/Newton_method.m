function [ S ] = Newton_method( X,Y,s0,r0,e )
%Newton_method applies the newton method
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
%define functions f, and its first and second derivatives in order of s'*x
f=@(x,s,y) (1/length(x))*sum(log(1+ exp(s'*x)) - y.*(s'*x));
d_f=@(x,s,y)(exp(s'*x)./(1+exp(s'*x))) - y ;
h=@(x,s) exp(s'*x)./((1+exp(s'*x)).^2) ;

while(1)
    %calculate gradient
    g= X*(d_f(X,S(:,k),Y))'/length(X);
    grad_norm(k)=norm(g);
    if(norm(g) < e) 
        break;
    else
        %calculate hessian
        hess= X*diag(h(X,S(:,k)))*X'/length(X);
        d= -(hess)^-1*g;
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
xlim([1 k]);
title('$||\nabla{f(s_k,r_k)}||$ (Newton method)','interpreter','latex')
grid on;
%stepsize graph
figure
stem(a,'filled');
xlabel('$k$','interpreter','latex')
title('$ \alpha_k$ (Newton method)','interpreter','latex')
xlim([1 k-1]);
ylim([0 max(a)]);
end

