:-consult('../../Game').

addEasyIAs :- not(addEasyIA), not(addEasyIA).

/* IAs play automatically until one IA win. */
test :- addEasyIAs, startGame.