:- dynamic hitShip/4.

/* FOR TEST PURPOSE ONLY */
shots(_, 0,0,0).

displaySuccessfulShots(Player, X, Y) :- shots(Player, X, Y, 1), write([Player, X, Y]), nl, fail.

getCross(1,1, [coord(1, 2), coord(2, 1)]) :- !.
getCross(1,10, [coord(1, 9), coord(2, 10)]) :- !.
getCross(10,1, [coord(9, 1), coord(10, 2)]) :-  !.
getCross(10,10, [coord(10, 9), coord(9, 10)]) :- !. 
getCross(1,Y, List)   :- X1 is 2, Y1 is Y-1, Y2 is Y+1, List = [coord(X1, Y), coord(X, Y1), coord(X, Y2)], !.
getCross(10,Y, List)  :- X1 is 9, Y2 is Y+1, Y1 is Y-1, List = [coord(X1, Y), coord(X, Y2), coord(X, Y1)], !.
getCross(X,1, List)   :- X2 is X+1, X1 is X-1, Y2 is 2, List = [coord(X2, Y), coord(X1, Y), coord(X, Y2)], !.
getCross(X,10, List)  :- X1 is X-1, X2 is X+1, Y1 is 9, List = [coord(X1, Y), coord(X2, Y), coord(X, Y1)], !.
getCross(X,Y, List)   :- X1 is X-1, X2 is X+1, Y1 is Y-1, Y2 is Y+1, List =  [coord(X1, Y), coord(X2, Y), coord(X, Y1), coord(X,Y2)],!.

/*
 * Return the 3 cases in each direction where the ship would be
 */
getLine(Reussi, Potential) :- 
	[coord(X1, Y1) | [ coord(X2, Y2) | _]] = Reussi, X2 =:= X1, 
	Y10 is max(Y1,Y2), Y11 is Y10+1, Y12 is Y10+2, Y13 is Y10+3,
	Y20 is min(Y1,Y2), Y21 is Y20-1, Y22 is Y20-2, Y23 is Y20-3,
	TempPotential = [coord(X1, Y11), coord(X1, Y12), coord(X1, Y13), coord(X1, Y21), coord(X1, Y22), coord(X1, Y23)],
	cleanPotentialLine(TempPotential, Potential).
	
getLine(Reussi, Potential) :- 
	[coord(X1, Y1) | [ coord(X2, Y2) | _]] = Reussi, Y2 =:= Y1, 
	X10 is max(X1,X2), X11 is X10+1, X12 is X10+2, X13 is X10+3,
	X20 is min(X1,X2), X21 is X20-1, X22 is X20-2, X23 is X20-3,
	TempPotential = [coord(X11, Y1), coord(X12, Y1), coord(X13, Y1), coord(X21, Y1), coord(X22, Y1), coord(X23, Y1)],
	cleanPotentialLine(TempPotential, Potential).
	
cleanPotentialLine([], CleanedLine) :- !.
cleanPotentialLine([coord(X,Y)|Tail], CleanedLine) :-
	X > 0, X < 11, Y > 0, Y < 11, 
	cleanPotentialLine(Tail,[coord(X,Y)|CleanedLine]), !.

cleanPotentialLine([coord(X,Y)|Tail], CleanedLine) :-
	cleanPotentialLine(Tail, CleanedLine), !.
	
	
	
	

potentialShot(Player, Potential) :- 
	hitShip(Player, Reussi, _, 0), 
	length(Reussi, Length),
	Length > 1,
	getLine(Reussi, Potential),
	retract(hitShip(Player, Reussi, _, 0)),
	assertz(hitShip(Player, Reussi, Potential, 0)).
	
/* Si liste de hitShip == 1 alors on n'a pas la direction, on met a jour la liste des coups potentitials avec les 4 cases autours du coup precedemment reussi */
potentialShot(Player, Potential) :- 
	hitShip(Player, Reussi, _, 0), 
	length(Reussi, 1),
	[coord(X,Y) |_] = Reussi, 
	getCross(X,Y,Potential),
	retract(hitShip(Player, Reussi, _, 0)),
	assertz(hitShip(Player, Reussi, Potential, 0)).
	
potentialShot(Player, Potential) :- 
	not(hitShip(Player, _, _, 0)),
	randomlyplay(Player, X, Y),
	Potential = [coord(X, Y)].
	
	%retract(hitShip(Player, Reussi, _, 0)),
	%assertz(hitShip(Player, Reussi, [coord(X,Y)], 0)).

randomlyplay(Player, X, Y) :-
	random(1, 11, X), random(1, 11, Y),
	not(shots(Player, X, Y, _)) -> true; 
	randomlyplay(Player, X, Y).	
	
computeCoordinate(Player, X, Y) :- 
	potentialShot(Player, Potential), 
	findShot(Player, Potential, X, Y),
	!.
	
findShot(Player, [coord(A,B)|T], X, Y) :- 
	shots(Player, A, B, _), 
	findShot(Player, T, X, Y),!.

findShot(Player, [coord(X,Y)|_], X, Y) :- 
	not(shots(Player, X, Y, _)),!.
	
state(Player, X, Y, Sunk) :- 
	hitShip(Player, Success, P, 0),
	append([coord(X,Y)],Success, NewSuccess),
	retract(hitShip(Player, Success, P, 0)),
	assertz(hitShip(Player,NewSuccess, P, Sunk)).
	
state(Player, X, Y, Sunk) :- 
	not(hitShip(Player, _, _, 0)),
	assertz(hitShip(Player,[coord(X,Y)], [], Sunk)).
	
playStrongIA(Player, X, Y) :- computeCoordinate(Player,X,Y).
	