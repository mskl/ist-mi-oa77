function [mean_dev] = get_mean_dev_circle(E, tau, x, c, r)
    mean_dev = sum(max(0, vecnorm(c-E*x(:, tau)) - r)) / length(tau);
end