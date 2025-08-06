/** Sample Prolog unit test module

This is an example module of how unit tests can be written in Prolog.

Invoked with a command like this:

~~~{.sh}
# -f uses the file in replacement of the users initialization file
# -s uses the file as a script, without preventing the loading of the initialization file
# -g runs the goal after loading the file

swipl -g run_tests,halt 'tests/validation.plt'
~~~

@author Carlos Lang
@license MIT
*/

:- use_module(library(clpfd)).

:- asserta(user:file_search_path(module, 'tests/data/validation')).



:- begin_tests(process).

:- use_module([
    '../src/module/validation.pl',
    module(timetable_base),
    module(table_reqs)
    ]).


test(restos_negativos) :-
    restos_negativos(R),
    (   R = [ (6,-1) ]
    ->  true
    ;   format('~nError: se esperaban restos negativos = [(6,-1)], pero se encontró~n~w~n', [R]),
        fail
    ).


% esta prueba no es efectiva por la posible existencia de un resto negativo
% se mantiene, aunque sea redundante, para verificar que la condición se cumple
test(suma_lecciones_por_nivel) :-
    lecc_por_sem(Lecc_por_sem),
    forall(
        nivel(Nivel),
        (   suma_lecciones_por_nivel(Nivel, Suma),
            (
                Suma = Lecc_por_sem
            ->  true
            ;   format('~nError: suma de lecciones por nivel ~w distinta de ~w: ~w~n', [Nivel, Lecc_por_sem, Suma]),
                fail
            )
        )
    ).


% test(solve_all_iqr_base, [setup(load_graph('../data/graph.pl'))]) :-
%     solve_all_iqr_base.


% test(sources, [setup(load_graph('../data/graph.pl'))]) :-
%     sources.


:- end_tests(process).
