
/* Type of ship	Size  */
/* Aircraft carrier	5 */
/* Battleship	    4 */
/* Submarine	    3 */
/* Destroyer 	    3 */
/* Patrol        	2 */

:-dynamic case/5.
case(joueur1,1,2,0,battleship).
case(joueur1,1,1,0,aircraft).
case(joueur1,3,1,0,submarine).
case(joueur1,4,2,0,destroyer).
case(joueur1,6,9,0,patrol).

/*PLAYERS = [joueur1, joueur2];
nth1(1,PLAYERS,CURRENT_PLAYER);*/

:-dynamic played/4.

% We can play if he case does not exists or if the case contains a boat which is not touched
/* We add the case to the list if there is no boat */
shoot(Joueur,X,Y) :-  not(case(Joueur,X,Y,_,_)), assertz(case(Joueur,X,Y,touche,0)). 
shoot(Joueur,X,Y) :-  case(Joueur,X,Y,Z,A), dif(Z,touche),  retract(case(Joueur,X,Y,Z,A)), assertz(case(Joueur,X,Y,touche,A)).

/* Test if the Bateau of Joueur is sinked */
sinked(Joueur, Bateau) :- not(case(Joueur,_,_,0,Bateau)).

/* Test if Joueur is the looser */
winAgainst(Joueur) :- not(case(Joueur,_,_,0,Z)), dif(Z,0).


otherPlayer(Old, New) :- Old == joueur2, =(New ,joueur1).
displayGrid(Joueur) :- case(Joueur,X,Y,A,B), write([Joueur,X,Y,A,B]), nl, fail.
  


