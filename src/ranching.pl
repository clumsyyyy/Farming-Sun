:- include('globals.pl').


initRanch:-
    assertz(livestock(cow, 0)),
    assertz(livestock(sheep, 0)),
    assertz(livestock(chicken, 0)),
    assertz(ranchEXP(exp, 0.0)),
    assertz(ranchEXP(lvl, 1)),
    assertz(ranchEXP(lvlUpReq, 75)),
    assertz(ranchTimeMgmt(cowDelay, 2.0)),
    assertz(ranchTimeMgmt(chickenDelay, 5.0)),
    assertz(ranchTimeMgmt(sheepDelay, 6.0)),
    assertz(ranchTimeMgmt(cowLastDay, -999)),
    assertz(ranchTimeMgmt(chickenLastDay, -999)),
    assertz(ranchTimeMgmt(sheepLastDay, -999)),
    occupation(Occupation), (
        (Occupation = rancher -> (
            assertz(ranchEXP(occupationBonus, 1.25))
            )
        )
        ;
        assertz(ranchEXP(occupationBonus, 1.0))
    ).

buyCow:-
    livestock(cow, X),
    X1 is X+1,
    retract(livestock(cow, X)),
    assertz(livestock(cow, X1)),
    write('Succesfully bought a new cow!\n'),
    ranchEXPUp(15),!.

buyChicken:-
    livestock(chicken, X),
    X1 is X+1,
    retract(livestock(chicken, X)),
    assertz(livestock(chicken, X1)),
    write('Succesfully bought a new chicken!\n'),
    ranchEXPUp(5),!.

buySheep:-
    livestock(sheep, X),
    X1 is X+1,
    retract(livestock(sheep, X)),
    assertz(livestock(sheep, X1)),
    write('Succesfully bought a new sheep!\n'),
    ranchEXPUp(10),!.
ranch:-
    pos(X, Y), map(X, Y, Z), \+ (Z == 'R'), write('You\'re not in the ranch!'), !.
ranch:-
    pos(X, Y), map(X, Y, 'R'), ranchMenu.

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
    write('\nWhat do you want to do?'),!.

chicken:-
    pos(X, Y), map(X, Y, Z), \+ (Z == 'R'), write('You\'re not in the ranch!'),!.
chicken:-
    livestock(chicken, X),
    X = 0,
    write('You have no chickens!\n'),!.
chicken :-
    livestock(chicken, X),
    X > 0,
    ranchTimeMgmt(chickenDelay, Delay), day(Day), ranchTimeMgmt(chickenLastDay, LastDay),
    Delta is Day - LastDay,
    Delta >= Delay,
    livestock(cow, N),
    write('Your chicken produces '), write(N), write(' eggs!\n'),
    item_in_inventory(egg, Lvl, Qty),
    NewQty is Qty + N,
    retract(item_in_inventory(egg, Lvl, Qty)),
    assertz(item_in_inventory(egg, Lvl, NewQty)),
    retract(ranchTimeMgmt(chickenLastDay, LastDay)),
    assertz(ranchTimeMgmt(chickenLastDay, Day)),
    doRanch,
    % exp  
    E is N * 3,
    ranchEXPUp(E),
    !.
chicken:-
    livestock(chicken, X),
    X > 0,
    ranchTimeMgmt(chickenDelay, Delay), day(Day), ranchTimeMgmt(chickenLastDay, LastDay),
    Delta is Day - LastDay,
    Delta < Delay,
    write('Your chicken is too tired to lay eggs!\n'),
    DayRemain is Delay - Delta,
    DR is ceiling(DayRemain),
    write('Try to come back here in '), write(DR), write(' days.\n'),!.

cow:-
    pos(X, Y), map(X, Y, Z), \+ (Z == 'R'), write('You\'re not in the ranch!'),!.
cow:-
    livestock(cow, X),
    X = 0,
    write('You have no cows!\n'),!.
cow :-
    livestock(cow, X),
    X > 0,
    ranchTimeMgmt(cowDelay, Delay), day(Day), ranchTimeMgmt(cowLastDay, LastDay),
    Delta is Day - LastDay,
    Delta >= Delay,
    livestock(cow, N),
    write('Your cow produces '), write(N), write(' bottle of milk!\n'),
    item_in_inventory(milk, Lvl, Qty),
    NewQty is Qty + N,
    retract(item_in_inventory(milk, Lvl, Qty)),
    assertz(item_in_inventory(milk, Lvl, NewQty)),
    retract(ranchTimeMgmt(cowLastDay, LastDay)),
    assertz(ranchTimeMgmt(cowLastDay, Day)),
    doRanch,
    % exp
    E is N * 3,
    ranchEXPUp(E),
    !.
cow :-
    livestock(cow, X),
    X > 0,
    ranchTimeMgmt(cowDelay, Delay), day(Day), ranchTimeMgmt(cowLastDay, LastDay),
    Delta is Day - LastDay,
    Delta < Delay,
    write('Your cow hasn\'t produced any milk!\n'),
    DayRemain is Delay - Delta,
    DR is ceiling(DayRemain),
    write('Try to come back here in '), write(DR), write(' days.\n'),!.

sheep:-
    pos(X, Y), map(X, Y, Z), \+ (Z == 'R'), write('You\'re not in the ranch!'),!.
sheep:-
    livestock(sheep, X),
    X = 0,
    write('You have no sheep!\n'),!.
sheep :-
    livestock(sheep, X),
    X > 0,
    ranchTimeMgmt(sheepDelay, Delay), day(Day), ranchTimeMgmt(sheepLastDay, LastDay),
    Delta is Day - LastDay,
    Delta >= Delay,
    livestock(sheep, N),
    write('Your sheep produces '), write(N), write(' pack of wool!\n'),
    item_in_inventory(wool, Lvl, Qty),
    NewQty is Qty + N,
    retract(item_in_inventory(wool, Lvl, Qty)),
    assertz(item_in_inventory(wool, Lvl, NewQty)),
    retract(ranchTimeMgmt(sheepLastDay, LastDay)),
    assertz(ranchTimeMgmt(sheepLastDay, Day)),
    doRanch,
    % exp sheep
    E is N * 10,
    ranchEXPUp(E),
    !.
sheep :-
    livestock(sheep, X),
    X > 0,
    ranchTimeMgmt(sheepDelay, Delay), day(Day), ranchTimeMgmt(sheepLastDay, LastDay),
    Delta is Day - LastDay,
    Delta < Delay,
    write('Your sheep hasn\'t produced any wool!\n'),
    DayRemain is Delay - Delta,
    DR is ceiling(DayRemain),
    write('Try to come back here in '), write(DR), write(' days.\n'),!.

ranchEXPUp(EXP_Given):-
    % regular EXP
    ranchEXP(exp, E), ranchEXP(lvl, L), ranchEXP(lvlUpReq, R), ranchEXP(occupationBonus, B),
    E1 is E + EXP_Given * B,
    ERounded is round(E1),
    ERounded < R,
    retract(ranchEXP(exp, E)),
    assertz(ranchEXP(exp, ERounded)),
    write('\nYou gained '), write(EXP_Given), write(' Ranch EXP!\n'),
    write('You are at level '), write(L), write('.\n'),
    write('EXP Status: '), write(ERounded), write('/'), write(R), write('\n'),
    !.
ranchEXPUp(EXP_Given):-
    % level up
    ranchEXP(exp, E), ranchEXP(lvl, L), ranchEXP(lvlUpReq, R), ranchEXP(occupationBonus, B),
    L1 is L + 1, E1 is E + EXP_Given * B,
    ERounded is round(E1),
    ERounded >= R,
    E2 is ERounded - R,
    R1 is R + 25,
    retract(ranchEXP(lvl, L)),
    retract(ranchEXP(exp, E)),
    retract(ranchEXP(lvlUpReq, R)),
    assertz(ranchEXP(lvl, L1)),
    assertz(ranchEXP(exp, E2)),
    assertz(ranchEXP(lvlUpReq, R1)),
    write('\nYou gained '), write(EXP_Given), write(' Ranch EXP!\n'),
    write('Level Up!\n'),
    write('Your ranching experience is now at level '), write(L1), write('\n'),
    write('EXP Status: '), write(ERounded), write('/'), write(R1), write('\n'),
    ranchLvlUpEffect,!.


% Efek level up, jeda hari untuk melakukan aktivitas ranching berkurang
ranchLvlUpEffect:-
    ranchEXP(lvl, Level),
    Level >= 1,
    Level < 5,
    retract(ranchTimeMgmt(chickenDelay, X)),
    retract(ranchTimeMgmt(cowDelay, Y)),
    retract(ranchTimeMgmt(sheepDelay, Z)),
    X1 is X - 0.25,
    Y1 is Y - 0.4,
    Z1 is Z - 0.5,
    assertz(ranchTimeMgmt(chickenDelay, X1)),
    assertz(ranchTimeMgmt(cowDelay, Y1)),
    assertz(ranchTimeMgmt(sheepDelay, Z1)),
    !.
ranchLvlUpEffect:-
    ranchEXP(lvl, Level),
    Level >= 5,
    Level =< 10,
    retract(ranchTimeMgmt(chickenDelay, X)),
    retract(ranchTimeMgmt(cowDelay, Y)),
    retract(ranchTimeMgmt(sheepDelay, Z)),
    X1 is X - 0.5,
    Y1 is Y - 0.5,
    Z1 is Z - 0.5,
    assertz(ranchTimeMgmt(chickenDelay, X1)),
    assertz(ranchTimeMgmt(cowDelay, Y1)),
    assertz(ranchTimeMgmt(sheepDelay, Z1)),
    chickenCap,
    cowCap,
    sheepCap,
    !.

cheatDay(Skip):-
    retract(day(X)),
    X1 is X + Skip,
    assertz(day(X1)),
    !.

chickenCap:-
    ranchTimeMgmt(chickenDelay, X),
    X < 1.0,
    retract(ranchTimeMgmt(chickenDelay, X)),
    assertz(ranchTimeMgmt(chickenDelay, 1.0)),
    !.
cowCap:-
    ranchTimeMgmt(cowDelay, X),
    X < 1.0,
    retract(ranchTimeMgmt(cowDelay, X)),
    assertz(ranchTimeMgmt(cowDelay, 1.0)),
    !.
sheepCap:-
    ranchTimeMgmt(sheepDelay, X),
    X < 1.0,
    retract(ranchTimeMgmt(sheepDelay, X)),
    assertz(ranchTimeMgmt(sheepDelay, 1.0)),
    !.
