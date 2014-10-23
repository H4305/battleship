/* Direction:
   0 - Horizontale
   1 - Verticale
*/
:- abolish(case/5).

:-dynamic joueur/1.
joueur(vadim).
joueur(maria).

:-dynamic case/5.

:-dynamic ship/2.
ship(aircraft, 5).
ship(battleship, 4).
ship(submarine, 3).
ship(destroyer, 3).
ship(patrol, 2).


placeShipManual(Joueur, IdShip, Taille, X, Y , Direction):-
checkCase(Taille,Direction, X, Y, Joueur) -> assertShip(IdShip, Taille, Direction, X, Y, Joueur), true; 
write('Position occupée'), fail.

placeShipsAuto(Joueur) :- ship(IdShip, Taille), placeShipAuto(Joueur, IdShip, Taille), fail.

placeShipsAuto :- joueur(Joueur), ship(IdShip, Taille), placeShipAuto(Joueur, IdShip, Taille), fail.
placeShipsAuto :- !.

placeShipAuto(Joueur, IdShip, Taille):- randomCase(Taille, Direction, X, Y), 
NewTaille is +(Taille,2), NewX is -(X, -(1, *(1, Direction))), NewY is -(Y, Direction), 
checkPosition(NewTaille, Direction, NewX, NewY, Joueur) ->
assertShip(IdShip, Taille, Direction, X, Y, Joueur); placeShipAuto(Joueur, IdShip, Taille).

randomCase(Taille, Direction, X, Y) :- random(0,2, Direction), randomCoord(Taille, Direction, X, Y).

randomCoord(Taille, 0, X, Y) :-
MaxX is -(11,Taille), MaxY is 10,
random(2,MaxX,X), random(2,MaxY,Y).

randomCoord(Taille, 1, X, Y) :-
MaxX is 10, MaxY is -(11,Taille),
random(2,MaxX,X), random(2,MaxY,Y).

checkPosition(NewTaille, 0, X, Y, Joueur):-
Yplus is Y+1, Yless is Y-1,
checkCase(NewTaille, 0, X, Yless, Joueur),
checkCase(NewTaille, 0, X, Y, Joueur),
checkCase(NewTaille, 0, X, Yplus, Joueur).

checkPosition(NewTaille, 1, X, Y, Joueur):-
Xplus is X+1, Xless is X-1,
checkCase(NewTaille, 1, Xless, Y, Joueur),
checkCase(NewTaille, 1, X, Y, Joueur),
checkCase(NewTaille, 1, Xplus, Y, Joueur).

checkCase(0, _, _, _, _):- !.

checkCase(Taille, 0, X, Y, Joueur):-
not(case(Joueur, X, Y, _, _)),
NewTaille is -(Taille,1), NewX is +(X, 1),
checkCase(NewTaille, 0, NewX, Y, Joueur).

checkCase(Taille, 1, X, Y, Joueur):-
not(case(Joueur, X, Y, _, _)),
NewTaille is -(Taille,1), NewY is +(Y, 1),
checkCase(NewTaille, 1, X, NewY, Joueur).


assertShip(_, 0, _, _, _, _):- !.
assertShip(IdShip, Taille, 0, X, Y, Joueur):-
NewTaille is -(Taille,1), NewX is +(X, 1),
assertz(case(Joueur, X, Y, 0, IdShip)),
assertShip(IdShip, NewTaille, 0, NewX, Y, Joueur).

assertShip(IdShip, Taille, 1, X, Y, Joueur):-
NewTaille is -(Taille,1), NewY is +(Y, 1),
assertz(case(Joueur, X, Y, 0, IdShip)),
assertShip(IdShip, NewTaille, 1, X, NewY, Joueur).


displayGrid(Joueur) :- case(Joueur,X,Y,T,ID), writeln([X, Y, T, '"',ID, '"']), fail.

displayPlayer(Joueur) :- not(displayGrid(Joueur)), write('end').

displayGame :- joueur(Joueur), write(Joueur), nl,displayGrid(Joueur), nl.

go :- placeShipsAuto, displayGame.