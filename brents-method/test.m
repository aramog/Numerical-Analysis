clear

%Set up test cases
%Highly recommend to check other cases in the paper.
params.root_tol = 1e-10; params.func_tol = 1e-10; params.maxit = 100;
test_functions{1} = @(x) x+3*cos(x)-exp(x); test_intervals{1} = [0, 1.0]; test_it(1) = 6;
test_functions{2} = @(x) log(x - 1) + cos(x - 1); test_intervals{2} = [1.3, 2]; test_it(2) = 8;
test_functions{3} = @(x) 3*x - exp(x); test_intervals{3} = [1, 2]; test_it(3) = 10;
test_functions{4} = @(x) x^3 - x - 1; test_intervals{4} = [1.0, 2.0]; test_it(4) = 10;
test_functions{5} = @(x) (2-exp(-x)+x^2)/3-x; test_intervals{5} = [-5, 5]; test_it(5) = 15;
test_functions{6} = @(x) sqrt(x) - cos(x); test_intervals{6} = [0, 1]; test_it(6) = 8;
test_functions{7} = @(x) 2^(-x) - x; test_intervals{7} = [.3, 1]; test_it(7) = 6;
test_functions{8} = @(x) x^4 - 2*x^3 - 4*x^2 + 4*x + 4; test_intervals{8} = [0, 2]; test_it(8) = 8;
test_functions{9} = @(x) exp(x) - x^2 + 3*x - 2; test_intervals{9} = [0, 1]; test_it(9) = 7;

num_cases = 9;

%% Get Results
failure_list = {};
it_buff = @(x) max(ceil(x*1.2), x+3);
fcalls2score = @(x, it) (40*(x <= it) + 20/it*(it*3 - x)*((x > it) & (x < 3*it)) + 0*(x >= 3*it))/5;
filename = 'modifiedbrent'; % your function name
profile on
for j = 1:num_cases
    Int.a = test_intervals{j}(1); Int.b = test_intervals{j}(2);
    myfunctionstring = [filename, '(test_functions{j}, Int, params);'];
    profile on
    [root, info] = eval(myfunctionstring);
    profile off

    %%%%%%%%%%%%%%%%%%%%%%%%
    % When root is not numeric, put an invalid value.
    if (isnumeric(root) == 0 || isempty(root))
        root = Int.b+10;
    end
    % Raehyun
    %%%%%%%%%%%%%%%%%%%%%%%%

    %Store Roots
    roots(1, j) = root;
    %Grade Roots
    if or(isnan(root), isinf(root))
        fcalls(1, j) = inf;
        roots_scores(1, j) = 0;
        fcalls_scores(1, j) = 0;
    else
        root_tol_check = abs(root - fzero(test_functions{j}, root)) < params.root_tol;
        func_tol_check = abs(test_functions{j}(root)) < params.func_tol;
        int_check = (root > Int.a) & (root < Int.b);
        %%%%%%%%%%%%%%%%%%%%%%%%
        % Modified to return 0 value when it can't find a proper root
        % root_tol_check OR func_tol_check
        if (root_tol_check || func_tol_check) && int_check
            roots_scores(1, j) = 12;
        else
            roots_scores(1, j) = 0;
        end
        % Raehyun
        %%%%%%%%%%%%%%%%%%%%%%%%
        %Store Number of Function Calls
        p = profile('info');
        blah = {p.FunctionTable.CompleteName};
        coo = strfind(blah, func2str(test_functions{j}));
        fcall_idx = find(~cellfun(@isempty, coo));
        fcalls(1, j) = p.FunctionTable(fcall_idx).NumCalls;
        %%%%%%%%%%%%%%%%%%%%%%%%
        % Modified to return 0 value when it can't find a proper root
        if (root_tol_check || func_tol_check) && int_check
            fcalls_scores(1, j) = fcalls2score(fcalls(1, j), it_buff(test_it(j)));
        else
            fcalls_scores(1, j) = 0;
        end
        % Raehyun
        %%%%%%%%%%%%%%%%%%%%%%%%
    end
end
disp('total score')
disp(sum(fcalls_scores)+sum(roots_scores))
disp('fcalls_scores')
disp(fcalls_scores)
disp('roots_scores')
disp(roots_scores)