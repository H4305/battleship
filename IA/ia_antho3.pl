:- dynamic shots/4.
shots(JOUEURTEST, 0,0,0).

%  X _ _ X _ _ X _ _ X
%  _ X _ _ X _ _ X _ _
%  _ _ X _ _ X _ _ X _
%  X _ _ X _ _ X _ _ X
%  _ X _ _ X _ _ X _ _
%  _ _ X _ _ X _ _ X _
%  X _ _ X _ _ X _ _ X
%  _ X _ _ X _ _ X _ _
%  _ _ X _ _ X _ _ X _

/*34 Length of the list */
gridlines(joueur1, 34, [coord(1, 1), coord(4, 1), coord(7, 1), coord(10, 1), coord(2, 2), coord(5, 2), coord(8, 2), coord(3, 3), coord(6, 3), coord(9, 3), coord(1, 4), coord(4, 4), coord(7, 4), coord(10, 4), coord(2, 5), coord(5, 5), coord(8, 5), coord(3, 6), coord(6, 6), coord(9, 6), coord(1, 7), coord(4, 7), coord(7, 7), coord(10, 7), coord(2, 8), coord(5, 8), coord(8, 8), coord(3, 9), coord(6, 9), coord(9, 9), coord(1, 10), coord(4, 10), coord(7, 10), coord(10, 10)]).

playGrid(Joueur, X, Y) :- 
	random(1, 35, Random),
	gridlines(Joueur, _, ListOfPossibleShot),
	nth1(Random, ListOfPossibleShot, coord(X, Y)),
	/*Better idea : Remove the element of the list */
	not(shots(Joueur, X, Y, _)) -> true; playGrid(Joueur, X, Y).


/*
Regle : 
	- Conserver la taille du plus gros bateau restant
	- Et on tire en quadrillant grâce à cette taille
	- Des que l'on touche un bateau on part sur ia_antho2
	- Le but est de ne pas tirer au hasard et de correctement quadriller la zone
*/	