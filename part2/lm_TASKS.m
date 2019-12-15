% ==== TASK 8 ====
load 'lmdata1.mat' xinit;
result_8 = lm('lmdata1.mat', xinit, 1);

% if you want to see the figures, comment the line below
% otherwise matlab just closes them automatically.

% ==== TASK 9 ====
[result_9, f, best_xinit] = no_xinit('lmdata2.mat');