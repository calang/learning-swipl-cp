multi_source_automaton(Vs) :-
	automaton(Vs, [source(a),source(e), sink(d), sink(h)],
		  [arc(a,0,b),
		   arc(b,0,b),
		   arc(b,1,c),
		   arc(c,2,d),
		   arc(e,10,f),
		   arc(f,10,f),
		   arc(f,11,g),
		   arc(g,12,h)]).

demo_len(Vs) :-
	length(Vs, 4),
	multi_source_automaton(Vs),
	label(Vs).

