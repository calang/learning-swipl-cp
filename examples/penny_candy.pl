%
%  penny candy example
%  Timmy has 25 cents
%  gumballs cost a penny
%  snickers cost 10 cents
%  toffees are 2 cents
%  licorice costs 5 cents
%
%  what are Timmys alternatives?
%  assume Timmy spends the entire 25 cents

scalar_test(Candy) :-
	Candy = [_Gumball, _Snickers, _Toffee, _Licorice],
	Candy ins 0..sup,
	scalar_product([1, 10, 2, 5], Candy, #=, 25),
	label(Candy).

:- scalar_test([Gumball, Snickers, Toffee, Licorice]),
    writeln([Gumball, Snickers, Toffee, Licorice]).
