% En este archivo se define la instancia del problema a resolverse.

:- module(table_reqs, [
    req/3,
    prof/3,
    disp/4
]).

:- use_module(module(timetable_base)).




% disponibilidad de profesores
% disp(?Prof, ?Dia, ?Bloque, ?Leccion).
%
% Prof es un profesor, disponible en el día Dia, bloque Bloque y lección Leccion.

disp(angie, mie, B, L) :-
    member(B, [1,2,3,4]),
    member(L, [a,b]).
disp(mpaula, D, B, L) :-
    member(D, [lun,mar,jue]),
    bloque(B),
    leccion(L).
disp(alonso, mie, B, L) :-
    bloque(B),
    leccion(L).
disp(P, D, B, L) :-
    member(P, [melissa, jonathan, gina, audry, daleana, mayela, mjose, sol, alisson]),
    dia(D),
    bloque(B),
    leccion(L).
