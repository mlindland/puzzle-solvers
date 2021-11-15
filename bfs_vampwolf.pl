% Magnus Lindland
% CS 427 Program 2
% BFS; Vampire/Warewolf; SlidingTles;
% Credit for BFS Algorithm and adt.pl goes to George F. Lugar.

:- consult('adt.pl').
:- consult('move_vampwolf.pl').
state_record(State, Parent, [State, Parent]).

go(Start, Goal) :- 
    empty_queue(Empty_open),
    state_record(Start, nil, State),
    add_to_queue(State, Empty_open, Open),
    empty_set(Closed),
    path(Open, Closed, Goal).

test1 :- go(state(0,0,0,0,0,0,0), state(1,1,1,1,1,1,1)).
test2 :- go(state(1,1,1,1,1,1,1), state(0,0,0,0,0,0,0)).

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
