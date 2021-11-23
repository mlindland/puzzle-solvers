% Magnus Lindland
% CS 427 Program 2
% DFS; SlidingTles;
% Credit for DFS Algorithm and adt.pl goes to George F. Lugar.

:- consult('adt.pl').
:- consult('move_sliding_tile.pl').
% :- use_module(library(lists)).

% state([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]]).
% state([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]).
go(Start, Goal) :- 
    empty_stack(Empty_been_stack), 
    stack(Start, Empty_been_stack, Been_stack),
    movezerotofront(Goal, X),
    combinations(X, Result),
    path(Start, Result, Been_stack). 

test1 :- go([5,0,4,14,10,1,3,12,2,15,6,13,7,11,9,8], [5,4,3,14,10,1,0,12,2,15,6,13,7,11,9,8]).
test2 :- go([1,2,3,0,4,5,6,7,8,9,10,11,12,13,14,15], [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]).


path(State, Goal, Been_stack) :-
    member(State, Goal), 
    write('Solution Path for DFS Is: '), nl, 
    %format('[N0 N1 N2 N3]~nN4 N5 N6 N7]~nN8 N9 N10 N11]~nN12 N13 N14 N15])'), nl,
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
	writelist(E), nl.
