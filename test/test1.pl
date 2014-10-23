

:-consult('PlayFonctions-Marco').


:-dynamic shots/4.
:-dynamic ships/4.
:- dynamic hitShip/4.

writeInFile(X) :- open('test.txt',append,S), write(S, X), write(S, '\n'), close(S).


testCentPartie(0).
testCentPartie(Count) :-
	retractall(ships(_,_,_,_)),
	retractall(shots(_,_,_,_)),
	retractall(hitShip(_,_,_,_)),
	writeInFile('lol'),
	DDD is Count-1,
	testCentPartie(DDD).