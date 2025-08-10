% validación de condiciones iniciales en la instancia a resolver

:- module(validation, [
    restos_negativos/1,
    ningun_resto_es_negativo/0,
    suma_lecciones_por_nivel/2,
    suma_lecciones/0,
    req_sin_profesor/2,
    todo_req_con_profesor/0,
    prof_cubriendo_lecciones/2,
    prof_disponible/2,
    ningun_profesor_sin_poder_cubrir/0
]).

:- use_module([
    module(timetable_base),
    module(table_reqs)
    ]).


% restos_negativos(-[(Nivel, Resto), ... ]).
% Nivel tiene un Resto negativo.
restos_negativos(Restos) :-
    findall(
        (Nivel, Resto),
        (   req(Nivel, resto, Resto),
            Resto < 0
        ),
        Restos
    ).


% ningún nivel debe tener un resto negativo
ningun_resto_es_negativo :-
    restos_negativos(Restos),
    ( Restos = [] ->
        true
    ;   format('Error: nivel(es) con resto negativo: ~w~n', [Restos]),
        fail
    ).


% suma_lecciones_por_nivel(+Nivel, ?SumaLecc)
% SumaLecc es la suma de lecciones requeridas por nivel Nivel.
%
suma_lecciones_por_nivel(Nivel, SumaLecc) :-
    findall(
        Cantidad,
        req(Nivel, _Materia, Cantidad),
        Lecciones
    ),
    sum_list(Lecciones, SumaLecc).


% ninguna suma de lecciones por nivel debe ser distinta de lecc_por_sem
suma_lecciones :-
    lecc_por_sem(LeccPorSem),
    findall(
        (Nivel, SumaLecc),
        (   suma_lecciones_por_nivel(Nivel, SumaLecc),
            SumaLecc #\= LeccPorSem
        ),
        Sumas
    ),
    ( Sumas = [] ->
        true
    ;   format('Error: suma de lecciones por nivel distinta de lecc_por_sem: ~w~n', [Sumas]),
        fail
    ).


% req_sin_profesor(?Nivel, ?Materia)
% Nivel tiene un requisito de Materia sin profesor asignado.
req_sin_profesor(Nivel, Materia) :-
    req(Nivel, Materia, _),
    \+ prof(_, Nivel, Materia).


% a ningún requisito debe faltarle un profesor que lo pueda cubrir
todo_req_con_profesor :-
    findall(
        (Nivel, Materia),
        req_sin_profesor(Nivel, Materia),
        Reqs
    ),
    Reqs \= [], !,
    format('Error: requisitos sin profesor asignado: ~w~n', [Reqs]),
    fail.
todo_req_con_profesor.


% prof_cubriendo_lecciones(+Profesor, ?Cantidad)
% Cantidad es la cantidad de lecciones que el Profesor debe cubrir.
prof_cubriendo_lecciones(Profesor, Cantidad) :-
    findall(
        Cant,
        (   prof(Profesor, Nivel, Materia),
            req(Nivel, Materia, Cant)
        ),
        ListCant
    ),
    sum_list(ListCant, Cantidad).


% prof_disponible(+Profesor, ?Cantidad)
% Cantidad es la cantidad de lecciones en las que el Profesor está disponible.
prof_disponible(Profesor, Cantidad) :-
    findall(
        Lecc,
        disp(Profesor, _Dia, _Bloque, Lecc),
        ListLecc
    ),
    length(ListLecc, Cantidad).


% ningún profesor debe estar asignado a una cantidad de materias mayor a la que puede cubrir
ningun_profesor_sin_poder_cubrir :-
    findall(
        (Profesor, CantReq, CantidadDispo),
        (   prof(Profesor, _Nivel, _Materia),
            prof_cubriendo_lecciones(Profesor, CantReq),
            prof_disponible(Profesor, CantidadDispo),
            CantReq > CantidadDispo
        ),
        ProfCant
    ),
    ProfCant \= [], !,
    format('Error: profesor(es) con cantidad de materias mayor a lo que puede cubrir: ~w~n', [ProfCant]),
    fail.
ningun_profesor_sin_poder_cubrir.

% ningun profesor puede estar disponble para dar más lecciones que el total de lecciones por semana.
ningun_profesor_sobredisponible :-
    lecc_por_sem(LeccPorSem),
    findall(
        (Profesor, CantidadDispo),
        (   prof_disponible(Profesor, CantidadDispo),
            CantidadDispo > LeccPorSem
        ),
        ProfCant
    ),
    ProfCant \= [], !,
    format('Error: profesor(es) con disponibilidad mayor a lecciones por semana: ~w~n', [ProfCant]),
    fail.
ningun_profesor_sobredisponible.

