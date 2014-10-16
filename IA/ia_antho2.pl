
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

/* hitShip([coord(X,Y), ...], sunken). avec sunken 1 ou 0*/

hitShip([coord(2,6), coord(1,6)],0).

displaySuccessfulShots(Joueur, X, Y) :- shots(Joueur, X, Y, 1), write([Joueur, X, Y]), nl, fail.

successfulShots(Joueur, X, Y) :- shots(Joueur, X, Y, 1), not(hitShip([coord(X, Y)| RESTELIST], 0)).

displaySameX(X) :- hitShip([coord(X,Y), coord(X,Z)], 0), write([X, Y, X, Z]), nl, fail.
displaySameY(Y) :- hitShip([coord(X,Y), coord(Z,Y)], 0), write([X, Y, Z, Y]), nl, fail.