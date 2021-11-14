

%%%%%%% Breadth first search algorithm%%%%%%%%
%%%
%%% This is one of the example programs from the textbook:
%%%
%%% Artificial Intelligence: 
%%% Structures and strategies for complex problem solving
%%%
%%% by George F. Luger and William A. Stubblefield
%%% 
%%% Corrections by Christopher E. Davis (chris2d@cs.unm.edu)
%%%
%%% These programs are copyrighted by Benjamin/Cummings Publishers.
%%%
%%% We offer them for use, free of charge, for educational purposes only.
%%%
%%% Disclaimer: These programs are provided with no warranty whatsoever as to
%%% their correctness, reliability, or any other property.  We have written 
%%% them for specific educational purposes, and have made no effort
%%% to produce commercial quality computer programs.  Please do not expect 
%%% more of them then we have intended.
%%%
%%% This code has been tested with SWI-Prolog (Multi-threaded, Version 5.2.13)
%%% and appears to function as intended.
:- consult('adt.pl').
    
state_record(State, Parent, [State, Parent]).

go(Start, Goal) :- 
    empty_queue(Empty_open),
    state_record(Start, nil, State),
    add_to_queue(State, Empty_open, Open),
    empty_set(Closed),
    path(Open, Closed, Goal).
test :- go(state(e,e,e,e), state(w,w,w,w)).

path(Open,_,_) :- empty_queue(Open),
                  write('graph searched, no solution found').
    
path(Open, Closed, Goal) :- 
    remove_from_queue(Next_record, Open, _),
    state_record(State, _, Next_record),
    State = Goal,
    write('Solution path is: '), nl,
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

opp(e,w).
opp(w,e).

writelist([]).
writelist([X|Xs]) :- write(X), writelist(Xs), nl.

unsafe(state(X, Y, Y, _)) :- opp(X, Y). 
unsafe(state(X, _, Y, Y)) :- opp(X, Y).

move(state(X, X, G, C), state(Y, Y, G, C)) :- 
    opp(X, Y), not(unsafe(state(Y, Y, G, C))), 
    writelist(['try farmer - wolf', Y, Y, G, C]). 
move(state(X, W, X, C), state(Y, W, Y, C)) :- 
    opp(X, Y), not(unsafe(state(Y, W, Y, C))), 
    writelist(['try farmer - goat', Y, W, Y, C]). 
move(state(X, W, G, X), state(Y, W, G, Y)) :- 
    opp(X, Y), not(unsafe(state(Y, W, G, Y))), 
    writelist(['try farmer - cabbage', Y, W, G, Y]). 
move(state(X, W, G, C), state(Y, W, G, C)) :- 
    opp(X, Y), not(unsafe(state(Y, W, G, C))), 
    writelist(['try farmer by self', Y, W, G, C]).  
move(state(F, W, G, C), state(F, W, G, C)) :- 
    writelist([ 'BACKTRACK at:', F, W, G, C]), fail. 