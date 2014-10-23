:-consult('../../Game').

addPlayers :- addPlayer(marco), addPlayer(anthony).

addShips :- assertz(ships(marco, 1, 1, 0, battleship)), assertz(ships(marco, 1, 2, 0, battleship)), assertz(ships(marco, 1, 3, 0, battleship)), 
assertz(ships(marco, 1, 4, 0, battleship)), assertz(ships(anthony, 1, 1, 0, battleship)), assertz(ships(anthony, 1, 2, 0, battleship)), 
assertz(ships(anthony, 1, 3, 0, battleship)), assertz(ships(anthony, 1, 4, 0, battleship)).

/* We destroy all the boats. */
test :- addPlayers, addShips, not(startGame), not(shot(1,1)), not(shot(1,2)), not(shot(1,3)), not(shot(1,4)).