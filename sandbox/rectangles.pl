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

% profX(Grupo, cant_de _grupos=1, Lecc, cant_de_lecc=1).
% profX(Grupo, 1, Lecc, 1).
cases(Cs) :-
    Cs = [
        prof1(G1,1,L1,1),
        prof1(G1,1,L2,1),
        prof1(G1,1,L3,1),
        prof1(G2,1,L4,1),
        prof1(G2,1,L5,1),
        prof1(G2,1,L6,1),
        prof2(G1,1,L7,1),
        prof2(G1,1,L8,1),
        prof2(G1,1,L9,1),
        prof2(G2,1,L10,1),
        prof2(G2,1,L11,1),
        prof2(G2,1,L12,1)
    ],
    % [G1,G2,G3,G4,G5,G6] ins 0..1,
    [G1,G2] ins 0..1,
    [L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12] ins 0..5,
    L1 #< L2, L2 #< L3, L4 #< L5, L5 #< L6,
    L7 #< L8, L8 #< L9, L10 #< L11, L11 #< L12.

main(Cs) :- 
    cases(Cs),
    % format('Cs1: ~w~n', [Cs]),
    disjoint2(Cs),
    % format('Cs2: ~w~n', [Cs]),
    vars_in(Cs, Var_List),
    % format('Var_List: ~w~n', [Var_List]),
    label(Var_List),
    print_schedule(Cs).
    % format('Cs3: ~w~n', [Cs]).

print_schedule(Cs) :-
    maplist(=.., Cs, List),
    % format('List: ~w~n', [List]),
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
                member([Prof, _Lecc, Grupo], Sorted_Schedule),
                format('\t~w', [Grupo])
            ),
            nl
        )
    ).

vars_in(Cs, Var_List) :-
    maplist(group_var_in, Cs, Group_List),
    maplist(lecc_var_in, Cs, Lecc_List),
    append(Group_List, Lecc_List, Var_List).

group_var_in(Term, Group) :-
    Term =.. [_Func, Group, _, _Lecc, _].

lecc_var_in(Term, Lecc) :-
    Term =.. [_Func, _Group, _, Lecc, _].

