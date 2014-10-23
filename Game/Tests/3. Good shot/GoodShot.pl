:-consult('../../Game').

addPlayers :- addPlayer(marco), addPlayer(anthony).

addShips :- assertz(ships(marco, 1, 1, 0, battleship)), assertz(ships(marco, 1, 2, 0, battleship)), assertz(ships(marco, 1, 3, 0, battleship)), 
assertz(ships(marco, 1, 4, 0, battleship)), assertz(ships(anthony, 1, 1, 0, battleship)), assertz(ships(anthony, 1, 2, 0, battleship)), 
assertz(ships(anthony, 1, 3, 0, battleship)), assertz(ships(anthony, 1, 4, 0, battleship)).

/* There is a anthony's boat on 1,1). */
test :- addPlayers, addShips, not(startGame), shot(1,1).