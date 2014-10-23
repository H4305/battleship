/* Direction:
   0 - Horizontale
   1 - Verticale
*/
:- abolish(case/5).

:-dynamic joueur/1.
joueur(ia1).
joueur(ia2).


placeShipManual(Joueur, IdShip, Taille, X, Y , Direction):-
checkCase(Taille,Direction, X, Y, Joueur) -> assertShip(IdShip, Taille, Direction, X, Y, Joueur), true; 
write('Position occupée'), fail.

placeShipsAuto(Joueur) :- ship(IdShip, Taille), placeShipAuto(Joueur, IdShip, Taille), fail.

placeShipsAuto :- joueur(Joueur), ship(IdShip, Taille), placeShipAuto(Joueur, IdShip, Taille), fail.
placeShipsAuto :- !.

placeShipAuto(Joueur, IdShip, Taille):- repeat, randomCase(Taille, Direction, X, Y),
assertShip(IdShip, Taille, Direction, X, Y, Joueur), not(checkCase(Taille,Direction, X, Y, Joueur)),!.

randomCase(Taille, Direction, X, Y) :- random(0,2, Direction), randomCoord(Taille, Direction, X, Y).

randomCoord(Taille, 0, X, Y) :- 
MaxX is -(12,Taille), MaxY is 10,
random(1,MaxX,X), random(1,MaxY,Y).

randomCoord(Taille, 1, X, Y) :-
MaxX is 10, MaxY is -(12,Taille),
random(1,MaxX,X), random(1,MaxY,Y).

checkCase(0, Direction, X, Y, Joueur):- !.
checkCase(Taille, Direction, X, Y, Joueur):- 
not(ships(Joueur, X, Y, _, _)),
NewTaille is -(Taille,1), NewX is +(X, -(1, *(1, Direction))), NewY is +(Y, Direction),
checkCase(NewTaille, Direction, NewX, NewY, Joueur).

assertShip(IdShip, 0, Direction, X, Y, Joueur):- !.
assertShip(IdShip, Taille, Direction, X, Y, Joueur):-
NewTaille is -(Taille,1), NewX is +(X, -(1, *(1, Direction))), NewY is +(Y, Direction), 
assertz(ships(Joueur, X, Y, 0, IdShip)),
assertShip(IdShip, NewTaille, Direction, NewX, NewY, Joueur).

displayGrid(Joueur) :- ships(Joueur,X,Y,T,ID), write('PLACE:'), write([Joueur, X, Y, T, ID]), nl, fail.

displayPlayer(Joueur) :- not(displayGrid(Joueur)), write('END:').

displayGame :- joueur(Joueur), write(Joueur), nl,displayGrid(Joueur),nl.

go :- placeShipsAuto, displayGame.