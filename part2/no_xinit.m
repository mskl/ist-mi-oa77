function [result, f, best_xinit] = no_xinit(dataset)
    load(dataset, 'A');
    
    % number of xinits to be generated
    n = 10000;

    results = [];
    f_list = [];
    xinits = [];
    
    for ii = 1:n
        l = min(A(:))+min(A(:))/2;
        u = max(A(:))+max(A(:))/2;
        xinit = (l-u).*rand(16,1) + u;

        [result, f] = lm(dataset, xinit, 0);
        
        results = [results; result];
        f_list = [f_list f];
        xinits = [xinits xinit];
    end
    
    [f, idx] = min(f_list(:));
    best_xinit = xinits(:,idx);
    result = results([2*idx-1 2*idx],:);
end
