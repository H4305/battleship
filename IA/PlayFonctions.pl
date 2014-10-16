/* Load IA */
:-consult('ia_antho').

:-dynamic firstPlayer/1.  /* FirstPlayer */

:-dynamic secondPlayer/1. /* SecondPlayer */

:-dynamic currentPlayer/1. /* CurrentPlayer */
currentPlayer(noPlayer).

:-dynamic addPlayer/1. /* OK */
addPlayer(PlayerName) :- ( firstPlayer(FirstPlayerName) -> ( secondPlayer(SecondPlayerName) -> (write('Your players has been already created, player1 is : '), write(FirstPlayerName), write(' , and player2 is : '), write(SecondPlayerName)); assertz(secondPlayer(PlayerName))  ) ; assertz(firstPlayer(PlayerName)), affectCurrentPlayer(PlayerName) ).

:-dynamic affectCurrentPlayer/1. /* OK */
affectCurrentPlayer(PlayerName) :- retract(currentPlayer(_)) , assertz(currentPlayer(PlayerName)).

:-dynamic startGame/0. 
startGame :- ( firstPlayer(_) -> ( not(secondPlayer(_)) -> assertz(secondPlayer(ia2)) ); assertz(firstPlayer(ia1)), assertz(secondPlayer(ia2)), affectCurrentPlayer(ia1) ).

/* Type of ship	Size  */
/* Aircraft carrier	5 */
/* Battleship	    4 */
/* Submarine	    3 */
/* Destroyer 	    3 */
/* Patrol        	2 */

/*ship(ShipName, Size). */

ship(aircraft, 5).
ship(battleship, 4).
ship(submarine, 3).
ship(destroyer, 3).
ship(patrol, 2).

/* ships(Player, X, Y, State, ShipName) - Player s ships disposition */
/* shoots(Player, X, Y, Result) - Player s shoots */ 

:-dynamic ships/5.
ships(marco,1,1,0,battleship).
ships(marco,1,2,0,battleship).
/*ships(marco,1,3,0,battleship).
ships(marco,1,1,0,aircraft).
ships(marco,3,1,0,submarine).
ships(marco,4,2,0,destroyer).
ships(marco,6,9,0,patrol).
ships(marco,6,10,0,patrol).*/

ships(ia2,1,2,0,battleship).
ships(ia2,1,1,0,aircraft).
ships(ia2,3,1,0,submarine).
ships(ia2,4,2,0,destroyer).
ships(ia2,6,9,0,patrol).

:-dynamic shoots/4.
shoots(marco, 1,3, touched). /* FOR TEST PURPOSE ONLY */

:-dynamic findOpponentPlayer/1. /* OK */
findOpponentPlayer(OpponentPlayer) :- currentPlayer(PlayerName), firstPlayer(FirstPlayerName), secondPlayer(SecondPlayerName), ( PlayerName == FirstPlayerName -> OpponentPlayer=SecondPlayerName ; OpponentPlayer=FirstPlayerName).

:-dynamic addPositiveShoot/5. /* OK */
addPositiveShoot(PlayerName, OpponentPlayer, X, Y, ShipName) :- assertz(shoots(PlayerName, X, Y, touched)), retract(ships(OpponentPlayer,X,Y,_,_)), assertz(ships(OpponentPlayer,X,Y, touched, ShipName)).

:-dynamic displayPositiveShootMessage/3. /* OK */
displayPositiveShootMessage(X, Y) :- write('Cooool!:D You hit a boat at coordinates : '), write([X,Y]), nl.

:-dynamic displayVictoryMessage/1.
displayVictoryMessage(PlayerName) :- write('End of the battle!'), write(PlayerName), write(' won!!!'), nl.

:-dynamic displaySunkenBoatMessage/2.
displaySunkenBoatMessage(PlayerName, ShipName) :- write('OHHHOHHHH!'), write(PlayerName), write(' lost his '), write(ShipName), write('.'), nl.

/* Player can play if he didn't shoot already the case(X,Y) */
:-dynamic shoot/3. % OK
shoot(X,Y) :- currentPlayer(PlayerName), findOpponentPlayer(OpponentPlayer), ( not(shoots(PlayerName, X, Y, _)) -> ( ships(OpponentPlayer, X, Y, _, ShipName) -> addPositiveShoot(PlayerName, OpponentPlayer, X, Y, ShipName), displayPositiveShootMessage(X, Y), ( sunken(OpponentPlayer, ShipName) -> displaySunkenBoatMessage(OpponentPlayer, ShipName)),(testVictoryAgainst(OpponentPlayer) -> displayVictoryMessage(PlayerName) ) ; assertz(shoots(PlayerName, X, Y, water)), write('Sorry! :( No boat  at coordinates '), write([X,Y]), nl, affectCurrentPlayer(OpponentPlayer) ) ; write('Already Bombed! Try other coordinates!'), nl).

/* Test if the next player is an IA A RAJOUTER*/ 
nextPlay(ia1) :- playIA(ia1),!.
nextPlay(ia2) :- playIA(ia2),!.

/* It allows the IA to play automatically. */
playIA(PlayerName) :- randomlyplay(PlayerName, X,Y), shoot(X,Y).

/* Display player's ships */
displayGrid :- currentPlayer(PlayerName), ships(PlayerName,X,Y,A,B), write([PlayerName,X,Y,A,B]), nl, fail.

/* Test if Player loose*/
testVictoryAgainst(Player) :- not(ships(Player,_,_,0,_)).

/* Test if the player's ship is sunken */
sunken(Player, Ship) :- not(ships(Player,_,_,0,Ship)).


  


