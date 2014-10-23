:-consult('../../Game').

/* Display automatic ships disposition. */
test :- addPlayer(marco), not(placeShipsAuto(marco)), displayPlayer(marco).