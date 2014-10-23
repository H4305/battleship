:-consult('../../Game').

addStrongIAs :- not(addStrongIA), not(addStrongIA).

/* IAs play automatically until one IA win. */
test :- addStrongIAs, startGame.