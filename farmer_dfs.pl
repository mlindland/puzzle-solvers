%%%%% Basic depth first path algorithm in PROLOG %%%%%%%
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
% :- [adt].
:- consult('adt.pl').
go(Start, Goal) :- 
    empty_stack(Empty_been_stack), 
    stack(Start, Empty_been_stack, Been_stack), 
    path(Start, Goal, Been_stack). 
test :- go(state(w,w,w,w), state(e,e,e,e)). 


% path(Goal, Goal, Been_list) :-
% 	reverse_print_stack(Been_list).

% path(State, Goal, Been_list) :-
% 	move(State, Next),
% 	% not(unsafe(Next)),
% 	not(member_stack(Next, Been_list)),
% 	stack(Next, Been_list, New_been_list),
% 	path(Next, Goal, New_been_list), !.

% Current state = goal, print out been list
path(Goal, Goal, Been_stack) :- 
    write('Solution Path Is: '), nl, write('state(F,W,G,C)'), nl,
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
