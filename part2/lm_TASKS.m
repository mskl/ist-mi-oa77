% ==== TASK 8 ====
load 'lmdata1.mat' xinit;
result_8 = lm('lmdata1.mat', xinit);
fprintf('')

% ==== TASK 9 ====
[result_9, f] = no_xinit('lmdata2.mat');