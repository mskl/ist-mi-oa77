% Waypoint positions
waypoints = [[10 10]; [20 10]; [30 10]; [30 0]; [20 0]; [10 -10]];

% Initial and target location of the robot
pinitial = [0 5];
pfinal = [15 -15];

hold on

% Plot the graph
scatter(pinitial(1), pinitial(2), "filled", 'd')
scatter(pfinal(1), pfinal(2), "filled", 'd')
scatter(waypoints(:, 1), waypoints(:, 2))
legend("waypoint position")

all_points = [pinitial; waypoints; pfinal]
plot(all_points(:, 1), all_points(:, 2))

hold off