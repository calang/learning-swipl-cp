use_module(library(clpfd)).


% F(X_i, W_i, Y_i, H_i),
% where (X_i, Y_i) is the bottom-left corner of rectangle i,
% W_i is its width and H_i is its height.

test1 :-
    disjoint2([a(0,1,0,1), a(0,1,1,1)]).

test2 :-
    disjoint2([a(0,1,0,1), b(0,1,1,1)]).

test3 :-
    disjoint2([a(0,1,1,1), a(0,1,1,1)]).

test4 :-
    disjoint2([a(0,1,1,1), b(0,1,1,1)]).

% ProfX(Grupo, cant_de _grupos=1, Lecc, cant_de_lecc=1).
% ProfX(Grupo, 1, Lecc, 1).
cases(Cs) :-
    Cs = [
        prof1(1,1,_,1),
        prof1(1,1,_,1),
        prof1(1,1,_,1),
        prof1(2,1,_,1),
        prof1(2,1,_,1),
        prof1(2,1,_,1),
        prof2(1,1,_,1),
        prof2(1,1,_,1),
        prof2(1,1,_,1),
        prof2(2,1,_,1),
        prof2(2,1,_,1),
        prof2(2,1,_,1)
    ].


constrain_cases(Cs) :-
    define_lecc_domain(Cs),

    % transform Cs into a list of lists
    maplist(=.., Cs, CsList),

    avoid_profgroup_lesson_dup(CsList),
    avoid_prof_overlaps(CsList),
    avoid_group_overlaps(CsList).


define_lecc_domain(Cs) :-
    maplist(lecc_in, Cs, Lecc_List),
    Lecc_List ins 0..5.


avoid_profgroup_lesson_dup(CsList) :-
    % extract (professor,group) tuples
    findall(
        (Prof, Grupo),
        member([Prof, Grupo, _, _, _], CsList),
        ProfGrupo_Tuples
    ),
    % extract lessons
    maplist(nth0(3), CsList, Lecc_List),
    % create pairs of ((prof,grupo), Lecc)
    pairs_keys_values(Pairs, ProfGrupo_Tuples, Lecc_List),
    % group by (prof,grupo))
    group_pairs_by_key(Pairs, ProfGroup_LeccListVal),
    % get a list of lessons for each profgroup
    pairs_values(ProfGroup_LeccListVal, ProfGLeccs_List),
    % format('ProfGLeccs_List 1: ~w~n', [ProfGLeccs_List]),
    % and enforce non-duplication of the lessons of each profgroup
    maplist(chain2(#<), ProfGLeccs_List).
    % format('ProfGLeccs_List 2: ~w~n', [ProfGLeccs_List]).


avoid_prof_overlaps(CsList) :-
    % extract profs
    maplist(nth0(0), CsList, Prof_List),
    % extract lessons
    maplist(nth0(3), CsList, Lecc_List),
    % create Prof-Lecc pairs
    pairs_keys_values(Pairs, Prof_List, Lecc_List),
    % group by prof
    group_pairs_by_key(Pairs, Prof_LeccList),
    % get a list of lessons for each prof
    pairs_values(Prof_LeccList, ProfLecc_Lists),
    % format('ProfLecc_Lists 1: ~w~n', [ProfLecc_Lists]),
    % and enforce non-duplication of the lessons of each profgroup
    maplist(all_distinct, ProfLecc_Lists).
    % format('ProfLecc_Lists 2: ~w~n', [ProfLecc_Lists]).


avoid_group_overlaps(CsList) :-
    % extract groups
    maplist(nth0(1), CsList, Group_List),
    % extract lessons
    maplist(nth0(3), CsList, Lecc_List),
    % create Group-Lecc pairs
    pairs_keys_values(Pairs, Group_List, Lecc_List),
    % group by group
    group_pairs_by_key(Pairs, Group_LeccList),
    % get a list of lessons for each group
    pairs_values(Group_LeccList, GroupLecc_Lists),
    % format('GroupLecc_Lists 1: ~w~n', [GroupLecc_Lists]),
    % and enforce non-duplication of the lessons of each profgroup
    maplist(all_distinct, GroupLecc_Lists).
    % format('GroupLecc_Lists 2: ~w~n', [GroupLecc_Lists]).


chain2(Rel, List) :-
    chain(List, Rel).


main :- 
    cases(Cs),
    constrain_cases(Cs),

    % format('Cs1: ~w~n', [Cs]),
    disjoint2(Cs),
    % format('Cs2: ~w~n', [Cs]),
    leccs_in(Cs, Lecc_List),
    % format('Lecc_List: ~w~n', [Lecc_List]),
    writeln("----.----1----.----2"),
    label(Lecc_List),
    write("|"), fail.
    % print_schedule(Cs),
    % format('Cs3: ~w~n', [Cs]).
main.


profs_in(Cs, Var_List) :-
    maplist(prof_in, Cs, Var_List).

groups_in(Cs, Var_List) :-
    maplist(group_in, Cs, Var_List).

leccs_in(Cs, Var_List) :-
    maplist(lecc_in, Cs, Var_List).


prof_in(Term, Prof) :-
    Term =.. [Prof, _Group, _, _Lecc, _].

group_in(Term, Group) :-
    Term =.. [_Func, Group, _, _Lecc, _].

lecc_in(Term, Lecc) :-
    Term =.. [_Func, _Group, _, Lecc, _].




print_schedule(Cs) :-
    maplist(=.., Cs, List),
    format('List: ~w~n', [List]),
    findall(
        [Prof, Lecc, Grupo],
        member([Prof, Grupo, _, Lecc, _], List),
        Schedule
    ),
    sort(Schedule, Sorted_Schedule),
    format('Sorted_Schedule: ~w~n', [Sorted_Schedule]),
    findall(Prof, member([Prof, _, _], Sorted_Schedule), Profs),
    sort(Profs, Unique_Profs),
    forall(
        member(Prof, Unique_Profs),
        (   format('Profesor: ~w~nGrupos:', [Prof]),
            forall(
                member([Prof, Lecc, Grupo], Sorted_Schedule),
                format('\t~w:~w', [Lecc,Grupo])
            ),
            nl
        )
    ).


