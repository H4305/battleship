:-consult('../../Game').

addPlayers :- addPlayer(marco), addPlayer(anthony).

/* On test a shoot into a position that are already been shot */
addShot :- assertz(shots(marco, 1, 5, touched)).

test :- addPlayers, addShot, not(startGame), shot(1,5).