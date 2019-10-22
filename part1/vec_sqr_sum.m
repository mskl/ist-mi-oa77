function [norm_col] = vec_sqr_sum(A)
% vec_sqr_sum squares elementwise and sums all the columns for a matrix 
    A = A.^2;
    for i = 1:length(A(1,:))
        aux = sum(A(:,i));
        norm_col(i) = aux;
    end
end