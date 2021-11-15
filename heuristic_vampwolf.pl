% Magnus Lindland
% CS 427 Program 2
% BFS; Vampire/Warewolf; SlidingTles;
% Credit for BFS Algorithm and adt.pl goes to George F. Lugar.

:- consult('adt.pl').
:- consult('move_vampwolf.pl').

state_record(State, Parent, G, H, F, [State, Parent, G, H, F]).

    % go initializes Open and CLosed and calls path 
go(Start, Goal) :- 
    empty_set(Closed),
    empty_sort_queue(Empty_open),
    heuristic(Start, H),
    state_record(Start, nil, 0, H, H, First_record),
    insert_sort_queue(First_record, Empty_open, Open),
    path(Open,Closed, Goal).

test1 :- go(state(0,0,0,0,0,0,0), state(1,1,1,1,1,1,1)). 
test2 :- go(state(1,1,1,1,1,1,1), state(0,0,0,0,0,0,0)).

    % Path performs a best first search,
    % maintaining Open as a priority queue, and Closed as
    % a set.
    
    % Open is empty; no solution found
path(Open,_,_) :- 
    empty_sort_queue(Open),
    write("graph searched, no solution found").

    % The next record is a goal
    % Print out the list of visited states
path(Open, Closed, Goal) :- 
    remove_sort_queue(First_record, Open, _),
    state_record(State, _, _, _, _, First_record),
    State = Goal,
    write('Solution path for heuristic is: '), nl,write('state(V1,V2,V3,W1,W2,W3,Boat)'), nl,
    printsolution(First_record, Closed).
    
    % The next record is not equal to the goal
    % Generate its children, add to open and continue
    % Note that bagof in AAIS prolog fails if its goal fails, 
    % I needed to use the or to make it return an empty list in this case
path(Open, Closed, Goal) :- 
    remove_sort_queue(First_record, Open, Rest_of_open),
    (bagof(Child, moves(First_record, Open, Closed, Child), Children);Children = []),
    insert_list(Children, Rest_of_open, New_open),
    add_to_set(First_record, Closed, New_closed),
    path(New_open, New_closed, Goal),!.
    
    % moves generates all children of a state that are not already on
    % open or closed.  The only wierd thing here is the construction
    % of a state record, test, that has unbound variables in all positions
    % except the state.  It is used to see if the next state matches
    % something already on open or closed, irrespective of that states parent
    % or other attributes
    % Also, I've commented out unsafe since the way I've coded the water jugs 
    % problem I don't really need it.
moves(State_record, Open, Closed,Child) :-
    state_record(State, _, G, _,_, State_record),
    move(State, Next),
    % not(unsafe(Next)),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristic(Next, H),
    F is G_new + H,
    state_record(Next, State, G_new, H, F, Child).
    
    %insert_list inserts a list of states obtained from a  call to
    % bagof and  inserts them in a priotrity queue, one at a time
insert_list([], L, L).
insert_list([State | Tail], L, New_L) :-
    insert_sort_queue(State, L, L2),
    insert_list(Tail, L2, New_L).

    % Printsolution prints out the solution path by tracing
    % back through the states on closed using parent links.
printsolution(Next_record, _):-  
    state_record(State, nil, _, _,_, Next_record),
    write(State), nl.
printsolution(Next_record, Closed) :-
    state_record(State, Parent, _, _,_, Next_record),
    state_record(Parent, _, _, _, _, Parent_record),
    member_set(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    write(State), nl.

/*
printsolution(Next_record, Closed) :-
    state_record(State, Parent, _, _,_, Next_record),
    state_record(Parent, Grand_parent, _, _, _, Parent_record),
    member_set(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    write(State), nl.
*/