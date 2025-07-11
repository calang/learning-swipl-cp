same_side_of_line(
    point{x: X1, y: Y1},
    point{x: X2, y: Y2},
    point{x: X3, y: Y3},
    point{x: X4, y: Y4}
) :-
    % writeln((X1, Y1, X2, Y2, X3, Y3, X4, Y4)),
    M #= (Y2 - Y1) // (X2 - X1),
    B #= Y1 - M * X1,
    Y3_ #= M * X3 + B,
    Y4_ #= M * X4 + B,
    writeln((Y3, Y4)),
    writeln((M, B, Y3_, Y4_)),
    % (Y3 >= Y3_ -> Y3_Side = above ; Y3_Side = below),
    % (Y4 >= Y4_ -> Y4_Side = above ; Y4_Side = below),
    zcompare(Y3_Side, Y3, Y3_),
    zcompare(Y4_Side, Y4, Y4_),
    writeln((Y3_Side, Y4_Side)),
    Y3_Side == Y4_Side.
% Example usage:
:- same_side_of_line(point{x: 1, y: 2}, point{x: 3, y: 4}, point{x: 2, y: 3}, point{x: 4, y: 5}),
   writeln('Points are on the same side of the line') ; writeln('Points are on different sides of the line'),
   !.
% true.
:- same_side_of_line(point{x: 1, y: 2}, point{x: 3, y: 4}, point{x: 2, y: 1}, point{x: 4, y: 5}),
   writeln('Points are on the same side of the line') ; writeln('Points are on different sides of the line'),
   !.
% false.
:- same_side_of_line(point{x: 1, y: 2}, point{x: 3, y: 4}, point{x: 2, y: 3}, point{x: 4, y: 1}),
   writeln('Points are on the same side of the line') ; writeln('Points are on different sides of the line'),
   !.
% false.
:- same_side_of_line(point{x: 1, y: 2}, point{x: 3, y: 4}, point{x: 2, y: 3}, point{x: 4, y: 3}),
   writeln('Points are on the same side of the line') ; writeln('Points are on different sides of the line'),
   !.
% true.
