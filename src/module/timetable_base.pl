% basic predicates for timetable

:- module(timetable_base, [
    lecc_por_sem/1,
    lecc_por_dia/1,
    grupo/1,
    aula/1,
    prof/1,
    grupo_materia_leccion/3,
    prof_grupo_materia/3,
    disp_prof_dia_bloque_leccion/4,
    dia_bloque_leccion/3,
    dia/1,
    bloque/1,
    leccion/1
]).

% lecc_por_sem(?LS:int).
% LS es el total de lecciones por semana por grupo.
lecc_por_sem(40).

% lecc_por_dia(?LD:int).
% LD es total de lecciones por dia por grupo.
lecc_por_dia(8).

% grupo(?Grupo:atom).
grupo(inter).
grupo(trans).
grupo(1).
grupo(2).
grupo(3).
grupo(4).
grupo(5).
grupo(6).

% aula(?Aula:atom).
aula(inter).
aula(trans).
aula(1).
aula(2).
aula(3).
aula(4).
aula(5).
aula(6).

% prof(?Profesor:atom).
prof(alisson).
prof(alonso).
prof(angie).
prof(audry).
prof(daleana).
prof(gina).
prof(jonathan).
prof(mayela).
prof(melissa).
prof(mjose).
prof(mpaula).
prof(sol).


% grupo_materia_leccion(+Grupo:atom, ?Materia:atom, ?Cant_lecciones:int)
%
% El Grupo, de Materia requiere Cant_lecciones.

grupo_materia_leccion(inter, edfís, 2).
grupo_materia_leccion(inter, infor, 1).
grupo_materia_leccion(inter, inglés, 11).
grupo_materia_leccion(inter, música, 1).

grupo_materia_leccion(trans, edfís, 2).
grupo_materia_leccion(trans, infor, 1).
grupo_materia_leccion(trans, inglés, 8).
grupo_materia_leccion(trans, música, 1).
grupo_materia_leccion(trans, resto_sol, 10).
% grupo_materia_leccion(trans, resto_audry, 8).

grupo_materia_leccion(1, arte, 1).
grupo_materia_leccion(1, ciencias, 4).
grupo_materia_leccion(1, edfís, 2).
grupo_materia_leccion(1, español, 7).
grupo_materia_leccion(1, estsoc, 4).
grupo_materia_leccion(1, ética, 1).
grupo_materia_leccion(1, infor, 2).
grupo_materia_leccion(1, inglés, 8).
grupo_materia_leccion(1, mate, 8).
grupo_materia_leccion(1, música, 1).

grupo_materia_leccion(2, arte, 1).
grupo_materia_leccion(2, ciencias, 4).
grupo_materia_leccion(2, edfís, 2).
grupo_materia_leccion(2, español, 7).
grupo_materia_leccion(2, estsoc, 4).
grupo_materia_leccion(2, ética, 1).
grupo_materia_leccion(2, infor, 2).
grupo_materia_leccion(2, inglés, 10).
grupo_materia_leccion(2, mate, 8).
grupo_materia_leccion(2, música, 1).

grupo_materia_leccion(3, arte, 1).
grupo_materia_leccion(3, ciencias, 4).
grupo_materia_leccion(3, edfís, 2).
grupo_materia_leccion(3, español, 7).
grupo_materia_leccion(3, estsoc, 4).
grupo_materia_leccion(3, ética, 1).
grupo_materia_leccion(3, infor, 2).
grupo_materia_leccion(3, inglés, 10).
grupo_materia_leccion(3, mate, 8).
grupo_materia_leccion(3, música, 1).

grupo_materia_leccion(4, ciencias, 4).
grupo_materia_leccion(4, edfís, 2).
grupo_materia_leccion(4, español, 6).
grupo_materia_leccion(4, estsoc, 5).
grupo_materia_leccion(4, ética, 1).
grupo_materia_leccion(4, francés, 2).
grupo_materia_leccion(4, infor, 2).
grupo_materia_leccion(4, inglés, 9).
grupo_materia_leccion(4, mate, 8).
grupo_materia_leccion(4, música, 1).

grupo_materia_leccion(5, ciencias, 4).
grupo_materia_leccion(5, edfís, 2).
grupo_materia_leccion(5, español, 5).
grupo_materia_leccion(5, estsoc, 6).
grupo_materia_leccion(5, ética, 1).
grupo_materia_leccion(5, francés, 2).
grupo_materia_leccion(5, infor, 2).
grupo_materia_leccion(5, inglés, 9).
grupo_materia_leccion(5, mate, 8).
grupo_materia_leccion(5, música, 1).

grupo_materia_leccion(6, ciencias, 6).
grupo_materia_leccion(6, edfís, 2).
grupo_materia_leccion(6, español, 5).
grupo_materia_leccion(6, estsoc, 4).
grupo_materia_leccion(6, ética, 1).
grupo_materia_leccion(6, francés, 2).
grupo_materia_leccion(6, infor, 2).
grupo_materia_leccion(6, inglés, 9).
grupo_materia_leccion(6, mate, 8).
grupo_materia_leccion(6, música, 1).

grupo_materia_leccion(Nivel, resto, Resto) :-
    lecc_por_sem(Lecc_por_sem),
    nivel(Nivel),
    findall(
        Cantidad,
        (   dif(resto, Materia),
            grupo_materia_leccion(Nivel, Materia, Cantidad)
        ),
        Lecciones
    ),
    sum_list(Lecciones, Suma_Cantidad),
    Resto #= Lecc_por_sem - Suma_Cantidad.


% prof_grupo_materia(?Profesor:atom, ?Nivel:atom, ?Materia:atom)
%
% Profesor es un profesor que está asignado a la materia Materia en el nivel Nivel.
prof_grupo_materia(mpaula, inter, edfís).  % <-- ???
prof_grupo_materia(jonathan, inter, infor).
prof_grupo_materia(mjose, inter, inglés).
prof_grupo_materia(alonso, inter, música).
prof_grupo_materia(alisson, inter, resto).

prof_grupo_materia(mpaula, trans, edfís).
prof_grupo_materia(jonathan, trans, infor).
prof_grupo_materia(audry, trans, inglés).
prof_grupo_materia(alonso, trans, música).
prof_grupo_materia(sol, trans, resto_sol).
prof_grupo_materia(alisson, trans, resto).

prof_grupo_materia(mjose, 1, arte).
prof_grupo_materia(sol, 1, ciencias).
prof_grupo_materia(mpaula, 1, edfís).
prof_grupo_materia(sol, 1, español).
prof_grupo_materia(sol, 1, estsoc).
prof_grupo_materia(mjose, 1, ética).
prof_grupo_materia(jonathan, 1, infor).
prof_grupo_materia(audry, 1, inglés).
prof_grupo_materia(sol, 1, mate).
prof_grupo_materia(alonso, 1, música).
prof_grupo_materia(sol, 1, resto).

prof_grupo_materia(alisson, 2, arte).
prof_grupo_materia(mjose, 2, ciencias).
prof_grupo_materia(mpaula, 2, edfís).
prof_grupo_materia(mjose, 2, español).
prof_grupo_materia(mjose, 2, estsoc).
prof_grupo_materia(alisson, 2, ética).
prof_grupo_materia(jonathan, 2, infor).
prof_grupo_materia(gina, 2, inglés).
prof_grupo_materia(mjose, 2, mate).
prof_grupo_materia(alonso, 2, música).
prof_grupo_materia(mjose, 2, resto).

prof_grupo_materia(mjose, 3, arte).
prof_grupo_materia(audry, 3, ciencias).
prof_grupo_materia(mpaula, 3, edfís).
prof_grupo_materia(audry, 3, español).
prof_grupo_materia(audry, 3, estsoc).
prof_grupo_materia(mjose, 3, ética).
prof_grupo_materia(jonathan, 3, infor).
prof_grupo_materia(gina, 3, inglés).
prof_grupo_materia(audry, 3, mate).
prof_grupo_materia(alonso, 3, música).
prof_grupo_materia(audry, 3, resto).

prof_grupo_materia(mayela, 4, ciencias).
prof_grupo_materia(mpaula, 4, edfís).
prof_grupo_materia(mayela, 4, español).
prof_grupo_materia(mayela, 4, estsoc).
prof_grupo_materia(alisson, 4, ética).
prof_grupo_materia(angie, 4, francés).
prof_grupo_materia(jonathan, 4, infor).
prof_grupo_materia(gina, 4, inglés).
prof_grupo_materia(mayela, 4, mate).
prof_grupo_materia(alonso, 4, música).
prof_grupo_materia(mayela, 4, resto).

prof_grupo_materia(mayela, 5, ciencias).
prof_grupo_materia(mpaula, 5, edfís).
prof_grupo_materia(daleana, 5, español).
prof_grupo_materia(daleana, 5, estsoc).
prof_grupo_materia(alisson, 5, ética).
prof_grupo_materia(angie, 5, francés).
prof_grupo_materia(jonathan, 5, infor).
prof_grupo_materia(gina, 5, inglés).
prof_grupo_materia(mayela, 5, mate).
prof_grupo_materia(alonso, 5, música).
prof_grupo_materia(mayela, 5, resto).

prof_grupo_materia(daleana, 6, ciencias).
prof_grupo_materia(mpaula, 6, edfís).
prof_grupo_materia(daleana, 6, español).
prof_grupo_materia(daleana, 6, estsoc).
prof_grupo_materia(alisson, 6, ética).
prof_grupo_materia(angie, 6, francés).
prof_grupo_materia(jonathan, 6, infor).
prof_grupo_materia(melissa, 6, inglés).
prof_grupo_materia(daleana, 6, mate).
prof_grupo_materia(alonso, 6, música).
prof_grupo_materia(daleana, 6, resto).


% dia_bloque_leccion(?Dia:atom, ?Bloque:atom, ?Leccion:atom).
%
% Existe para un Dia un Bloque con una Leccion.

dia_bloque_leccion(Dia, Bloque, Leccion) :-
    dia(Dia),
    bloque(Bloque),
    leccion(Leccion).

dia(lun).
dia(mar).
dia(mie).
dia(jue).
dia(vie).

bloque(1).
bloque(2).
bloque(3).
bloque(4).

leccion(a).
leccion(b).


% disp_prof_dia_bloque_leccion(?Prof:atom, ?Dia:atom, ?Bloque:atom, ?Leccion:atom).
%
% Prof es un profesor, disponible el Dia, en Bloque y Leccion.
disp_prof_dia_bloque_leccion(angie, mie, B, L) :-
    member(B, [1,2,3,4]),
    member(L, [a,b]).
disp_prof_dia_bloque_leccion(mpaula, D, B, L) :-
    member(D, [lun,mar,jue]),
    bloque(B),
    leccion(L).
disp_prof_dia_bloque_leccion(alonso, mie, B, L) :-
    bloque(B),
    leccion(L).
disp_prof_dia_bloque_leccion(P, D, B, L) :-
    member(P, [melissa, jonathan, gina, audry, daleana, mayela, mjose, sol, alisson]),
    dia(D),
    bloque(B),
    leccion(L).
