:- use_module(library(pairs)).

my_schedule_today(Starts, Durations) :-
  % unordered list of stuff to do today
  % in a real problem we'd probably use minutes, these are hours in 24 hour format
    Starts = [PrepForSmith, MeetWithSmith, _WriteDBInstaller, Lunch, _CallAlice, _ReadDocs],
  % and how long they'll take
    Durations = [2, 1, 2, 1, 1, 1],
  % make all of them start in 9am to 5pm
    Starts ins 9..17,
  % and make sure lunch happens at noon or 1pm
    Lunch in 12 \/ 13,
  % Meeting with Smith is planned for 1pm
    MeetWithSmith #= 13,
  % have to do the prep before the meeting
	PrepForSmith #< MeetWithSmith,
  % enforce being serialized
    serialized(Starts, Durations).

demo_my_schedule(Starts, Durations) :-
	my_schedule_today(Starts, Durations),
	append(Starts, Durations, Vars),
	label(Vars),
	pairs_keys_values(
        NameDurs,
        ['Prep for Smith', 'Meet With Smith', 'Write DB Installer',
         'Lunch', 'Call Alice', 'Read Flubbercalc Docs'
        ],
        Durations
    ),
	pairs_keys_values(Pairs, Starts, NameDurs),
	keysort(Pairs, Sorted),
	pairs_keys_values(Sorted, SortStarts, SortNameDurs),
	print_sched(SortStarts, SortNameDurs).

print_sched([], _).
print_sched([Start | ST], [Name-Duration | T]) :-
	format('~w: ~w  (~w hr)~n', [Start, Name, Duration]),
	print_sched(ST, T).

% ?- demo_my_schedule(Starts, Durations).