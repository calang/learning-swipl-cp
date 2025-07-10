% this fails, since apple is not an integer.
% :- X #= apple, writeln(X).

% Domain error: `clpfd_domain' expected, found `[apple,banana,cherry]'
% :- X in [apple, banana, cherry], X #< cherry, writeln(X).

% Domain error: `clpfd_domain' expected, found `[apple,banana,cherry]'
% :- X in [apple, banana, cherry], writeln(X).

% from https://www.swi-prolog.org/pldoc/doc_for?object=in/2:

% ?Var in +Domain

% Var is an element of Domain. Domain is one of:
% Integer
%   Singleton set consisting only of Integer.
% Lower .. Upper
%   All integers I such that Lower =< I =< Upper. Lower must be an integer or the atom inf, which denotes negative infinity. Upper must be an integer or the atom sup, which denotes positive infinity.
% Domain1 \/ Domain2
%   The union of Domain1 and Domain2.
