function [mean_dev] = get_mean_dev(E, tau, x, w)
    selected = E*x;
    mean_dev = sum(vecnorm(selected(:, tau) - w, 2, 1)) / length(tau);
end