:- dynamic(livestock/2).
:- dynamic(ranchingExperience/2).
:- dynamic(lastRacnh/2).
:- dynamic(day/1).

% day
initDay :- retractall(day(_)), assertz(day(1)).
nextDay :- day(X), Y is X + 1, retract(day(_)), assertz(day(Y)).

initRanch :-
    retractall(livestock(cow, _)),
    retractall(livestock(sheep, _)),
    retractall(livestock(chicken, _)),
    retractall(ranchingExperience(exp, _)),
    retractall(ranchingExperience(lvl, _)),
    assertz(livestock(cow, 0)),
    assertz(livestock(sheep, 0)),
    assertz(livestock(chicken, 0)),
    assertz(ranchingExperience(exp, 0)),
    assertz(ranchingExperience(lvl, 1)).

buyCow :-
    livestock(cow, X),
    X1 is X+1,
    retract(livestock(cow, X)),
    assertz(livestock(cow, X1)).

buyChicken :-
    livestock(chicken, X),
    X1 is X+1,
    retract(livestock(chicken, X)),
    assertz(livestock(chicken, X1)).

buySheep :-
    livestock(sheep, X),
    X1 is X+1,
    retract(livestock(sheep, X)),
    assertz(livestock(sheep, X1)).

ranch :-
    day(A), ranchingExperience(lvl, B),
    write('Day '),
    write(A),
    write('  Level: '),
    write(B),
    write('\nwelcome to the ranch! You have: \n'),
    livestock(chicken, X), livestock(sheep, Y), livestock(cow, Z),
    write(X),
    write(' chicken(s)\n'),
    write(Y),
    write(' sheep\n'),
    write(Z),
    write(' cow(s)\n'),
    write('\nWhat do you want to do?').

% ranch level up
% ranchLevelUp :-
%     ranchingExperience(Exp),
%     Exp >= 300,
%     ranchingExperience(X),
%     X1 is X+1,
%     retract(ranchingExp(_)),
%     assertz(ranchingExp(0)),
%     retract(ranchingLevel(_)),
%     assertz(ranchingLevel(X1)).

chicken :-
    livestock(chicken, X),
    X = 0,
    write('You have no chickens!\n').
chicken :-
    livestock(chicken, X),
    X > 0.


cow :-
    livestock(cow, X),
    X = 0,
    write('You have no cows!\n').

sheep :-
    livestock(sheep, X),
    X = 0,
    write('You have no sheep!\n').
