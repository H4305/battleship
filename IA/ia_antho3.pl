:- dynamic shots/4.
shots(JOUEURTEST, 0,0,0).
shots(1, 1,1,0).
shots(1, 4,1,0).
shots(1, 7,1,0).
shots(1, 8,2,0).
shots(1, 5,2,0).
shots(1, 2,2,0).
shots(1, 10,1,0).

%  X _ _ X _ _ X _ _ X
%  _ X _ _ X _ _ X _ _
%  _ _ X _ _ X _ _ X _
%  X _ _ X _ _ X _ _ X
%  _ X _ _ X _ _ X _ _
%  _ _ X _ _ X _ _ X _
%  X _ _ X _ _ X _ _ X
%  _ X _ _ X _ _ X _ _
%  _ _ X _ _ X _ _ X _

/*34 Length of the list */
:- dynamic gridLines/2.
gridLines(first, 
	[coord(1, 1), coord(4, 1), coord(7, 1), coord(10, 1),
     coord(2, 2), coord(5, 2), coord(8, 2), coord(3, 3), coord(3, 7)]).
	 /*,
	 coord(6, 3), coord(9, 3), coord(1, 4), coord(4, 4),
	 coord(7, 4), coord(10, 4), coord(2, 5), coord(5, 5),
	 coord(8, 5), coord(3, 6), coord(6, 6), coord(9, 6),
	 coord(1, 7), coord(4, 7), coord(7, 7), coord(10, 7),
	 coord(2, 8), coord(5, 8), coord(8, 8), coord(3, 9),
	 coord(6, 9), coord(9, 9), coord(1, 10), coord(4, 10),
	 coord(7, 10), coord(10, 10)]).*/

	 
playGrid(Joueur, X, Y) :- not(gridLines(Joueur, _)), gridLines(first, InitList), assertz(gridLines(Joueur, InitList)).


playGrid(Joueur, XX, YY) :- getCoordinate(Joueur, X, Y), shots(Joueur, X, Y, _), write('Already Shot, get Another'), playGrid(Joueur, A, B).
playGrid(Joueur, X, Y) :- getCoordinate(Joueur, X, Y), not(shots(Joueur, X, Y, _)), !.

getCoordinate(Joueur, X, Y) :-  
	gridLines(Joueur, ListOfPossibleShot),
	length(ListOfPossibleShot, Length),
	Length > 0,
	random(1, Length, Random),
	nth1(Random, ListOfPossibleShot, coord(X, Y)),
	delete(ListOfPossibleShot, coord(X,Y), NewList),
	retract(gridLines(Joueur,_)),
	assertz(gridLines(Joueur,NewList)).
	




/*If the list is empty, call IA1 for a random number .. ? because there are still available cases */