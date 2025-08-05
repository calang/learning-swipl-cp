% En este archivo se define la instancia del problema a resolverse.

:- use_module(module(timetable_base)).

% total de lecciones por semana por nivel.
lecc_por_sem(40).


% requisitos por nivel
% req(+Nivel, ?Materia, ?Cant_lecciones)
%
% En el nivel Nivel, la materia Materia requiere Cant_lecciones.

req(inter, edfís, 2).
req(inter, infor, 1).
req(inter, inglés, 11).
req(inter, música, 1).

req(trans, edfís, 2).
req(trans, infor, 1).
req(trans, inglés, 1).
req(trans, música, 1).

req(1, arte, 1).
req(1, ciencias, 4).
req(1, edfís, 2).
req(1, español, 7).
req(1, estsoc, 4).
req(1, ética, 1).
req(1, infor, 2).
req(1, inglés, 10).
req(1, mate, 8).
req(1, música, 1).

req(2, arte, 1).
req(2, ciencias, 4).
req(2, edfís, 2).
req(2, español, 7).
req(2, estsoc, 4).
req(2, ética, 1).
req(2, infor, 2).
req(2, inglés, 10).
req(2, mate, 8).
req(2, música, 1).

req(3, arte, 1).
req(3, ciencias, 4).
req(3, edfís, 2).
req(3, español, 7).
req(3, estsoc, 4).
req(3, ética, 1).
req(3, infor, 2).
req(3, inglés, 10).
req(3, mate, 8).
req(3, música, 1).

req(4, ciencias, 4).
req(4, edfís, 2).
req(4, español, 6).
req(4, estsoc, 5).
req(4, ética, 1).
req(4, francés, 2).
req(4, infor, 2).
req(4, inglés, 9).
req(4, mate, 8).
req(4, música, 1).

req(5, ciencias, 4).
req(5, edfís, 2).
req(5, español, 5).
req(5, estsoc, 6).
req(5, ética, 1).
req(5, francés, 2).
req(5, infor, 2).
req(5, inglés, 9).
req(5, mate, 8).
req(5, música, 1).

req(6, ciencias, 6).
req(6, edfís, 2).
req(6, español, 5).
req(6, estsoc, 4).
req(6, ética, 1).
req(6, francés, 2).
req(6, infor, 2).
req(6, inglés, 9).
req(6, mate, 8).
req(6, música, 1).

req(Nivel, resto, Resto) :-
    lecc_por_sem(Lecc_por_sem),
    findall(
        Cantidad,
        (   dif(resto, Materia),
            req(Nivel, Materia, Cantidad)
        ),
        Lecciones
    ),
    sum_list(Lecciones, Suma_Cantidad),
    Resto #= Lecc_por_sem - Suma_Cantidad.


% asignación de profesores a materias por nivel
% prof(?Profesor, ?Nivel, ?Materia)
%
% Profesor es un profesor que está asignado a la materia Materia en el nivel Nivel.

prof(mpaula, inter, edfís).  % <-- ???
prof(jonathan, inter, infor).
prof(mjose, inter, inglés).
prof(alonso, inter, música).
prof(alisson, inter, resto).

prof(mpaula, trans, edfís).
prof(jonathan, trans, infor).
prof(audry, trans, inglés).
prof(alonso, trans, música).
prof(alisson, trans, resto).
prof(audry, trans, resto).
prof(sol, trans, resto).

prof(mjose, 1, arte).
prof(sol, 1, ciencias).
prof(mpaula, 1, edfís).
prof(sol, 1, español).
prof(sol, 1, estsoc).
prof(mjose, 1, ética).
prof(jonathan, 1, infor).
prof(audry, 1, inglés).
prof(sol, 1, mate).
prof(alonso, 1, música).
prof(sol, 1, resto).

prof(alisson, 2, arte).
prof(mjose, 2, ciencias).
prof(mpaula, 2, edfís).
prof(mjose, 2, español).
prof(mjose, 2, estsoc).
prof(alisson, 2, ética).
prof(jonathan, 2, infor).
prof(gina, 2, inglés).
prof(mjose, 2, mate).
prof(alonso, 2, música).
prof(mjose, 2, resto).

prof(mjose, 3, arte).
prof(audry, 3, ciencias).
prof(mpaula, 3, edfís).
prof(audry, 3, español).
prof(audry, 3, estsoc).
prof(mjose, 3, ética).
prof(jonathan, 3, infor).
prof(gina, 3, inglés).
prof(audry, 3, mate).
prof(alonso, 3, música).
prof(audry, 3, resto).

prof(mayela, 4, ciencias).
prof(mpaula, 4, edfís).
prof(mayela, 4, español).
prof(mayela, 4, estsoc).
prof(alisson, 4, ética).
prof(angie, 4, francés).
prof(jonathan, 4, infor).
prof(gina, 4, inglés).
prof(mayela, 4, mate).
prof(alonso, 4, música).
prof(mayela, 4, resto).

prof(mayela, 5, ciencias).
prof(mpaula, 5, edfís).
prof(daleana, 5, español).
prof(daleana, 5, estsoc).
prof(alisson, 5, ética).
prof(angie, 5, francés).
prof(jonathan, 5, infor).
prof(gina, 5, inglés).
prof(mayela, 5, mate).
prof(alonso, 5, música).
prof(mayela, 5, resto).

prof(daleana, 6, ciencias).
prof(mpaula, 6, edfís).
prof(daleana, 6, español).
prof(daleana, 6, estsoc).
prof(alisson, 6, ética).
prof(angie, 6, francés).
prof(jonathan, 6, infor).
prof(melissa, 6, inglés).
prof(daleana, 6, mate).
prof(alonso, 6, música).
prof(daleana, 6, resto).


% disponibilidad de profesores
% disp(?Prof, ?Dia, ?Bloque, ?Leccion).
%
% Prof es un profesor, disponible en el día Dia, bloque Bloque y lección Leccion.

disp(angie, mie, B, L) :-
    member(B, [2,3]),
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


% --- restricciones sobre datos iniciales ---

% ningún resto debe ser negativo
:- nivel(Nivel), req(Nivel, resto, L), L < 0.

% ninguna suma de lecciones por nivel debe ser distinta de lecc_por_sem
:- nivel(Nivel), #sum { L,Materia,Nivel : req(Nivel, Materia, L) } != lecc_por_sem.

% a ningún requisito debe faltarle un profesor que lo pueda cubrir
:- req(Nivel, Materia, _), not prof(_, Nivel, Materia).


% --- objetivo, junto con requerimientos adicionales ---
%
% el principal término por derivar es
%   asignado(Nivel, Materia, Profesor, Dia, Bloque, Leccion)
%

% en cada nivel y leccion hay un profesor y materia asignados,
% entre los posibles designados como profesor y materia para ese nivel
{   asignado(Nivel, Materia, Profesor, Dia, Bloque, Leccion)
    :   prof(Profesor, Nivel, Materia)
} = 1
:- nivel(Nivel), bloque(Dia, Bloque, Leccion).


% --- proyecciones de asignado ---

% un profesor está asignado a un nivel para una materia, si lo está para alguna lección.
asignado(Nivel, Materia, Profesor) :- asignado(Nivel, Materia, Profesor, Dia, Bloque, Leccion).

% una materia está asignada a un nivel en alguna lección si lo está con algún profesor
asignado(Nivel, Materia, Dia, Bloque, Leccion)
    :- asignado(Nivel, Materia, Profesor, Dia, Bloque, Leccion).


% --- requerimientos adicionales ---

% en cada nivel y para cada materia requerida,
% la cantidad de lecciones asignada para esa materia es la requerida para ese nivel
{   asignado(Nivel, Materia, Dia, Bloque, Leccion)
    :   bloque(Dia, Bloque, Leccion)
} = Cant
    :- req(Nivel, Materia, Cant).

% para cada nivel y materia, la cantidad de lecciones asignadas en un mismo dia
% no debe ser mayor a 2
{   asignado(Nivel, Materia, Dia, Bloque, Leccion)
    :   bloque(Dia, Bloque, Leccion),
        dia(Dia)
} <= 0
    :-  dia(Dia),
        req(Nivel, Materia, _Cant).

% el profesor asignado a un nivel con una materia está designado para esa materia en ese nivel
% Nota: por construcción de asignado/6, esto parece redundante.
prof(Profesor, Nivel, Materia)
    :- asignado(Nivel, Materia, Profesor, _Dia, _Bloque, _Leccion).

% el profesor asignado en cada lección está disponible en esa lección
disp(Profesor, Dia, Bloque, Leccion)
    :- asignado(_Nivel, _Materia, Profesor, Dia, Bloque, Leccion).

% cada materia en cada nivel es dada por un solo profesor
{   asignado(Nivel, Materia, Profesor)
    :   prof(Profesor, Nivel, Materia)
} = 1
    :- req(Nivel, Materia, _Cant).

% cada materia asignada cada dia a cada nivel ocurre en lecciones consecutivas del mismo bloque
% TODO: check what happens with Materia whose requirement is only one lesson: ética, arte
% :- asignado(Nivel, Materia, Profesor, Dia, Bloque, b),
%    not asignado(Nivel, Materia, Profesor, Dia, Bloque, a).


% Si agregamos lo siguiente el problema ya no es satisfacible,
% por la restricción anterior,
% pero no es sencillo obtener un reporte de cual restricción no
% se está cumpliendo.
% Más bien ha de realizarse una depuración del programa.

% req(6, arte, 1).


% Notas:
% - edfís en común:  1,2  3,4  trans,inter
% - infor en común:  trans,inter
% - música en común:  3,4
% - hay una materia "banda" para alonso
% - mjose da ética y artes para III, ¿es esto correcto?
% - el horario de mjose para vie,3 dice inter, pero vie,3 para inter dice alisson
%       probablemente se deben intercambiar 2 y 3 para inter,vie
% - alisson está asignada a inter en vie,2, pero inter a esa hora tiene inglés
%       inter tiene a alisson en vie,3, pero a esa hora ella está asignada a II ética y arte

%#show nivel/1.
%#show bloque/3.
#show asignado/6.
