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
        prof1(1,1,L1,1),
        prof1(1,1,L2,1),
        prof1(1,1,L3,1),
        prof1(2,1,L4,1),
        prof1(2,1,L5,1),
        prof1(2,1,L6,1),
        prof2(1,1,L7,1),
        prof2(1,1,L8,1),
        prof2(1,1,L9,1),
        prof2(2,1,L10,1),
        prof2(2,1,L11,1),
        prof2(2,1,L12,1)
    ],
    % avoid_profgroup_dup_lessons
    L1 #< L2, L2 #< L3, L4 #< L5, L5 #< L6,
    L7 #< L8, L8 #< L9, L10 #< L11, L11 #< L12,
    all_distinct([L1,L2,L3,L4,L5,L6]),
    all_distinct([L7,L8,L9,L10,L11,L12]),
    all_distinct([L1,L2,L3,L7,L8,L9]),
    all_distinct([L4,L5,L6,L10,L11,L12]).


constrain_cases(Cs) :-
    define_lecc_domain(Cs),
    avoid_profgroup_dup_lessons(Cs).

define_lecc_domain(Cs) :-
    maplist(lecc_in, Cs, Lecc_List),
    Lecc_List ins 0..5.

avoid_profgroup_dup_lessons(Cs) :-
    format('Cs01: ~w~n', [Cs]),
    % transform Cs into a list of lists
    maplist(=.., Cs, CsList),
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
    % for each professor, avoid lesson assignment duplication
    pairs_values(ProfGroup_LeccListVal, ProfGLeccs_List),
    % format('ProfGLeccs_List 1: ~w~n', [ProfGLeccs_List]),
    % maplist(all_distinct, ProfGLeccs_List),
    maplist(chain2(#<), ProfGLeccs_List),
    format('ProfGLeccs_List 2: ~w~n', [ProfGLeccs_List]).


chain2(Rel, List) :-
    chain(List, Rel).



main :- 
    cases(Cs),
    constrain_cases(Cs),

    % format('Cs1: ~w~n', [Cs]),
    disjoint2(Cs),
    % format('Cs2: ~w~n', [Cs]),
    leccs_in(Cs, Lecc_List),
    format('Lecc_List: ~w~n', [Lecc_List]),
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


