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

heuristic(state(N1,N2,N3,N4,N5,N6, _), H) :- H is 6-N1+N2+N3+N4+N5+N6.

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