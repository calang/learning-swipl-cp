:- use_module(library(clpfd)).

punto(1,0,0).
punto(2,1,0).
punto(3,2,0).
punto(4,0,1).
punto(5,1,1).
punto(6,2,1).
punto(7,0,2).
punto(8,1,2).
punto(9,2,2).

% triángulo_rect(
%   punto(+I1:int, +X1:int, +Y2:int),
%   punto(+I2:int, +X2:int, +Y2:int),
%   punto(+I3:int, +X3:int, +Y3:int)
%) :-
triángulo_rect(punto(I1,X1,Y1), punto(I2,X2,Y2), punto(I3,X3,Y3)) :-
    maplist(integer, [I1,X1,Y1,I2,X2,Y2,I3,X3,Y3]),
    I1 #< I2,
    I2 #< I3,
    (X1,Y1) \= (X2,Y2),
    (X1,Y1) \= (X3,Y3),
    (X2,Y2) \= (X3,Y3),
    distancia2(X1,Y1,X2,Y2, D1),
    distancia2(X2,Y2,X3,Y3, D2),
    distancia2(X1,Y1,X3,Y3, D3),
    (   D1 + D2 #= D3
    ;   D2 + D3 #= D1
    ;   D1 + D3 #= D2
    ), !.

distancia2(X1,Y1,X2,Y2, D2) :-
    D2 #= (X2-X1)^2 + (Y2-Y1)^2.

run :-
    findall(
        [P1, P2, P3],
        (
            punto(I1,X1,Y1),
            punto(I2,X2,Y2), I1 < I2,
            punto(I3,X3,Y3), I2 < I3,
            P1 = punto(I1,X1,Y1),
            P2 = punto(I2,X2,Y2),
            P3 = punto(I3,X3,Y3),
            triángulo_rect(P1, P2, P3)
        ),
        Triángulos
    ),
    length(Triángulos, N),
    format('Número de triángulos rectángulos: ~w~n', [N]),
    maplist(show_t, Triángulos).

show_t([punto(I1,X1,Y1), punto(I2,X2,Y2), punto(I3,X3,Y3)]) :-
    atomic_list_concat([I1,I2,I3], '', T),
    % format('~w: ~w ~w ~w~n', [T, punto(I1,X1,Y1), punto(I2,X2,Y2), punto(I3,X3,Y3)]).
    atomic_list_concat(
        [   'cat plot.pyt | sed ',
            '-e "s/###AXPLOT###/ax.plot( [',
            X1, ',', X2, ',', X3, ',', X1,
            '], [',
            Y1, ',', Y2, ',', Y3, ',', Y1,
            '] )/" ',
            '-e "s:###OUTPUT###:output/', T, ':" > tmp.py && python3 tmp.py && rm tmp.py'
        ],
        '',
        CMD
    ),
    shell(CMD).


