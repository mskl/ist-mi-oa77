function [result, f] = no_xinit(dataset)
    dataset = 'lmdata2.mat';    
    load(dataset, 'A');
    
    % number of xinits to be generated
    n = 1000;

    results = [];
    f_list = [];

    for ii = 1:n
        l = min(A(:))+min(A(:))/2;
        u = max(A(:))+max(A(:))/2;
        xinit = (l-u).*rand(16,1) + u;

        [result, f] = lm(dataset, xinit);
        
        results = [results; result];
        f_list = [f_list f];
    end
    
    [f, idx] = min(f_list(:));
    result = results([2*idx-1 2*idx],:);
end
