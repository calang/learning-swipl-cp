% validación de condiciones iniciales de la instancia a resolver


% --- restricciones sobre datos iniciales ---

ningun_resto_es_negativo :-
    findall(
        (Nivel, Resto),
        (   req(Nivel, resto, Resto),
            Resto #< 0
        ),
        Niveles
    ),
    Niveles \= [], !,
    format('Error: nivel(es) con resto negativo: ~w~n', [Niveles]),
    fail.

ningun_resto_es_negativo.


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

