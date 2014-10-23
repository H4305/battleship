/* Direction:
   0 - Horizontale
   1 - Verticale
*/
:- abolish(ships/5).

:-dynamic joueur/1.
joueur(vadim).
joueur(maria).

:-dynamic ships/5.

:-dynamic ship/2.
ship(aircraft, 4).
ship(battleship, 4).
ship(submarine, 3).
ship(destroyer, 3).
ship(patrol, 2).


placeShipManual(Player, IdShip, Taille, X, Y , Direction):-
checkCase(Taille,Direction, X, Y, Player) -> assertShip(IdShip, Taille, Direction, X, Y, Player), true; 
write('Position occupée'), fail.

placeShipsAuto(Player) :- ship(IdShip, Taille), placeShipAuto(Player, IdShip, Taille), fail.

placeShipsAuto :- joueur(Player), ship(IdShip, Taille), placeShipAuto(Player, IdShip, Taille), fail.
placeShipsAuto :- !.

placeShipAuto(Player, IdShip, Taille):- randomCase(Taille, Direction, X, Y), 
NewTaille is +(Taille,2), NewX is -(X, -(1, *(1, Direction))), NewY is -(Y, Direction), 
checkPosition(NewTaille, Direction, NewX, NewY, Player) ->
assertShip(IdShip, Taille, Direction, X, Y, Player); placeShipAuto(Player, IdShip, Taille).

randomCase(Taille, Direction, X, Y) :- random(0,2, Direction), randomCoord(Taille, Direction, X, Y).

randomCoord(Taille, 0, X, Y) :- 
MaxX is -(12,Taille), MaxY is 11,
random(1,MaxX,X), random(1,MaxY,Y).

randomCoord(Taille, 1, X, Y) :-
MaxX is 11, MaxY is -(12,Taille),
random(1,MaxX,X), random(1,MaxY,Y).

checkPosition(NewTaille, 0, X, Y, Player):-
Yplus is Y+1, Yless is Y-1,
checkCase(NewTaille, 0, X, Yless, Player),
checkCase(NewTaille, 0, X, Y, Player),
checkCase(NewTaille, 0, X, Yplus, Player).

checkPosition(NewTaille, 1, X, Y, Player):-
Xplus is X+1, Xless is X-1,
checkCase(NewTaille, 1, Xless, Y, Player),
checkCase(NewTaille, 1, X, Y, Player),
checkCase(NewTaille, 1, Xplus, Y, Player).

checkCase(0, _, _, _, _):- !.

checkCase(Taille, 0, X, Y, Player):-
not(ships(Player, X, Y, _, _)),
NewTaille is -(Taille,1), NewX is +(X, 1),
checkCase(NewTaille, 0, NewX, Y, Player).

checkCase(Taille, 1, X, Y, Player):-
not(ships(Player, X, Y, _, _)),
NewTaille is -(Taille,1), NewY is +(Y, 1),
checkCase(NewTaille, 1, X, NewY, Player).


assertShip(_, 0, _, _, _, _):- !.
assertShip(IdShip, Taille, 0, X, Y, Player):-
NewTaille is -(Taille,1), NewX is +(X, 1),
assertz(ships(Player, X, Y, 0, IdShip)),
assertShip(IdShip, NewTaille, 0, NewX, Y, Player).

assertShip(IdShip, Taille, 1, X, Y, Player):-
NewTaille is -(Taille,1), NewY is +(Y, 1),
assertz(ships(Player, X, Y, 0, IdShip)),
assertShip(IdShip, NewTaille, 1, X, NewY, Player).


displayGrid(Player) :- ships(Player,X,Y,T,ID), writeln([X, Y, T, '"',ID, '"']), fail.

displayPlayer(Player) :- not(displayGrid(Player)), write('end').

displayGame :- joueur(Player), write(Player), nl,displayGrid(Player), nl.

go :- placeShipsAuto, displayGame.