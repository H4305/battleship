:-consult('../../Game').

addPlayers :- addPlayer(marco), addPlayer(anthony).

/* We try to create 3 players. */
test :- addPlayers, addPlayer(gino).