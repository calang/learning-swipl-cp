% Hint: https://github.com/triska/clpz/blob/master/sudoku.pl

:- use_module(library(clpfd)).

% problem definition

restriccion(Rows) :-
    % instantiate 6 rows
    length(Rows, 6),
    % each row in Rows must have the same length
    % as the list Rows itself = 6
    maplist(same_length(Rows), Rows),
    % each cell in Rows must be an integer in 1..6
    append(Rows, Cells), Cells ins 1..6,
    % each row must have distinct values
    maplist(all_distinct, Rows),
    % each column must have distinct values
    transpose(Rows, Columns),
    maplist(all_distinct, Columns),
    % each 2x3 block must have distinct values
    Rows = [R1, R2, R3, R4, R5, R6],
    block(R1, R2), block(R3, R4), block(R5, R6).

block([], []).
block([A, B, C | Rest1], [D, E, F | Rest2]) :-
    % A, B, C, D, E, F must be distinct
    all_distinct([A, B, C, D, E, F]),
    block(Rest1, Rest2).

% problem instance

problem(Rows) :-
    Rows = [
        [2, _, _, _, _, _],
        [_, 6, _, _, _, _],
        [1, 3, 5, _, _, _],
        [6, 4, 2, 1, _, _],
        [3, 5, 1, 6, 4, _],
        [4, 2, 6, 5, 1, 3]
    ].

% solve the problem
solve :-
    problem(Rows),          % instantiate problem
    restriccion(Rows),      % apply constraints
    maplist(labeling([ff]), Rows), % search for a solution
    maplist(portray_clause, Rows). % print the solution
