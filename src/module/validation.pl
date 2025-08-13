% validación de condiciones iniciales en la instancia a resolver

:- module(validation, [
    req_nivel_valido/0,
    prof3_valido/0,
    disp_prof_valido/0,
    restos_negativos/1,
    ningun_resto_es_negativo/0,
    suma_lecciones_por_nivel/2,
    suma_lecciones/0,
    req_sin_profesor/2,
    todo_req_con_profesor/0,
    prof_cubriendo_lecciones/2,
    prof_disponible/2,
    ningun_profesor_sin_poder_cubrir/0,
    validation/0,
    prof_no_disponible/1
]).

:- use_module([
    module(timetable_base),
    module(table_reqs)
    ]).

% req_nivel_valido
% Verifica que todos los niveles requeridos existan en la base de datos.
req_nivel_valido :-
    findall(
        Nivel,
        (   req(Nivel, _, _),
            \+ nivel(Nivel)
        ),
        NivelesMalos
    ),
    sort(NivelesMalos, SetNivelesMalos),
    ( SetNivelesMalos = [] ->
        true
    ;   format('Error: niveles no válidos, usados en req/3: ~w~n', [SetNivelesMalos]),
        fail
    ).


% prof3_valido
% Verifica que todos los profesores requeridos existan en la base de datos.
prof3_valido :-
    findall(
        Profesor,
        (   prof(Profesor, _, _),
            \+ prof(Profesor)
        ),
        ProfesoresMalos
    ),
    sort(ProfesoresMalos, SetProfesoresMalos),
    ( SetProfesoresMalos = [] ->
        true
    ;   format('Error: profesores no válidos, usados en prof/3: ~w~n', [SetProfesoresMalos]),
        fail
    ).


% disp_prof_valido
% Verifica que todos los profesores disponibles existan en la base de datos.
disp_prof_valido :-
    findall(
        Profesor,
        (   disp(Profesor, _, _, _),
            \+ prof(Profesor)
        ),
        ProfesoresMalos
    ),
    sort(ProfesoresMalos, SetProfesoresMalos),
    ( SetProfesoresMalos = [] ->
        true
    ;   format('Error: profesores no válidos, usados en disp/4: ~w~n', [SetProfesoresMalos]),
        fail
    ).


% restos_negativos(-[(Nivel, Resto), ... ]).
% Nivel tiene un Resto negativo.
restos_negativos(Restos) :-
    findall(
        (Nivel, Resto),
        (   nivel(Nivel),
            req(Nivel, resto, Resto),
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
        (   nivel(Nivel),
            suma_lecciones_por_nivel(Nivel, SumaLecc),
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
        [Profesor, CantReq, CantidadDispo],
        (   prof(Profesor, _Nivel, _Materia),
            prof_cubriendo_lecciones(Profesor, CantReq),
            prof_disponible(Profesor, CantidadDispo),
            CantReq > CantidadDispo
        ),
        ProfCant
    ),
    sort(ProfCant, SetProfCant),
    SetProfCant \= [], !,
    format('Error: [profesor, lecc_req, lecc_disp] con cantidad de materias requeridas mayor a lo que puede cubrir:~n~w~n', [SetProfCant]),
    forall(
        member([Profesor, _CantReq, _CantidadDispo], SetProfCant),
        prof_no_disponible(Profesor)
    ),
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
    sort(ProfCant, SetProfCant),
    SetProfCant \= [], !,
    format('Error: (profesor, lecc_disp) con disponibilidad mayor a lecciones por semana (~w): ~w~n', [LeccPorSem, SetProfCant]),
    fail.
ningun_profesor_sobredisponible.


% validation
% Se realizan todas las validaciones sobre los datos
validation :-
    req_nivel_valido,
    prof3_valido,
    disp_prof_valido,
    ningun_resto_es_negativo,
    suma_lecciones,
    todo_req_con_profesor,
    ningun_profesor_sin_poder_cubrir,
    ningun_profesor_sobredisponible.


% --- diagnóstico detallado ---

prof_no_disponible(Prof) :-
    prof(Prof),
    findall([Nivel, Materia, Cant], (prof(Prof, Nivel, Materia), req(Nivel, Materia, Cant)), ListCant),
    maplist(nth0(2), ListCant, ListCantNums),
    sum_list(ListCantNums, TotReq),
    format('Profesor ~w no disponible para cubrir estas lecciones (~w):~n~w~n', [Prof, TotReq, ListCant]),
    findall((Prof,Dia,Bloq,Lecc), disp(Prof,Dia, Bloq, Lecc), Lecc_Disp),
    length(Lecc_Disp, TotDisp),
    format('con esta disponibilidad (~w):~n~w~n', [TotDisp, Lecc_Disp]).

