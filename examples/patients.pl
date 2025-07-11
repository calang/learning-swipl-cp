% patient(
%     ID,
%     Name,
%     YearAdmitted,
% 	MonthAdmitted,
% 	DayAdmitted,
% 	HourAdmitted,
% 	MinuteAdmitted,
% 	Status,
% 	Payment
% )

patient(1, 'Bob Jones', 2014, 10, 1, 4, 55, 0, 2).
patient(2, 'Sally Smith', 2014, 9, 29, 5, 15, 1, 0).
patient(3, 'Ted Overton', 2014, 9, 30, 14, 15, 0, 0).
patient(4, 'Arnold Abouja', 2014, 10, 1, 5, 0, 0, 0).
patient(5, 'Seth Humbolt', 2014, 10, 1, 5, 10, 0, 0).

length_(Length, List) :- length(List, Length).

spatients_rows_cols(SPatients, Rows, Cols) :-
    length(SPatients, Rows), maplist(length_(Cols), SPatients).

patients_list(Patients) :-
    findall(
        [StatusNeg, YearAdmitted, MonthAdmitted, DayAdmitted, HourAdmitted1, MinuteAdmitted, Payment, ID],
        (
            patient(ID, _Name, YearAdmitted, MonthAdmitted, DayAdmitted, HourAdmitted, MinuteAdmitted, Status, Payment),
            StatusNeg #= -Status,
            (
                Payment = 2
                -> HourAdmitted1 #= HourAdmitted + 1
                ; HourAdmitted1 #= HourAdmitted
            )
        ),
        Patients
    ).

sp_ids([H|R], [Hid|Hrest]) :-
    last(H,Hid),
    sp_ids(R, Hrest).
sp_ids([], []).

all_distinct_sp(SPatients) :-
    sp_ids(SPatients, Id_list),
    all_distinct(Id_list).

see_patients(Patients, SPatients) :-
    % problem
    length(Patients, Rows),
    Patients = [Pat1|_],
    length(Pat1, Cols),
    % solution
    spatients_rows_cols(SPatients, Rows, Cols),
    % constraints
    % can be specified in any order; execution time is not affected in this case
    tuples_in(SPatients, Patients),
    all_distinct_sp(SPatients),
    lex_chain(SPatients),
    % labeling
    flatten(SPatients, Flat),
    label(Flat).

:- patients_list(Patients),
   writeln(Patients),
   see_patients(Patients, SPatients),
   writeln(SPatients).

