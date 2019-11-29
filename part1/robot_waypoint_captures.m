function [captures] = robot_waypoint_captures(x, w, tau)
    deltas = x(1:2, tau+1) - w;
    captures = sum(norms(deltas, 2) <= 10^-6);
end