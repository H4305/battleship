:-dynamic shots/4.

/* Load IA */
:-consult('iaEasy').
:-consult('iaStrong').

/* Load automatic ships disposition */
:-consult('poseBateauxAvecBords.pl').

:-dynamic firstPlayer/1.  /* FirstPlayer */

:-dynamic secondPlayer/1. /* SecondPlayer */

:-dynamic currentPlayer/1. /* CurrentPlayer */
currentPlayer(noPlayer).

/* addPlayer(PlayerName) : */
addPlayer(PlayerName) :- ( firstPlayer(FirstPlayerName) -> ( secondPlayer(SecondPlayerName) -> 
	(write('Your players has been already created, player1 is : '), write(FirstPlayerName), write(' , and player2 is : '), write(SecondPlayerName)); 
	assertz(secondPlayer(PlayerName))  ) ; assertz(firstPlayer(PlayerName)), affectCurrentPlayer(PlayerName) ).

/* addIA(Level) */
addEasyIA :- ( firstPlayer(FirstPlayerName) -> ( secondPlayer(SecondPlayerName) -> (write('Your players has been already created, player1 is : '), 
	write(FirstPlayerName), write(' , and player2 is : '), write(SecondPlayerName)) ; assertz(secondPlayer(easyIA2)), placeShipsAuto(easyIA2)) ; assertz(firstPlayer(easyIA1)), 
affectCurrentPlayer(easyIA1), placeShipsAuto(easyIA1) ).
addStrongIA :- ( firstPlayer(FirstPlayerName) -> ( secondPlayer(SecondPlayerName) -> (write('Your players has been already created, player1 is : '), 
	write(FirstPlayerName), write(' , and player2 is : '), write(SecondPlayerName)) ; assertz(secondPlayer(strongIA2)), placeShipsAuto(strongIA2)) ; assertz(firstPlayer(strongIA1)), 
affectCurrentPlayer(strongIA1), placeShipsAuto(strongIA1) ).

/* affectCurrentPlayer(PlayerName) : */
affectCurrentPlayer(PlayerName) :- retract(currentPlayer(_)) , assertz(currentPlayer(PlayerName)).

/* startGame : */
startGame :- currentPlayer(easyIA1), playIAEasy(easyIA1).
startGame :- currentPlayer(strongIA1), playIAStrong(strongIA2).

/* Type of ship	Size  */
/* Aircraft carrier	5 */
/* Battleship	    4 */
/* Submarine	    3 */
/* Destroyer 	    3 */
/* Patrol        	2 */

/*ship(ShipName, Size). */

:-dynamic ship/2.
ship(aircraft, 5).
ship(battleship, 4).
ship(submarine, 3).
ship(destroyer, 3).
ship(patrol, 2).

/* ships(Player, X, Y, State, ShipName) - Player s ships disposition */
/* shots(Player, X, Y, Result) - Player s shots */ 

:-dynamic ships/5.
/*ships(marco,1,1,0,battleship).
ships(marco,1,2,0,battleship).
ships(marco,1,3,0,battleship).
ships(marco,1,1,0,aircraft).
ships(marco,3,1,0,submarine).
ships(marco,4,2,0,destroyer).
ships(marco,6,9,0,patrol).
ships(marco,6,10,0,patrol).
*/

/*
ships(strongIA1,1,1,0,battleship).
ships(strongIA1,1,2,0,battleship).
ships(strongIA1,1,3,0,battleship).
ships(strongIA1,3,1,0,aircraft).
ships(strongIA1,3,2,0,aircraft).
ships(strongIA1,3,3,0,aircraft).
ships(strongIA1,5,1,0,submarine).
ships(strongIA1,5,2,0,submarine).
ships(strongIA1,5,3,0,submarine).
ships(strongIA1,7,1,0,destroyer).
ships(strongIA1,7,2,0,destroyer).
ships(strongIA1,7,3,0,destroyer).
ships(strongIA1,9,1,0,patrol).
ships(strongIA1,9,2,0,patrol).

ships(strongIA2,1,1,0,battleship).
ships(strongIA2,1,2,0,battleship).
ships(strongIA2,1,3,0,battleship).
ships(strongIA2,3,1,0,aircraft).
ships(strongIA2,3,2,0,aircraft).
ships(strongIA2,3,3,0,aircraft).
ships(strongIA2,5,1,0,submarine).
ships(strongIA2,5,2,0,submarine).
ships(strongIA2,5,3,0,submarine).
ships(strongIA2,7,1,0,destroyer).
ships(strongIA2,7,2,0,destroyer).
ships(strongIA2,7,3,0,destroyer).
ships(strongIA2,9,1,0,patrol).
ships(strongIA2,9,2,0,patrol).

ships(easyIA1,1,1,0,battleship).
ships(easyIA1,1,2,0,battleship).
ships(easyIA1,1,3,0,battleship).
ships(easyIA1,3,1,0,aircraft).
ships(easyIA1,3,2,0,aircraft).
ships(easyIA1,3,3,0,aircraft).
ships(easyIA1,5,1,0,submarine).
ships(easyIA1,5,2,0,submarine).
ships(easyIA1,5,3,0,submarine).
ships(easyIA1,7,1,0,destroyer).
ships(easyIA1,7,2,0,destroyer).
ships(easyIA1,7,3,0,destroyer).
ships(easyIA1,9,1,0,patrol).
ships(easyIA1,9,2,0,patrol).

ships(easyIA2,1,1,0,battleship).
ships(easyIA2,1,2,0,battleship).
ships(easyIA2,1,3,0,battleship).
ships(easyIA2,3,1,0,aircraft).
ships(easyIA2,3,2,0,aircraft).
ships(easyIA2,3,3,0,aircraft).
ships(easyIA2,5,1,0,submarine).
ships(easyIA2,5,2,0,submarine).
ships(easyIA2,5,3,0,submarine).
ships(easyIA2,7,1,0,destroyer).
ships(easyIA2,7,2,0,destroyer).
ships(easyIA2,7,3,0,destroyer).
ships(easyIA2,9,1,0,patrol).
ships(easyIA2,9,2,0,patrol).
*/


shots(marco, 1,3, touched). /* FOR TEST PURPOSE ONLY */

/* findOpponentPlayer(OpponentPlayer) : */
findOpponentPlayer(OpponentPlayer) :- currentPlayer(PlayerName), firstPlayer(FirstPlayerName), secondPlayer(SecondPlayerName), 
( PlayerName == FirstPlayerName -> OpponentPlayer=SecondPlayerName ; OpponentPlayer=FirstPlayerName).

/* addPositiveShot(PlayerName, OpponentPlayer, X, Y, ShipName) : */
addPositiveShot(PlayerName, OpponentPlayer, X, Y, ShipName) :- assertz(shots(PlayerName, X, Y, touched)), retract(ships(OpponentPlayer,X,Y,_,_)), 
assertz(ships(OpponentPlayer,X,Y, touched, ShipName)).

/* displayPositiveShotMessage(X, Y) : */
displayPositiveShotMessage(X, Y) :- write('Cooool!:D You hit a boat at coordinates : '), write([X,Y]), nl.

/* displayVictoryMessage(PlayerName) : */
displayVictoryMessage(PlayerName) :- write('End of the battle!'), write(PlayerName), write(' won!!!'), nl.

/* displaySunkenBoatMessage(PlayerName, ShipName) : */
displaySunkenBoatMessage(PlayerName, ShipName) :- write('OHHHOHHHH!'), write(PlayerName), write(' lost his '), write(ShipName), write('.'), nl.

/* Player can play if he didn't shot already the case(X,Y) */
/* shot(X,Y) : */
shot(X,Y) :- nl, currentPlayer(PlayerName), findOpponentPlayer(OpponentPlayer), write(PlayerName), write(' is attacking '), write(OpponentPlayer), write(', and...'), nl,
( not(shots(PlayerName, X, Y, _)) -> ( ships(OpponentPlayer, X, Y, _, ShipName) -> addPositiveShot(PlayerName, OpponentPlayer, X, Y, ShipName), 
displayPositiveShotMessage(X, Y), 
( sunken(OpponentPlayer, ShipName) -> displaySunkenBoatMessage(OpponentPlayer, ShipName), state(PlayerName, X, Y, 1), write('SHOT:'), write(PlayerName), write('.S.'), not(displayShipPosition(OpponentPlayer, ShipName)), nl, (testVictoryAgainst(OpponentPlayer) -> 
	displayVictoryMessage(PlayerName), write('WON.'), write(PlayerName) ; nextPlay(PlayerName) ) ; state(PlayerName, X, Y, 0) , write('SHOT:'), write(PlayerName), write('.'), write([X,Y]), write('.T'), nl, nextPlay(PlayerName) ) ; assertz(shots(PlayerName, X, Y, water)), 
write('Sorry! :( No boat  at coordinates '), write([X,Y]), nl, write('SHOT:'), write(PlayerName), write('.'), write([X,Y]), write('.W'), nl, affectCurrentPlayer(OpponentPlayer) , nextPlay(OpponentPlayer) ); 
write('Already Bombed! Try other coordinates!'), nl , nextPlay(PlayerName) ).

/* nextPlay(IAPlayer) : Tests if the next player is an IA and calls playIA(IAPlayer) */ 
nextPlay(easyIA1) :- playIAEasy(easyIA1),!.
nextPlay(easyIA2) :- playIAEasy(easyIA2),!.
nextPlay(strongIA1) :- playIAStrong(strongIA1),!.
nextPlay(strongIA2) :- playIAStrong(strongIA2),!.

/* playIAEasy(IAPlayer) : It allows the easy IA to shot once. */
playIAEasy(IAPlayer) :- playEasyIA(IAPlayer, X,Y), shot(X,Y).

/* playIAStrong(IAPlayer) */
playIAStrong(IAPlayer) :- playStrongIA(IAPlayer, X, Y), shot(X,Y).

/* displayGrid :  it displays player's ships */
displayGrid :- currentPlayer(PlayerName), ships(PlayerName,X,Y,A,B), write([PlayerName,X,Y,A,B]), nl, fail.

/* displayShipPosition */
displayShipPosition(PlayerName, ShipName) :- ships(PlayerName, X, Y, _, ShipName), write([X,Y]), write('.'), fail.

/* testVictoryAgainst(Player) : it tests if Player loose (if it exists a piece of ship that has not been hitten */
testVictoryAgainst(Player) :- not(ships(Player,_,_,0,_)).

/* sunken(Player, Ship) : tests if the Player's Ship is sunken */
sunken(Player, Ship) :- not(ships(Player,_,_,0,Ship)).

/* availableShot(Player, X, Y) : recursive predicate, that recalls itself if the random coordinates are been already shooted, 'returning' an avaiable X and Y for Player */
availableShot(Player, X, Y) :- randomCoordinates(X,Y), not(shots(Player, X, Y, _)) -> true; availableShot(Player, X, Y).

/* displayAvailableShot(Player) : it displays an avaiable X and Y for Player */
displayAvailableShot(Player) :- availableShot(Player, X, Y), write([Player, X, Y]), nl, fail.

/* displayMyShots(Player) :- it displays player's shots */
displayMyShots(Player) :- currentPlayer(Player), shots(Player, X, Y, Result), write([Player, X, Y, Result]), nl, fail.

