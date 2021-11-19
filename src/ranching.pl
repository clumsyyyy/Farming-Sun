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
    X > 0,
    ranchTimeMgmt(chickenDelay, Delay), day(Day), ranchTimeMgmt(chickenLastDay, LastDay),
    Delta is Day - LastDay,
    Delta < Delay,
    write('Your chicken is too tired to lay eggs!\n'),
    DayRemain is Delay - Delta,
    write('Try to come back here in '), write(DayRemain), write(' days.\n').


cow:-
    livestock(cow, X),
    X = 0,
    write('You have no cows!\n').
cow :-
    livestock(cow, X),
    X > 0,
    ranchTimeMgmt(cowDelay, Delay), day(Day), ranchTimeMgmt(cowLastDay, LastDay),
    Delta is Day - LastDay,
    Delta >= Delay,
    livestock(cow, N),
    write('Your cow produces '), write(N), write(' bottle of milk!\n'),
    retract(ranchTimeMgmt(cowLastDay, LastDay)),
    assertz(ranchTimeMgmt(cowLastDay, Day)),
    % exp
    E is N * 3,
    expUp(E),
    !.
cow :-
    livestock(cow, X),
    X > 0,
    ranchTimeMgmt(cowDelay, Delay), day(Day), ranchTimeMgmt(cowLastDay, LastDay),
    Delta is Day - LastDay,
    Delta < Delay,
    write('Your cow hasn\'t produced any milk!\n'),
    DayRemain is Delay - Delta,
    write('Try to come back here in '), write(DayRemain), write(' days.\n').


sheep:-
    livestock(sheep, X),
    X = 0,
    write('You have no sheep!\n').
sheep :-
    livestock(sheep, X),
    X > 0,
    ranchTimeMgmt(sheepDelay, Delay), day(Day), ranchTimeMgmt(sheepLastDay, LastDay),
    Delta is Day - LastDay,
    Delta >= Delay,
    livestock(sheep, N),
    write('Your sheep produces '), write(N), write(' pack of wool!\n'),
    retract(ranchTimeMgmt(sheepLastDay, LastDay)),
    assertz(ranchTimeMgmt(sheepLastDay, Day)),
    % exp sheep
    E is N * 10,
    expUp(E),
    !.
sheep :-
    livestock(sheep, X),
    X > 0,
    ranchTimeMgmt(sheepDelay, Delay), day(Day), ranchTimeMgmt(sheepLastDay, LastDay),
    Delta is Day - LastDay,
    Delta < Delay,
    write('Your sheep hasn\'t produced any wool!\n'),
    DayRemain is Delay - Delta,
    write('Try to come back here in '), write(DayRemain), write(' days.\n').