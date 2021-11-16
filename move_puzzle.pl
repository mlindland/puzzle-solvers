:- use_module(library(listing)).
writelist([]).
writelist([N1, N2, N3, N4|Rest]) :-
    format('[~w ~w ~w ~w]~n', [N1, N2, N3, N4]),
    writelist(Rest).

add(N1, N2, Result) :-
    Result is N1+N2.

swap_elements(List, I, J, Result) :-
    same_length(List, Result),
    append(BeforeI, [AtI|PastI], List),
    append(BeforeI, [AtJ|PastI], List1),
    append(BeforeJ, [AtJ|PastJ], List1),
    append(BeforeJ, [AtI|PastJ], Result),
    length(BeforeI, I),
    length(BeforeJ, J).

% test2 :- heuristic([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0],
%     [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0], 
%     [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0],
%     [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0], H).

heuristic([], [], _, _, 0).
heuristic([Head_state | Rest_state], [_| Rest_goal],List1, List2, H) :-
    indexof(IState, Head_state, List1),
    indexof(IGoal, Head_state, List2),
    get_x_y(IState, I, J),
    get_x_y(IGoal, R, C),
    DeltaX is C - J,
    DeltaY is R - I,
    abs(DeltaX, X),
    abs(DeltaY, Y),
    heuristic(Rest_state, Rest_goal, List1, List2, Remaining),
    H is X + Y + Remaining.

get_x_y(Index, I, J) :-
    I is div(Index, 4),
    J is mod(Index, 4).

indexof(Index, Element, List) :-
    nth0(Index1, List, Element),
    Index is Index1.

up(State) :-
    indexof(I, 0, State),
    I\==0,
    indexof(I, 0, State),
    I\==1,
    indexof(I, 0, State),
    I\==2,
    indexof(I, 0, State),
    I\==3.
down(State) :-
    indexof(I, 0, State),
    I\==12,
    indexof(I, 0, State),
    I\==13,
    indexof(I, 0, State),
    I\==14,
    indexof(I, 0, State),
    I\==15.
left(State) :-
    indexof(I, 0, State),
    I\==0,
    indexof(I, 0, State),
    I\==4,
    indexof(I, 0, State),
    I\==8,
    indexof(I, 0, State),
    I\==12.
right(State) :-
    indexof(I, 0, State),
    I\==3,
    indexof(I, 0, State),
    I\==7,
    indexof(I, 0, State),
    I\==11,
    indexof(I, 0, State),
    I\==15.

    % move left
move(State, Next) :-
    left(State),
    indexof(Index, 0, State),
    add(Index, -1, J),
    swap_elements(State, Index, J, Next),
    write('-------------Start------------'), nl,
    writelist(State),
    write('try moving left'), nl,
    writelist(Next),
    write('--------------End-------------'), nl.

    % move right
move(State, Next) :-
    right(State),
    indexof(Index, 0, State),
    add(Index, 1, J),
    swap_elements(State, Index, J, Next),
    write('-------------Start------------'), nl,
    writelist(State),
    write('try moving right'), nl,
    writelist(Next), nl,
    write('--------------End-------------'), nl.


    %move up
move(State, Next) :-
    up(State),
    indexof(Index, 0, State),
    add(Index, -4, J),
    swap_elements(State, Index, J, Next),
    write('-------------Start------------'), nl,
    writelist(State),
    write('try moving up'), nl,
    writelist(Next), nl,
    write('--------------End-------------'), nl.


    %move down
move(State, Next) :-
    down(State),
    indexof(Index, 0, State),
    add(Index, 4, J),
    swap_elements(State, Index, J, Next),
    write('-------------Start------------'), nl,
    writelist(State),
    write('try moving down'), nl,
    writelist(Next), nl,
    write('--------------End-------------'), nl.


% test2 :- 
%     move([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0], Next),
%     maplist(portray_clause, Next).