% Magnus Lindland
% CS 427 Program 2
% BFS; Vampire/Warewolf; SlidingTles;
% Credit for BFS Algorithm and adt.pl goes to George F. Lugar.

:- consult('adt.pl').
:- consult('move_sliding_tile.pl').

state_record(State, Parent, G, H, F, [State, Parent, G, H, F]).

    % go initializes Open and CLosed and calls path 
go(Start, Goal) :- 
    empty_set(Closed),
    empty_sort_queue(Empty_open),
    heuristic(Start, Start, Goal, H),
    state_record(Start, nil, 0, H, H, First_record),
    insert_sort_queue(First_record, Empty_open, Open),
    movezerotofront(Goal, X),
    combinations(X, Result),
    path(Open,Closed, Result).

test1 :- go([1,6,2,4,5,0,3,7,8,9,10,11,12,13,14,15], [1,2,3,4,5,6,0,7,8,9,10,11,12,13,14,15]).
% test1 :- go( [1,6,2,4,5,0,3,7,8,9,10,11,12,13,14,15], [1,2,3,4,5,6,0,7,8,9,10,11,12,13,14,15]).
test2 :- go([5,0,4,14,10,1,3,12,2,15,6,13,7,11,9,8], [5,4,3,14,10,1,0,12,2,15,6,13,7,11,9,8]).
test3 :- go([5,0,4,14,10,1,3,12,2,15,6,13,7,11,9,8], [5,4,3,14,10,1,6,12,2,15,0,13,7,11,9,8]).
test4 :- go([5,0,4,14,10,1,3,12,2,15,6,13,7,11,9,8], [5,4,3,14,10,1,6,12,2,0,15,13,7,11,9,8]).
test5 :- go([5,0,4,14,10,1,3,12,2,15,6,13,7,11,9,8], [5,4,3,14,10,1,6,12,0,2,15,13,7,11,9,8]).
test6 :- go([5,0,4,14,10,1,3,12,2,15,6,13,7,11,9,8], [5,4,3,14,0,1,6,12,10,2,15,13,7,11,9,8]).
test7 :- go([5,0,4,14,10,1,3,12,2,15,6,13,7,11,9,8], [5,4,3,14,1,0,6,12,10,2,15,13,7,11,9,8]).
testcustom :- go([5,4,2,3,1,6,7,11,12,9,10,9,13,14,15,0], [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0]).
testwww :- go([5,1,3,4,2,6,7,8,9,14,10,11,13,15,12,0], [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0]).

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
    % writelist(Goal),
    remove_sort_queue(First_record, Open, _),
    state_record(State, _, _, _, _, First_record),
    member(State, Goal),
    % State = Goal,
    write('Solution path for heuristic is: '), nl,
    printsolution(First_record, Closed).
    
    % The next record is not equal to the goal
    % Generate its children, add to open and continue
    % Note that bagof in AAIS prolog fails if its goal fails, 
    % I needed to use the or to make it return an empty list in this case
path(Open, Closed, [Goal | Rest]) :- 
    remove_sort_queue(First_record, Open, Rest_of_open),
    (bagof(Child, moves(First_record, Open, Closed, Child, Goal), Children);Children = []),
    insert_list(Children, Rest_of_open, New_open),
    add_to_set(First_record, Closed, New_closed),
    path(New_open, New_closed, [Goal | Rest]),!.
    
    % moves generates all children of a state that are not already on
    % open or closed.  The only wierd thing here is the construction
    % of a state record, test, that has unbound variables in all positions
    % except the state.  It is used to see if the next state matches
    % something already on open or closed, irrespective of that states parent
    % or other attributes
    % Also, I've commented out unsafe since the way I've coded the water jugs 
    % problem I don't really need it.
moves(State_record, Open, Closed,Child, Goal) :-
    state_record(State, _, G, _,_, State_record),
    move(State, Next),
    % not(unsafe(Next)),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristic(Next, Next, Goal, H),
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
    writelist(State), nl.
printsolution(Next_record, Closed) :-
    state_record(State, Parent, _, _,_, Next_record),
    state_record(Parent, _, _, _, _, Parent_record),
    member_set(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    writelist(State), nl.

/*
printsolution(Next_record, Closed) :-
    state_record(State, Parent, _, _,_, Next_record),
    state_record(Parent, Grand_parent, _, _, _, Parent_record),
    member_set(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    write(State), nl.
*/