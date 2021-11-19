:- dynamic(livestock/2).
:- dynamic(ranchingExperience/2).
:- dynamic(ranchTimeMgmt/2).
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
    retractall(ranchingExperience(lvlUpReq, _)),
    retractall(ranchTimeMgmt(cowDelay, _)),
    retractall(ranchTimeMgmt(chickenDelay, _)),
    retractall(ranchTimeMgmt(sheepDelay, _)),
    retractall(ranchTimeMgmt(cowLastDay, _)),
    retractall(ranchTimeMgmt(chickenLastDay, _)),
    retractall(ranchTimeMgmt(sheepLastDay, _)),
    assertz(livestock(cow, 0)),
    assertz(livestock(sheep, 0)),
    assertz(livestock(chicken, 0)),
    assertz(ranchingExperience(exp, 0)),
    assertz(ranchingExperience(lvl, 1)),
    assertz(ranchingExperience(lvlUpReq, 100)),
    assertz(ranchTimeMgmt(cowDelay, 5)),
    assertz(ranchTimeMgmt(chickenDelay, 10)),
    assertz(ranchTimeMgmt(sheepDelay, 10)),
    assertz(ranchTimeMgmt(cowLastDay, 1)),
    assertz(ranchTimeMgmt(chickenLastDay, 1)),
    assertz(ranchTimeMgmt(sheepLastDay, 1)).

init :-
    initDay,
    initRanch.

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

% ranch level management
expUp(EXP_Given) :-
    % regular EXP
    ranchingExperience(exp, E), ranchingExperience(lvl, L), ranchingExperience(lvlUpReq, R),
    E1 is E + EXP_Given,
    E1 < R,
    retract(ranchingExperience(exp, E)),
    assertz(ranchingExperience(exp, E1)),
    write('\nYou gained '), write(EXP_Given), write(' Ranch EXP!\n'),
    write('You are at level '), write(L), write('.\n'),
    write('EXP Status: '), write(E1), write('/'), write(R), write('\n'),
    !.
expUp(EXP_Given) :-
%     % level up
    ranchingExperience(exp, E), ranchingExperience(lvl, L), ranchingExperience(lvlUpReq, R),
    L1 is L + 1, E1 is E + EXP_Given,
    E1 >= R,
    E2 is E1 - R,
    R1 is R + 100,
    retract(ranchingExperience(lvl, L)),
    retract(ranchingExperience(exp, E)),
    retract(ranchingExperience(lvlUpReq, R)),
    assertz(ranchingExperience(lvl, L1)),
    assertz(ranchingExperience(exp, E2)),
    assertz(ranchingExperience(lvlUpReq, R1)),
    write('\nYou gained '), write(EXP_Given), write(' Ranch EXP!\n'),
    write('Level Up!\n'),
    write('You are now level '), write(L1), write('\n'),
    write('EXP Status: '), write(E2), write('/'), write(R1), write('\n'),!.

chicken :-
    livestock(chicken, X),
    X = 0,
    write('You have no chickens!\n'),!.
chicken :-
    livestock(chicken, X),
    X > 0,
    ranchTimeMgmt(chickenDelay, Delay), day(Day), ranchTimeMgmt(chickenLastDay, LastDay),
    Delta is Day - LastDay,
    Delta >= Delay,
    livestock(chicken, N),
    write('Your chicken lay '), write(N), write(' eggs!\n'),
    retract(ranchTimeMgmt(chickenLastDay, LastDay)),
    assertz(ranchTimeMgmt(chickenLastDay, Day)),
    % exp
    E is N * 5,
    expUp(E),
    !.
chicken :-
    livestock(chicken, X),
    X > 0,
    ranchTimeMgmt(chickenDelay, Delay), day(Day), ranchTimeMgmt(chickenLastDay, LastDay),
    Delta is Day - LastDay,
    Delta < Delay,
    write('Your chicken is too tired to lay eggs!\n'),
    DayRemain is Delay - Delta,
    write('Try to come back here in '), write(DayRemain), write(' days.\n').


cow :-
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


sheep :-
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