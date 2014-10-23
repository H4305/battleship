:-consult('../../Game').

addPlayers :- addPlayer(marco), addPlayer(anthony).

/* On test a shoot where there's no boat'*/
addShips :- assertz(ships(marco, 1, 1, 0, battleship)), assertz(ships(marco, 1, 2, 0, battleship)), assertz(ships(marco, 1, 3, 0, battleship)), 
assertz(ships(marco, 1, 4, 0, battleship)), assertz(ships(anthony, 1, 1, 0, battleship)), assertz(ships(anthony, 1, 2, 0, battleship)), 
assertz(ships(anthony, 1, 3, 0, battleship)), assertz(ships(anthony, 1, 4, 0, battleship)).

/* There is no anthony's boat on 1,5). */
test :- addPlayers, addShips, not(startGame), shot(1,5).