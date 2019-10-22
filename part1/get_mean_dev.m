function [mean_dev] = get_mean_dev(tau, x, w)
    mean_dev = sum(vecnorm(x(1:2, tau) - w, 2, 1)) / length(tau);
end