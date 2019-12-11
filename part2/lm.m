function [result, f_est] = lm(dataset, xinit)
    load(dataset, 'A', 'iA', 'y', 'z', 'iS', 'S');
    
    print = 1;
    clc; 
    close all
    xk = xinit;

    % because vecnorm(x, dim) isn't available before R2017a
    vnorm = @(mat, dim) sqrt(sum(mat.^2, dim));

    % represents sp - sq
    sel = [1 0 -1 0; 0 1 0 -1];

    norms_f = [];
    lambda = 1;
    epsilon = 10^(-6);
    while 1
        [am, sp1, sp2, sq] = variables(xk, iA, A, iS);

        [f, fa, fs] = fx(am, sp1, sp2, sq, y, z);

        grad_fa = zeros(size(am, 1), length(xk));
        for ii = 1:length(iA)
            grad_fa(ii, [2*iA(ii,2)-1 2*iA(ii,2)]) = (sp1(ii,:) - am(ii,:)) ./ vnorm(am(ii,:) - sp1(ii,:), 2);
        end

        grad_fs = zeros(size(sq, 1), length(xk));
        for ii = 1:length(iS)
            grad_fs(ii, [2*iS(ii,1)-1 2*iS(ii,1) 2*iS(ii,2)-1 2*iS(ii,2)]) = ((sel'*sel*[sp2(ii,:) sq(ii,:)]') ./ vnorm(sp2(ii,:) - sq(ii,:), 2))';
        end

        g_k = [2.*grad_fa.*fa; 2.*grad_fs.*fs];
        norm_gk = norm(sum(g_k, 1));

        norms_f = [norms_f norm_gk];
        if norm_gk < epsilon
           break; 
        end 

        x_est = [grad_fa; grad_fs; sqrt(lambda).*eye(size(g_k,2))] \ [grad_fa*xk - fa; grad_fs*xk - fs; sqrt(lambda) * xk];

        [am, sp1, sp2, sq] = variables(x_est, iA, A, iS);
        [f_est, ~, ~] = fx(am, sp1, sp2, sq, y, z);
        
        f_sum = sum(f);
        f_est = sum(f_est);
        
        if f_est < f_sum
            xk = x_est;
            lambda = 0.7 * lambda;
        else
            lambda = 2 * lambda;
        end
    end

    result = reshape(xk, [2, length(xk)/2]);

    % === plot results ===
    % -- 1) network localization setup
    if print
        figure(1)
        scatter(A(1,:), A(2,:), 80, 'r', 's', 'LineWidth', 2)
        grid on;
        hold on;
        % real locations of sensors (.)
        if exist('S', 'var')
            scatter(S(1,:), S(2,:), 50, 'b', 'o', 'filled');

            % pink lines
            for ii = 1:length(iA)
                plot([A(1,iA(ii,1)) S(1,iA(ii,2))], [A(2,iA(ii,1)) S(2,iA(ii,2))], '--m');
            end
            for ii = 1:length(iS)
                plot(S(1,iS(ii,:)), S(2,iS(ii,:)), '--m');
            end
        end
        % xinit (*)
        scatter(xinit(1:2:length(xinit)-1), xinit(2:2:length(xinit)), 50, 'b', '*', 'LineWidth', 1.5);

        % solution obtained (o)
        scatter(result(1,:), result(2,:), 80, 'b', 'o', 'LineWidth', 2);
        xlim([min(A(1,:), [], 2)-3 max(A(1,:), [], 2)+3])
        title(['Network localization']);

        % -- 2) norm of the gradient of the cost function
        figure(2);
        semilogy(1:length(norms_f), norms_f, 'LineWidth', 2);
        xlim([0 length(norms_f)+2])

        grid on;
        grid minor;

        title('$||\nabla f(x_k)||$ (LM Method)','Interpreter','latex')
        xlabel('$k$', 'Interpreter', 'latex');
    end
end

function [am, sp1, sp2, sq] = variables(xk, iA, A, iS)
    am = A(:,iA(:,1))';    
    sp1 = [xk(iA(:,2)*2 - 1,:) xk(iA(:,2)*2,:)];

    sp2 = [xk(iS(:,1)*2 - 1,:) xk(iS(:,1)*2,:)];    
    sq = [xk(iS(:,2)*2 - 1,:) xk(iS(:,2)*2,:)];
end

function [f, fa, fs] = fx(am, sp1, sp2, sq, y, z)
    vnorm = @(mat, dim) sqrt(sum(mat.^2, dim));

    fa = vnorm(am - sp1,2) - y;
    fs = vnorm(sp2 - sq,2) - z;

    f = [fa.^2;fs.^2];
end

