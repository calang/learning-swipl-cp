regions(Rs) :-
        Rs = [A,B,C,D,E,F],
        Rs ins 0..3,
        A #\= B, A #\= C, A #\= D, A #\= F,
        B #\= C, B #\= D,
        C #\= D, C #\= E,
        D #\= E, D #\= F,
        E #\= F.

integer_color(0, red).
integer_color(1, green).
integer_color(2, blue).
integer_color(3, yellow).

