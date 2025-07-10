% Write a predicate increase/1
% that takes a list and constrains it to be strictly increasing.

increase(L) :-
    chain(L, #<).

:- increase([1, X, 3]), writeln(X).

:- increase([1, X, 4]), X in 1..4, writeln(X).

:- increase([1, X, Y, 4]), [X,Y] ins 1..4, writeln((X, Y)).

:- increase([1,2]), writeln(X).

:- increase([1,X]), X in 0..sup, writeln(X).

