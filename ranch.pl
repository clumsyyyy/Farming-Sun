dynamic(cow/1).
dynamic(sheep/1).
dynamic(chicken/1).
dynamic(ranchingExp/1).
dynamic(ranchingLevel/1).
dynamic(day/1).

% day
initDay :- retractall(day(_)), assertz(day(1)).
nextDay :- day(X), Y is X + 1, retract(day(_)), assertz(day(Y)).

initRanch :-
    retractall(cow(_)),
    retractall(sheep(_)),
    retractall(chicken(_)),
    assertz(cow(0)),
    assertz(sheep(0)),
    assertz(chicken(0)).

buyCow :-
    cow(X),
    X1 is X+1,
    retract(cow(_)),
    assertz(cow(X1)).

buyChicken :-
    chicken(X),
    X1 is X+1,
    retract(chicken(_)),
    assertz(chicken(X1)).

buySheep :-
    sheep(X),
    X1 is X+1,
    retract(sheep(_)),
    assertz(sheep(X1)).

ranch :-
    day(A), ranchingLevel(Lvl),
    write('Day '),
    write(A),
    write('  Level: '),
    write(Lvl),
    write('\nwelcome to the ranch! You have: \n'),
    chicken(X), sheep(Y), cow(Z),
    write(X),
    write(' chicken\n'),
    write(Y),
    write(' sheep\n'),
    write(Z),
    write(' cows\n'),
    write('\nWhat do you want to do?').

% ranch level up
ranchLevelUp :-
    ranchingExp(Exp),
    Exp >= 300,
    ranchingLevel(X),
    X1 is X+1,
    retract(ranchingExp(_)),
    assertz(ranchingExp(0)),
    retract(ranchingLevel(_)),
    assertz(ranchingLevel(X1)).

