/*
shots(joueur1, 1, 1, 0).
shots(joueur1, 1, 2, 0).
shots(joueur1, 1, 3, 0).
shots(joueur1, 1, 4, 0).
shots(joueur1, 1, 5, 0).
shots(joueur1, 1, 6, 0).
shots(joueur1, 1, 7, 0).
shots(joueur1, 1, 8, 0).
shots(joueur1, 1, 9, 0).
shots(joueur1, 1, 10, 0).
shots(joueur1, 2, 5, 0).
shots(joueur1, 2, 6, 1).
shots(joueur1, 2, 7, 1).
shots(joueur1, 3, 1, 0).
shots(joueur1, 2, 8, 1).
shots(joueur1, 2, 9, 0).
shots(joueur1, 2, 10, 0). */




:- dynamic hitShip/4.
:- dynamic shots/4.
shots(JOUEURTEST, 0,0,0).

displaySuccessfulShots(Joueur, X, Y) :- shots(Joueur, X, Y, 1), write([Joueur, X, Y]), nl, fail.

getCross(1,1, List)   :- X2 is X+1, Y2 is Y+1, List =  [coord(X2, Y), coord(X, Y2)].
getCross(1,10, List)  :- X2 is X+1, Y1 is Y-1, List =  [coord(X2, Y), coord(X, Y1)].
getCross(10,1, List)  :- X1 is X-1, Y2 is Y +1,List =  [coord(X1, Y), coord(X, Y2)].
getCross(10,10, List) :- X1 is X-1, Y1 is Y-1, List =  [coord(X1, Y), coord(X, Y1)].
getCross(1,Y, List)   :- X1 is X-1, X2 is X+1, Y2 is Y +1, List =  [coord(X1, Y), coord(X2, Y), coord(X, Y2)].
getCross(10,Y, List)  :- X1 is X-1, X2 is X+1, Y1 is Y-1,  List =  [coord(X1, Y), coord(X2, Y), coord(X, Y1)].
getCross(X,1, List)   :- X2 is X+1, Y1 is Y-1, Y2 is Y +1, List =  [coord(X2, Y), coord(X, Y1), coord(X, Y2)].
getCross(X,10, List)  :- X1 is X-1, X2 is X+1, Y1 is Y-1,  List =  [coord(X1, Y), coord(X2, Y), coord(X, Y1)].
getCross(X,Y, List)   :- X1 is X-1, X2 is X+1, Y1 is Y-1, Y2 is Y+1, List =  [coord(X1, Y), coord(X2, Y), coord(X, Y1), coord(X,Y2)].

/*
 * Return the 3 cases in each direction where the ship would be
 */
getLine(Reussi, Potential) :- 
	[coord(X1, Y1) | [ coord(X2, Y2) | _]] = Reussi, X2 =:= X1, 
	Y10 is max(Y1,Y2), Y11 is Y10 + 1, Y12 is Y10 + 2, Y13 is Y10 + 3,
	Y20 is min(Y1,Y2), Y21 is Y20 - 1, Y22 is Y20 - 2, Y23 is Y20 - 3,
	Potential = [coord(X1, Y11), coord(X1, Y12), coord(X1, Y13), coord(X1, Y21), coord(X1, Y22), coord(X1, Y23)].
	
getLine(Reussi, Potential) :- 
	[coord(X1, Y1) | [ coord(X2, Y2) | _]] = Reussi, Y2 =:= Y1, 
	X10 is max(X1,X2), X11 is X10 + 1, X12 is X10 + 2, X13 is X10 + 3,
	X20 is min(X1,X2), X21 is X20 - 1, X22 is X20 - 2, X23 is X20 - 3,
	Potential = [coord(X11, Y1), coord(X12, Y1), coord(X13, Y1), coord(X21, Y1), coord(X22, Y1), coord(X23, Y1)].

potentialShot(Joueur, Potential) :- 
	hitShip(Joueur, Reussi, _, 0), 
	length(Reussi, Length),
	Length > 1,
	[coord(X,Y) |_] = Reussi, 
	getLine(Reussi, Potential),
	retract(hitShip(Joueur, Reussi, _, 0)),
	assertz(hitShip(Joueur, Reussi, Potential, 0)).
	
/* Si liste de hitShip == 1 alors on n'a pas la direction, on met a jour la liste des coups potentitials avec les 4 cases autours du coup precedemment reussi */
potentialShot(Joueur, Potential) :- 
	hitShip(Joueur, Reussi, _, 0), 
	length(Reussi, 1),
	[coord(X,Y) |_] = Reussi, 
	getCross(X,Y,Potential),
	retract(hitShip(Joueur, Reussi, _, 0)),
	assertz(hitShip(Joueur, Reussi, Potential, 0)).
	
potentialShot(Joueur, Potential) :- 
	not(hitShip(Joueur, Reussi, _, 0)),
	randomlyplay(Joueur, X, Y),
	Potential = [coord(X, Y)].
	
	%retract(hitShip(Joueur, Reussi, _, 0)),
	%assertz(hitShip(Joueur, Reussi, [coord(X,Y)], 0)).

randomlyplay(Joueur, X, Y) :-
	random(1, 11, X), random(1, 11, Y),
	not(shots(Joueur, X, Y, _)) -> true; 
	randomlyplay(Joueur, X, Y).	
	
computeCoordinate(Joueur, X, Y) :- 
	potentialShot(Joueur, Potential), 
	findShot(Joueur, Potential, X, Y),
	!.

	
findShot(Joueur, [coord(A,B)|T], X, Y) :- 
	shots(Joueur, A, B, _), 
	findShot(Joueur, T, X, Y),!.

findShot(Joueur, [coord(X,Y)|T], X, Y) :- 
	not(shots(Joueur, X, Y, _)),!.


	
state(Joueur, X, Y, Sunk) :- 
	hitShip(Joueur, Success, P, 0),
	append([coord(X,Y)],Success, NewSuccess),
	retract(hitShip(Joueur, Success, P, 0)),
	assertz(hitShip(Joueur,NewSuccess, P, Sunk)).
	
state(Joueur, X, Y, Sunk) :- 
	not(hitShip(Joueur, R, P, 0)),
	assertz(hitShip(Joueur,[coord(X,Y)], P, Sunk)).
	
playIA(Joueur, X, Y) :- computeCoordinate(Joueur,X,Y).
	