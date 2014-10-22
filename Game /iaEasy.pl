/* iaSimple : it represents a simple IA, who sends random coordinates, between the ones that are not been already shooted. */

/* tableCoordinatesX(minX, maxX) */
tableCoordinatesX(1, 10).

/* tableCoordinatesY(minY, maxY) */
tableCoordinatesY(1, 10).

/* randomX(X) : always true, it 'returns' a random X between MinX and MaxX */
randomX(X) :- tableCoordinatesX(MinX, MaxX), random_between(MinX, MaxX, X).

/* randomY(Y) : always true, it 'returns' a random Y between MinY and MaxY */
randomY(Y) :- tableCoordinatesY(MinY, MaxY), random_between(MinY, MaxY, Y).

/* randomCoordinates(X,Y) : always true, it 'returns' a random X and Y */
randomCoordinates(X,Y) :- randomX(X), randomY(Y).

/* playIASimple(IAPlayer, X, Y) : recursive predicate, that recalls itself it the random coordinates are been already shooted. */
playEasyIA(IAPlayer, X, Y) :- availableShot(IAPlayer, X, Y).