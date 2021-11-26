# Program2
CS 427 Sliding Tiles & Werewolves solvers

This program consists of two solvers, one for Vampire-Werewolves and one for Sliding Tiles puzzle game.  
Each solver has 3 search methods implementations, BFS, DFS and a Heuristic Search.  
Each solver has a test1 predicate which has the demonstrated example. If you wish to run your  
own example start -> goal state, you must either edit the file, adding your own states to run,  
or call the go(start, goal) predicate with your start and goal states. Each solver has a state  
representation which will be explained later.  
In order to load a file, either call consult('filename.pl'). or [filename]. which will load the file  
into the database. Once the file is loaded, then you can run the desired predicates.  
The Vampire-Werewolves state representation is state(V1,V2,V3,W1,W2,W3,Boat), the first three parameters are Vampires,  
followed by werewolves, and lastly the position of the boat. Each argument can either be a 0 or a 1,  
representing the side of the river the individual is on.  
The Sliding Tile puzzle game state representation is a list of 16 distinct numbers between 0 and 15. Where the solver attempts to traverse states from start to the goal state.
