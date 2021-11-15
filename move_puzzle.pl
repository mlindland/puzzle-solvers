
writelist([]).
writelist([N1,N2,N3,N4 | Rest]) :- format('[~w ~w ~w ~w]~n', [N1, N2, N3, N4]), writelist(Rest).

add(N1, N2, Result) :- Result is N1+N2.
swap_elements(List, I, J, Result) :- 
    same_length(List, Result),
    append(BeforeI, [AtI | PastI], List),
    append(BeforeI, [AtJ | PastI], List1),
    append(BeforeJ, [AtJ | PastJ], List1),
    append(BeforeJ, [AtI | PastJ], Result),
    length(BeforeI, I),
    length(BeforeJ, J).


indexof(Index,Element,List) :- nth0(Index1,List,Element), Index is Index1.
% equal(X,X).
up(State) :-
    indexof(I,0,State), I \== 0,
    indexof(I,0,State), I \== 1,
    indexof(I,0,State), I \== 2,
    indexof(I,0,State), I \== 3.
down(State) :-
    indexof(I,0,State), I \== 12,
    indexof(I,0,State), I \== 13,
    indexof(I,0,State), I \== 14,
    indexof(I,0,State), I \== 15.
left(State) :- 
    indexof(I,0,State), I \== 0,
    indexof(I,0,State), I \== 4,
    indexof(I,0,State), I \== 8,
    indexof(I,0,State), I \== 12.
right(State) :-
    indexof(I,0,State), I \== 3,
    indexof(I,0,State), I \== 7,
    indexof(I,0,State), I \== 12,
    indexof(I,0,State), I \== 15.

    % move left
move(State, Next) :-
    left(State),
    indexof(Index, 0, State),
    add(Index, -1, J),
    swap_elements(State, Index, J, Next).
    % write('try moving left'), nl.

    % move right
move(State, Next) :- 
    right(State),
    indexof(Index, 0, State),
    add(Index,1, J),
    swap_elements(State, Index, J, Next).
    % write('try moving right'), nl.

    %move up
move(State, Next) :-
    up(State),
    indexof(Index, 0, State),
    add(Index, -4, J),
    swap_elements(State, Index, J, Next).
    % write('try moving up'), nl.

    %move down
move(State, Next) :-
    down(State),
    indexof(Index, 0, State),
    add(Index, 4, J),
    swap_elements(State, Index, J, Next).
    % write('try moving down'),nl.
move(_, _) :-
    fail.