:- include('globals.pl').


:- dynamic(lastRacnh/2).
% day
%initDay:- retractall(day(_)), assertz(day(1)).
%nextDay:- day(X), Y is X + 1, retract(day(_)), assertz(day(Y)).

initRanch:-
    %retractall(livestock(cow, _)),
    %retractall(livestock(sheep, _)),
    %retractall(livestock(chicken, _)),
    %retractall(ranchEXP(exp, _)),
    %retractall(ranchEXP(lvl, _)),
    assertz(livestock(cow, 0)),
    assertz(livestock(sheep, 0)),
    assertz(livestock(chicken, 0)),
    assertz(ranchEXP(exp, 0)),
    assertz(ranchEXP(lvl, 1)).

buyCow:-
    livestock(cow, X),
    X1 is X+1,
    retract(livestock(cow, X)),
    assertz(livestock(cow, X1)),
    write('Succesfully bought a new cow!\n').

buyChicken:-
    livestock(chicken, X),
    X1 is X+1,
    retract(livestock(chicken, X)),
    assertz(livestock(chicken, X1)).
    write('Succesfully bought a new chicken!\n').

buySheep:-
    livestock(sheep, X),
    X1 is X+1,
    retract(livestock(sheep, X)),
    assertz(livestock(sheep, X1)).
    write('Succesfully bought a new sheep!\n').
ranch:-
    pos(X, Y), map(X, Y, Z), \+ (Z == 'R'), write('You\'re not in the ranch!').
ranch:-
    pos(X, Y), map(X, Y, 'R'), ranchEXP(exp, 0), write('Initializing a new ranch...\n'), initRanch, ranchMenu.
ranch:-
    pos(X, Y), map(X, Y, 'R'), ranchEXP(exp, _), ranchMenu.

ranchMenu:-
    day(A), ranchEXP(lvl, B),
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
%     ranchEXP(Exp),
%     Exp >= 300,
%     ranchEXP(X),
%     X1 is X+1,
%     retract(ranchingExp(_)),
%     assertz(ranchingExp(0)),
%     retract(ranchingLevel(_)),
%     assertz(ranchingLevel(X1)).

chicken:-
    livestock(chicken, X),
    X = 0,
    write('You have no chickens!\n').
chicken:-
    livestock(chicken, X),
    X > 0.


cow:-
    livestock(cow, X),
    X = 0,
    write('You have no cows!\n').

sheep:-
    livestock(sheep, X),
    X = 0,
    write('You have no sheep!\n').
