
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
shots(joueur1, 2, 1, 0).
shots(joueur1, 2, 2, 0).
shots(joueur1, 2, 3, 0).
shots(joueur1, 2, 4, 0).
shots(joueur1, 2, 5, 0).
shots(joueur1, 2, 6, 1).
shots(joueur1, 2, 7, 1).
shots(joueur1, 2, 8, 1).
shots(joueur1, 2, 9, 1).
shots(joueur1, 2, 10, 0).
shots(joueur1, 3, 1, 0).

:- dynamic hitShip/4.
hitShip(joueur1, [coord(2,6), coord(3,5)], [] ,0).


TestList = [coord(1,2),coord(3,4),coord(5,6)].

/* hitShip([coord(X,Y), ...], sunken). avec sunken 1 ou 0*/



displaySuccessfulShots(Joueur, X, Y) :- shots(Joueur, X, Y, 1), write([Joueur, X, Y]), nl, fail.

/* successfulShots(Joueur, X, Y) :- shots(Joueur, X, Y, 1), not(hitShip([coord(X, Y)| RESTELIST], 0)). */

/*
displaySameX(X) :- hitShip([coord(X,Y), coord(X,Z)], 0), write([X, Y, X, Z]), nl, fail.
displaySameY(Y) :- hitShip([coord(X,Y), coord(Z,Y)], 0), write([X, Y, Z, Y]), nl, fail.
*/



getCross(1,1, List)   :- X2 is X+1, Y2 is Y+1, List =  [coord(X2, Y), coord(X, Y2)].
getCross(1,10, List)  :- X2 is X+1, Y1 is Y-1, List =  [coord(X2, Y), coord(X, Y1)].
getCross(10,1, List)  :- X1 is X-1, Y2 is Y +1,List =  [coord(X1, Y), coord(X, Y2)].
getCross(10,10, List) :- X1 is X-1, Y1 is Y-1, List =  [coord(X1, Y), coord(X, Y1)].
getCross(1,Y, List)   :- X1 is X-1, X2 is X+1, Y2 is Y +1, List =  [coord(X1, Y), coord(X2, Y), coord(X, Y2)].
getCross(10,Y, List)  :- X1 is X-1, X2 is X+1, Y1 is Y-1,  List =  [coord(X1, Y), coord(X2, Y), coord(X, Y1)].
getCross(X,1, List)   :- X2 is X+1, Y1 is Y-1, Y2 is Y +1, List =  [coord(X2, Y), coord(X, Y1), coord(X, Y2)].
getCross(X,10, List)  :- X1 is X-1, X2 is X+1, Y1 is Y-1,  List =  [coord(X1, Y), coord(X2, Y), coord(X, Y1)].

getExtrem(Joueur, Reussi, Potential) :- [coord(X1, Y1) | [ coord(X2, Y2) | _]], X2 =:= X1, getExtremHoriz(Joueur,Reussi,Potential).
getExtrem(Joueur, Reussi, Potential) :- [coord(X1, Y1) | [ coord(X2, Y2) | _]], Y2 =:= Y1, getExtremVerti(Joueur,Reussi,Potential).

getExtremHoriz(Joueur, Reussi, Potential).

extractX([coord(X,_)], Out) :- Out = [X | Out].
extractX(In, Out) :- [coord(X,_)|Tail] = In, Out = [X | Out], extractX(Tail,Out).


/* Si liste de hitShip == 1 alors on n'a pas la direction, on met a jour la liste des coups potentitials avec les 4 cases autours du coup precedemment reussi */
potentialShot(Joueur, Potential) :- retract(hitShip(Joueur, Reussi, _, 0)), 
	length(Reussi, 1),
	[coord(X,Y) |_] = Reussi, 
	getCross(X,Y,Potential),
	assertz(hitShip(Joueur, Reussi, Potential, 0)).
	
	
potentialShot(Joueur, Potential) :- retract(hitShip(Joueur, Reussi, _, 0)), 
	length(Reussi, Length),
	Length > 1,
	[coord(X,Y) |_] = Reussi, 
	getCross(X,Y,Potential),
	assertz(hitShip(Joueur, Reussi, Potential, 0)).
	

	
