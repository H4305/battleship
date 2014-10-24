

:-consult('PlayFonctions-Marco').


writeInFile(X) :- open('test.txt',append,S), write(S, X), write(S, '\n'), close(S).

	/*addEasyIA.
	addEasyIA.
	currentPlayer(easyIA1).*/


testCentPartie(0).
testCentPartie(Count) :-
	retractall(ships(_,_,_,_)),
	retractall(shots(_,_,_,_)),
	retractall(hitShip(_,_,_,_)),
	retractall(firstPlayer(_)),
	retractall(secondPlayer(_)),
	writeInFile('lol'),
	not(addEasyIA),
	not(addEasyIA),
	startGame,
	!,
	NewCount is Count-1,
	testCentPartie(NewCount).


testCentPartie(Count) :-
	retractall(ships(_,_,_,_)),
	retractall(shots(_,_,_,_)),
	retractall(hitShip(_,_,_,_)),
	retractall(firstPlayer(_)),
	retractall(secondPlayer(_)),
	writeInFile('lolaaaa'),
	not(addEasyIA),
	not(addEasyIA),
	not(startGame),
	!,
	NewCount is Count-1,
	testCentPartie(NewCount).