:- use_module([
    library(clpfd),
    library(clpr)
]).

% finds a single solution
checkr :-
    {Y = 2 * X},
    {1 =< X, X =< 3},
    bb_inf([X], -Y, Opt, Vals, 0.1),
    format('Opt: ~w, Vals: ~w~n', [Opt, Vals]).

% finds solutions from best to worst
checkfd :-
    X in 1..3,
    Y #= 2 * X,
    labeling([max(Y)], [X,Y]),
    format('Opt: Y=~w, for X=~w~n', [Y, X]).


% example of optimization,
% were the problem instance is separated from the solution
problem(Cost, X, Y) :-
    X in 1..3,
    Y in 4..6,
    Cost #= Y - X.

solve_problem :-
    problem(Cost, X, Y),
    labeling([min(Cost)], [X,Y]),
    format('Opt: Cost=~w, Y=~w, for X=~w~n', [Cost, Y, X]).

