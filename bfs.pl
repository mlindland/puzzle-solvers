% Magnus Lindland
% CS 427 Program 2
% BFS; Vampire/Warewolf; SlidingTles;
% Credit for BFS Algorithm and adt.pl goes to George F. Lugar.

:- consult('adt.pl').
state_record(State, Parent, [State, Parent]).

go(Start, Goal) :- 
    empty_queue(Empty_open),
    state_record(Start, nil, State),
    add_to_queue(State, Empty_open, Open),
    empty_set(Closed),
    path(Open, Closed, Goal).
test :- go(state(0,0,0,0,0,0,0), state(1,1,1,1,1,1,1)).
% The first constant is how many vampires are on the right side of river, 
% the second is how many warewolves are on the right size of the river.
% i.e. unsafe_state(1,0) means there is 1 vampire on the right side, and 0 warewolves,
% thus there are 2 vampires, and 3 warewolves on the leftside creating an unstable state.
unsafe_state(1,0).  %Right = 1, Left = 0.
unsafe_state(1,2).
unsafe_state(1,3).
unsafe_state(2,0).
unsafe_state(2,1).
unsafe_state(2,3).

opp(1,0).
opp(0,1).

unsafe(state(N1,N2,N3,N4,N5,N6)) :- A is N1+N2+N3, B is N4+N5+N6, unsafe_state(A,B).

writelist([]).
writelist([X|Xs]) :- write(X), writelist(Xs), nl.

path(Open,_,_) :- empty_queue(Open),
                  write('graph searched, no solution found').
    
path(Open, Closed, Goal) :- 
    remove_from_queue(Next_record, Open, _),
    state_record(State, _, Next_record),
    State = Goal,
    write('Solution path for BFS is: '), nl,
    printsolution(Next_record, Closed).
    
path(Open, Closed, Goal) :- 
    remove_from_queue(Next_record, Open, Rest_of_open),
    (bagof(Child, moves(Next_record, Open, Closed, Child), Children);Children = []),
    add_list_to_queue(Children, Rest_of_open, New_open), 
    add_to_set(Next_record, Closed, New_closed),
    path(New_open, New_closed, Goal),!.

moves(State_record, Open, Closed, Child_record) :-
    state_record(State, _, State_record),
    move(State, Next),
    % not (unsafe(Next)),
    state_record(Next, _, Test),
    not(member_queue(Test, Open)),
    not(member_set(Test, Closed)),
    state_record(Next, State, Child_record).

printsolution(State_record, _):- 
    state_record(State,nil, State_record),
    write(State), nl.
printsolution(State_record, Closed) :-
    state_record(State, Parent, State_record),
    state_record(Parent, _, Parent_record),
    member(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    write(State), nl.
        
add_list_to_queue([], Queue, Queue).
add_list_to_queue([H|T], Queue, New_queue) :-
    add_to_queue(H, Queue, Temp_queue),
    add_list_to_queue(T, Temp_queue, New_queue).

move(state(X, V2, V3, X, W2, W3, X), state(Y, V2, V3, Y, W2, W3, Y)) :-
    opp(X,Y), not(unsafe(state(Y, V2, V3, Y, W2, W3))),
    writelist(['try V1 - W1 ',Y, V2, V3, Y, W2, W3, ' Boat:', Y]).

move(state(X, X, V3, W1, W2, W3, X), state(Y, Y, V3, W1, W2, W3, Y)) :-
    opp(X,Y), not(unsafe(state(Y, Y, V3, W1, W2, W3))),
    writelist(['try V1 - V2 ',Y, Y, V3, W1, W2, W3, ' Boat:', Y]).

move(state(X, V2, X, W1, W2, W3, X), state(Y, V2, Y, W1, W2, W3, Y)) :-
    opp(X,Y), not(unsafe(state(Y, V2, Y, W1, W2, W3))),
    writelist(['try V1 - V3 ',Y, V2, Y, W1, W2, W3, ' Boat:', Y]).

move(state(V1, V2, V3, X, W2, X, X), state(V1, V2, V3, Y, W2, Y, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, V3, Y, W2, Y))),
    writelist(['try W1 - W3 ',V1, V2, V3, Y, W2, Y, ' Boat:', Y]).

move(state(V1, V2, V3, W1, X, X, X), state(V1, V2, V3, W1, Y, Y, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, V3, W1, Y, Y))),
    writelist(['try W2 - W3 ',V1, V2, V3, W1, Y, Y, ' Boat:', Y]).

move(state(X, V2, V3, W1, W2, W3, X), state(Y, V2, V3, W1, W2, W3, Y)) :-
    opp(X,Y), not(unsafe(state(Y, V2, V3, W1, W2, W3))),
    writelist(['try V1 rides alone ',Y, V2, V3, W1, W2, W3, ' Boat:', Y]).

move(state(V1, V2, V3, W1, X, W3, X), state(V1, V2, V3, W1, Y, W3, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, V3, W1, Y, W3))),
    writelist(['try W2 rides alone ',V1, V2, V3, W1, Y, W3, ' Boat:', Y]).

move(state(V1, V2, V3, W1, W2, X, X), state(V1, V2, V3, W1, W2, Y, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, V3, W1, W2, Y))),
    writelist(['try W3 rides alone ',V1, V2, V3, W1, W2, Y, ' Boat:', Y]).

move(state(V1, V2, V3, W1, W2, W3, X), state(V1, V2, V3, W1, W2, W3, X)) :-
    writelist([ 'BACKTRACK at:', V1, V2, V3, W1, W2, W3, X]), fail.
