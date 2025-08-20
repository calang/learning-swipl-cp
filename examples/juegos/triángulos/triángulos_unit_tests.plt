/** Sample Prolog unit test module

This is an example module of how unit tests can be written in Prolog.

Invoked with a command like this:

~~~{.sh}
# -f uses the file in replacement of the users initialization file
# -s uses the file as a script, without preventing the loading of the initialization file
# -g runs the goal after loading the file

swipl -f triángulos_unit_tests.plt -g run_tests,halt
~~~


@author Carlos Lang
@license MIT
*/


:- begin_tests(process).

:- ['cuántos_triángulos'].


test(distancia2_1) :-
    distancia2(1,2,4,6, 25).
test(distancia2_2) :-
    distancia2(0,0,3,4, 25).
test(distancia2_3, [fail]) :-
    distancia2(0,0,3,4, 24).
test(distancia2_3) :-
    distancia2(0,0,0,0, 0).
test(distancia2_4, [fail]) :-
    distancia2(0,0,0,0, 1).
test(distancia2_5) :-
    distancia2(0,0,0,1, 1).
test(distancia2_6) :-
    distancia2(0,0,0,1, 1).
test(distancia2_7) :-
    distancia2(0,0,1,0, 1).


test(tr_1, [fail]) :-
    triángulo_rect(punto(1,_,_), punto(1,_,_), punto(3,_,_)).
test(tr_2, [fail]) :-
    triángulo_rect(punto(1,_,_), punto(2,_,_), punto(2,_,_)).
test(tr_3, [fail]) :-
    triángulo_rect(punto(1,0,0), punto(2,0,0), punto(3,_,_)).
test(tr_4, [fail]) :-
    triángulo_rect(punto(1,0,0), punto(2,0,0), punto(3,3,3)).
test(tr_4, [fail]) :-
    triángulo_rect(punto(1,0,0), punto(2,0,1), punto(3,3,3)).

test(tr_5) :-
    punto(1,X0,Y0), punto(2,X1,Y1), punto(4,X2,Y2),
    triángulo_rect(punto(1,X0,Y0), punto(2,X1,Y1), punto(3,X2,Y2)).
test(tr_6) :-
    punto(1,X0,Y0), punto(3,X1,Y1), punto(7,X2,Y2),
    triángulo_rect(punto(1,X0,Y0), punto(2,X1,Y1), punto(3,X2,Y2)).
test(tr_7) :-
    punto(1,X0,Y0), punto(3,X1,Y1), punto(4,X2,Y2),
    triángulo_rect(punto(1,X0,Y0), punto(2,X1,Y1), punto(3,X2,Y2)).
test(tr_8) :-
    punto(1,X0,Y0), punto(5,X1,Y1), punto(7,X2,Y2),
    triángulo_rect(punto(1,X0,Y0), punto(2,X1,Y1), punto(3,X2,Y2)).

test(tr_9, [fail]) :-
    punto(1,X0,Y0), punto(6,X1,Y1), punto(7,X2,Y2),
    triángulo_rect(punto(1,X0,Y0), punto(2,X1,Y1), punto(3,X2,Y2)).


:- end_tests(process).
