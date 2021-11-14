% Magnus Lindland
% CS 427 Program 2
% DFS; Vampire/Warewolf; SlidingTles;

:- consult('adt.pl').
go(Start, Goal) :- 
    empty_stack(Empty_been_stack), 
    stack(Start, Empty_been_stack, Been_stack), 
    path(Start, Goal, Been_stack). 
test :- go(state(0,0,0,0,0,0), state(1,1,1,1,1,1)).

% The first constant is how many vampires are on the right side of river, 
% the second is how many warewolves are on the right size of the river.
% i.e. unsafe_state(1,0) means there is 1 vampire on the right side, and 0 warewolves,
% thus there are 2 vampires, and 3 warewolves on the leftside creating an unstable state.
unsafe_state(1,0).
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


path(Goal, Goal, Been_stack) :- 
    write('Solution Path Is: '), nl, write('state(V1,V2,V3,W1,W2,W3)'), nl,
    reverse_print_stack(Been_stack).  
    
% path implements a depth first search in PROLOG
path(State, Goal, Been_stack) :- 
    move(State, Next_state), 
    not(member_stack(Next_state, Been_stack)), 
    stack(Next_state, Been_stack, New_been_stack), 
    path(Next_state, Goal, New_been_stack), !.

reverse_print_stack(S) :-
	empty_stack(S).
reverse_print_stack(S) :-
	stack(E, Rest, S),
	reverse_print_stack(Rest),
	write(E), nl.

move(state(X, X, V3, W1, W2, W3), state(Y, Y, V3, W1, W2, W3)) :-
    opp(X,Y), not(unsafe(state(Y, Y, V3, W1, W2, W3))),
    writelist(['try V1 - W3 ',Y, Y, V3, W1, W2, Y]).
move(state(V1, X, V3, W1, W2, X), state(V1, Y, V3, W1, W2, Y)) :-
    opp(X,Y), not(unsafe(state(V1, Y, V3, W1, W2, Y))),
    writelist(['try V2 - W3 ',V1, Y, V3, W1, W2, Y]).
move(state(V1, V2, X, W1, W2, X), state(V1, V2, Y, W1, W2, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, Y, W1, W2, Y))),
    writelist(['try V3 - W3 ',V1, V2, Y, W1, W2, Y]).
move(state(V1, V2, V3, X, W2, X), state(V1, V2, V3, Y, W2, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, V3, Y, W2, Y))),
    writelist(['try W1 - W3 ',V1, V2, V3, Y, W2, Y]).
move(state(V1, V2, V3, W1, X, X), state(V1, V2, V3, W1, Y, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, V3, W1, Y, Y))),
    writelist(['try W2 - W3 ',V1, V2, V3, W1, Y, Y]).
move(state(V1, V2, V3, W1, W2, X), state(V1, V2, V3, W1, W2, Y)) :-
    opp(X,Y), not(unsafe(state(V1, V2, V3, W1, W2, Y))),
    writelist(['try W3 rides alone ',V1, V2, V3, W1, W2, Y]).
move(state(V1, V2, V3, W1, W2, W3), state(V1, V2, V3, W1, W2, W3)) :-
    fail.


% test :- unsafe(state(1,1,1,1,1,1)).
