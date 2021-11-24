% Magnus Lindland
% CS 427 Program 2
% DFS; Vampire/Warewolf; SlidingTles;
% Credit for DFS Algorithm and adt.pl goes to George F. Lugar.

:- consult('adt.pl').
:- consult('move_vamp_wolf.pl').
go(Start, Goal) :- 
    empty_stack(Empty_been_stack), 
    stack(Start, Empty_been_stack, Been_stack), 
    path(Start, Goal, Been_stack). 

test1 :- go(state(0,0,0,0,0,0,0), state(1,1,1,1,1,1,1)).
test2 :- go(state(1,1,1,1,1,1,1), state(0,0,0,0,0,0,0)).


path(Goal, Goal, Been_stack) :- 
    write('Solution Path for DFS Is: '), nl, write('state(V1,V2,V3,W1,W2,W3,Boat)'), nl,
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
