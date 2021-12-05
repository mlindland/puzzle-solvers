# Program2
CS 427 Sliding Tiles & Werewolves solvers

## Instructions
This program consists of two solvers, one for Vampire-Werewolves and one for Sliding Tiles puzzle game. Each solver has 3 search methods implementations, BFS, DFS and a Heuristic Search. Each solver has a test1 predicate which has the demonstrated example. If you wish to run your own example start -> goal state, you must either edit the file, adding your own states to run, or call the go(start, goal) predicate with your start and goal states. Each solver has a state representation which will be explained later. In order to load a file, either call consult('filename.pl'). or [filename]. which will load the file into the database.Once the file is loaded, then you can run the desired predicates.  

## State Representation Vampire-Werewolves
The Vampire-Werewolves state representation is state(V1,V2,V3,W1,W2,W3,Boat), the first three parameters are Vampires, followed by werewolves, and lastly the position of the boat. Each argument can either be a 0 or a 1, representing the side of the river the individual is on.  

### Move Representation
The move set for this problem was similar to George Lugars example in the book, however, the farmer was going in the boat in every state, however, there cannot be just one vampire or werewolf to go in the boat for every state, so I needed a more cleaver rule system. After solving the game on paper, I traced all the moves that we necessary to solve the puzzle and implemented these moves, for example, vampire 1 and werewolf 1 ride in the boat. The rules I implemented are subjective and are not the only way to traverse states. I did not check to see if the rules were enough to cover the state space, but the rules are very strict, such that each state has a very limited number of distinct child states.  

## State Representation Sliding Tiles
The Sliding Tile puzzle game state representation is a list of 16 distinct numbers between 0 and 15. I used this because it was in the examples from the assignment and it seemed the most simple to implement. 

### Move Representation
The rules for this solver were simple, first determine the allowed moves from a given state (up, down, left, right). If a move is allowed, generate said move as the "next" state by switching the value and 0 (the blank).  


## Misc.
Each implementation, BFS, DFS, HFS are credited to George F Lugar, some minor changes were made to the sliding tile implementations, so that I can check the current state against multiple goal states, in the case that the blank tiles is anywhere in the state, but the tiles are still in the order of the goal state. This was done by expanding the goal state into a list of states, where the blank tile (0) is permuted to each available index position. This allowed me to satisfy the criteria of the sliding tile puzzle. The heuristic for each puzzle is described in heuristic.txt.
