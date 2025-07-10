puzzle([F,O,U,R,T,Y] + [T,E,N] + [T,E,N] = [S,I,X,T,Y]) :-
        Vars = [F,O,U,R,T,Y,E,N,S,I,X],
        Vars ins 0..9,
        % all_different(Vars),
        F*100000 +  O*10000 +   U*1000 +    R*100 + T*10 + Y +
                                            T*100 + E*10 + N +
                                            T*100 + E*10 + N #=
                    S*10000 +   I*1000 +    X*100 + T*10 + Y,
        % F #\= 0, T #\= 0, S \= 0,
		label(Vars).

main :-
    puzzle([F,O,U,R,T,Y] + [T,E,N] + [T,E,N] = [S,I,X,T,Y]),
    writeln([F,O,U,R,T,Y] + [T,E,N] + [T,E,N] = [S,I,X,T,Y]),
    !.

main :-
    writeln('No solution found.').

:- main.

