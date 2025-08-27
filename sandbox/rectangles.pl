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


/*
Notes:
Below is a simple timetable problem with
- 2 professors (prof1, prof2)
- 2 groups (1, 2)
- 6 lessons (0..5)
- each professor teaches 3 lessons to each group (total 6 lessons per professor)
- each lesson is 1 time block long
- no overlapping lessons for professors or groups
- each professor teaches only one group at a time

The strategy is to represent each lesson as a rectangle of width 1 (one time block)
and height 1 (one group), and then use disjoint2/1 to ensure no overlapping rectangles.

Notice that the functor names (prof1, prof2) are used to identify the professors.

disjoint2/1
- requires the rectangles to be in the form F(X, W, Y, H),
where (X,Y) is the bottom-left corner of the rectangle, W is its width and H its height.
- ensures that no two rectangles overlap
- ignores the functor name, so it can be used to represent different entities (professors in this case)

Additional constraints are added via the constrain_cases/1 predicate.
*/


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


% define_lecc_domain(+Cs:list).
% Cs is a list of case terms for which the domain of the lesson variable is defined.
define_lecc_domain(Cs) :-
    maplist(lecc_in, Cs, Lecc_List),
    Lecc_List ins 0..5.


% avoid_profgroup_lesson_dup(+CsList:list).
% CsList is a list of case lists (the result of applying =.. to each case term).
% Ensures that no professor teaches the same lesson to the same group more than once.
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
    % and enforce non-duplication of the lessons of each profgroup
    maplist(chain2(#<), ProfGLeccs_List).


% avoid_prof_overlaps(+CsList:list).
% CsList is a list of case lists (the result of applying =.. to each case term).
% Ensures that no professor has overlapping lessons.
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
    % and enforce non-duplication of the lessons of each profgroup
    maplist(all_distinct, ProfLecc_Lists).


% avoid_group_overlaps(+CsList:list).
% CsList is a list of case lists (the result of applying =.. to each case term).
% Ensures that no group has overlapping lessons.
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
    % and enforce non-duplication of the lessons of each profgroup
    maplist(all_distinct, GroupLecc_Lists).


% chain2(+Rel:operator, +List:list).
chain2(Rel, List) :-
    chain(List, Rel).


main :- 
    cases(Cs),
    constrain_cases(Cs),

    disjoint2(Cs),
    leccs_in(Cs, Lecc_List),
    label(Lecc_List),
    print_schedule(Cs).


% profs_in(Cs, Var_List) :-
%     maplist(prof_in, Cs, Var_List).

% groups_in(Cs, Var_List) :-
%     maplist(group_in, Cs, Var_List).

leccs_in(Cs, Var_List) :-
    maplist(lecc_in, Cs, Var_List).


% prof_in(Term, Prof) :-
%     Term =.. [Prof, _Group, _, _Lecc, _].

% group_in(Term, Group) :-
%     Term =.. [_Func, Group, _, _Lecc, _].

lecc_in(Term, Lecc) :-
    Term =.. [_Func, _Group, _, Lecc, _].




print_schedule(Cs) :-
    maplist(=.., Cs, List),
    findall(
        [Prof, Lecc, Grupo],
        member([Prof, Grupo, _, Lecc, _], List),
        Schedule
    ),
    sort(Schedule, Sorted_Schedule),
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


