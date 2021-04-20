% @param func: function handle.
% @param Int = {a, b}: interval containing root of the function
% @param params = {root_tol, func_tol, maxit}.
% @return root: computed root of the function.
% @return info.flag = 0 on success, 1 otherwise.
function [root,info] = modifiedbrent(func,Int,params)
% NOTE: x, f(x) assignment must happen "atomically" (i.e. in same place).
% This garantees invariant consistency + minimal function calls

% Check that the root is bracketed
a = Int.a;
fa = func(a);
b = Int.b;
fb = func(b);
if (fa*fb >= 0)
    % f(a) & f(b) have same sign, so return with error
    info.flag = 1;
    root = 0;
    return;
end

% WLOG ensure abs(f(a)) >= abs(f(b))
% i.e. b is always best root approximation
if (abs(fa) < abs(fb))
    tb = b;
    tfb = fb;
    b = a;
    fb = fa;
    a = tb;
    fa = tfb;
end

% Interval variables (c, s)
c = a;
fc = fa;
s = a;
fs = fa;
% Iteration variables
halving_fails_cnt = 0; % # consecutive iterations interpolation doesn't halve the interval size
int_size = abs(b-a); % size of last interval generated by a bisection step
bisect_step = false;
info.it = 0; % # of iterations so far

% Main loop
while (true)
    % RETURN CONDITIONS
    % 1. Interval convergence
    if (abs(b - a) <= params.root_tol)
        info.flag = 0;
        root = b;
        return;
    end
    % 2. Function convergence
    if (abs(fb) <= params.func_tol)
        info.flag = 0;
        root = b;
        return;
    end
    if (abs(fs) <= params.func_tol)
        info.flag = 0;
        root = s;
        return;
    end    
    % 3. Max iterations
    if (info.it >= params.maxit)
        info.flag = 1;
        root = b;
        return;
    end
    
    % COMPUTE NEW BEST POINT
    % Compute inverse interpolated root
    if (fa ~= fc && fb ~= fc)
        % Quadratic (IQI) if 3 distinct points available
        s = a*((fb*fc)/((fa - fb)*(fa - fc))) + ...
            b*((fa*fc)/((fb - fa)*(fb - fc))) + ...
            c*((fa*fb)/((fc - fa)*(fc - fb)));
    else
        % Linear if only 2 points (should only run on first iteration)
        s = b - fb*(b-a)/(fb - fa);
    end
    fs = func(s);
    % Run bisection step if either of 2 conditions met
    % This will steer us in the right direction if we've gone awry
    if (halving_fails_cnt >= 5 || 2*abs(fs) > abs(fb))
        s = .5*(a+b);
        fs = func(s);
    end

    % Step iteration maintaining following invariants:
    % 1. Root bracketing holds
    % 2. b is best approximation
    d = c;
    c = b;
    fc = fb;
    % Root bracketing
    if (fa*fs < 0)
        b = s;
        fb = fs;
    else
        a = s;
        fa = fs;
    end
    % b is best approximation so far
    if (abs(fa) < abs(fb))
        tb = b;
        tfb = fb;
        b = a;
        fb = fa;
        a = tb;
        fa = tfb;
    end
    % Update interval halving count for bisect check
    if (bisect_step)
        int_size = abs(b-a);
    else
        % Interval halving check
        if (abs(b-a) > .5*int_size)
            halving_fails_cnt = halving_fails_cnt + 1;
        else
            halving_fails_cnt = 0;
        end
    
    info.it = info.it + 1;
end

info.flag = 0;
end