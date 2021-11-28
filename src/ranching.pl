:- include('globals.pl').


initRanch:-
    assertz(livestock(cow, 0)),
    assertz(livestock(sheep, 0)),
    assertz(livestock(chicken, 0)),
    assertz(ranchEXP(exp, 0)),
    assertz(ranchEXP(lvl, 1)),
    assertz(ranchEXP(lvlUpReq, 75)),
    assertz(ranchTimeMgmt(cowDelay, 5.0)),
    assertz(ranchTimeMgmt(chickenDelay, 3.0)),
    assertz(ranchTimeMgmt(sheepDelay, 3.0)),
    assertz(ranchTimeMgmt(cowLastDay, -999)),
    assertz(ranchTimeMgmt(chickenLastDay, -999)),
    assertz(ranchTimeMgmt(sheepLastDay, -999)),
    occupation(Occupation), (
        (Occupation = rancher -> (
            assertz(ranchEXP(occupationBonus, 1.35))
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
    map(X,Y,'R'), pos(A, B), (
        (
            (A =:= X, B =:= Y) -> ranchMenu
        );
        write('You are not in the ranch! Please move over to the ranch.\n')
    ),!.

ranchMenu:-
    ranchArt,
    write('\nwelcome to the ranch! You have: \n'),
    livestock(chicken, X), livestock(sheep, Y), livestock(cow, Z),
    write(X),
    write(' chicken(s)\n'),
    write(Y),
    write(' sheep\n'),
    write(Z),
    write(' cow(s)\n'),
    write('\nWhat do you want to do?'),
    write('\nTo check your chicken, sheep, or cow, use: chicken., sheep., or cow.'),
    write('\nPlease note that you can\'t farm your animals everyday, you have to wait\nfor several days to farm them again!\n'),
    write('So, what\'s it\'s going to be?\n'),
    !.

chicken:-
    map(X,Y,'R'), pos(A, B), (
        (
            (A =:= X, B =:= Y) -> chickenAction
        );
        write('You are not in the ranch! Please move over to the ranch.\n')
    ),!.
chickenAction:-
    livestock(chicken, X),
    X = 0,
    write('You have no chickens!\n'),!.
chickenAction:-
    livestock(chicken, X),
    X > 0,
    ranchTimeMgmt(chickenDelay, Delay), day(Day), ranchTimeMgmt(chickenLastDay, LastDay),
    Delta is Day - LastDay,
    Delta >= Delay,
    livestock(chicken, N),
    write('Your chicken produces '), write(N), write(' eggs!\n'),
    item_in_inventory(egg, Lvl, Qty),
    NewQty is Qty + N,
    retract(item_in_inventory(egg, Lvl, Qty)),
    assertz(item_in_inventory(egg, Lvl, NewQty)),
    retract(ranchTimeMgmt(chickenLastDay, LastDay)),
    assertz(ranchTimeMgmt(chickenLastDay, Day)),
    doRanch(N),
    % exp  
    E is N * 3,
    ranchEXPUp(E),
    !.
chickenAction:-
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
    map(X,Y,'R'), pos(A, B), (
        (
            (A =:= X, B =:= Y) -> cowAction
        );
        write('You are not in the ranch! Please move over to the ranch.\n')
    ),!.
cowAction:-
    livestock(cow, X),
    X = 0,
    write('You have no cows!\n'),!.
cowAction:-
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
    doRanch(N),
    % exp
    E is N * 3,
    ranchEXPUp(E),
    !.
cowAction:-
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
    map(X,Y,'R'), pos(A, B), (
        (
            (A =:= X, B =:= Y) -> sheepAction
        );
        write('You are not in the ranch! Please move over to the ranch.\n')
    ),!.
sheepAction:-
    livestock(sheep, X),
    X = 0,
    write('You have no sheep!\n'),!.
sheepAction:-
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
    doRanch(N),
    % exp sheep
    E is N * 10,
    ranchEXPUp(E),
    !.
sheepAction:-
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
    E_Bonus is round(EXP_Given * B),
    E1 is E + E_Bonus,
    E1 < R,
    retract(ranchEXP(exp, E)),
    assertz(ranchEXP(exp, E1)),
    write('\nYou gained '), write(E_Bonus), write(' Ranch EXP!\n'),
    write('You are at level '), write(L), write('.\n'),
    write('EXP Status: '), write(E1), write('/'), write(R), write('\n'),
    !.
ranchEXPUp(EXP_Given):-
    % level up
    ranchEXP(exp, E), ranchEXP(lvl, L), ranchEXP(lvlUpReq, R), ranchEXP(occupationBonus, B),
    E_Bonus is round(EXP_Given * B),
    E1 is E + E_Bonus,
    L1 is L + 1,
    E1 >= R,
    E2 is E1 - R,
    R1 is R + 25,
    retract(ranchEXP(lvl, L)),
    retract(ranchEXP(exp, E)),
    retract(ranchEXP(lvlUpReq, R)),
    assertz(ranchEXP(lvl, L1)),
    assertz(ranchEXP(exp, E2)),
    assertz(ranchEXP(lvlUpReq, R1)),
    write('\nYou gained '), write(E_Bonus), write(' Ranch EXP!\n'),
    write('Level Up!\n'),
    write('Your ranching experience is now at level '), write(L1), write('\n'),
    write('EXP Status: '), write(E2), write('/'), write(R1), write('\n'),
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
    chickenCap,
    cowCap,
    sheepCap,
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
    ranchTimeMgmt(chickenDelay, X), (
        (
            (X < 1.0) -> (
                retract(ranchTimeMgmt(chickenDelay, X)),
                assertz(ranchTimeMgmt(chickenDelay, 1.0))
            );
            true
        )
    ),
    !.
cowCap:-
    ranchTimeMgmt(cowDelay, X), (
        (
            (X < 1.0) -> (
                retract(ranchTimeMgmt(cowDelay, X)),
                assertz(ranchTimeMgmt(cowDelay, 1.0))
            );
            true
        )
    ),
    !.
sheepCap:-
    ranchTimeMgmt(sheepDelay, X), (
        (
            (X < 1.0) -> (
                retract(ranchTimeMgmt(sheepDelay, X)),
                assertz(ranchTimeMgmt(sheepDelay, 1.0))
            );
            true
        )
    ),
    !.


ranchArt:-
    write('                             +&-            \n'),
    write('                           _.-^-._    .--.  \n'),
    write('                        .-\'   _ \'-. |__|  \n'),
    write('                       /     |_|     \\|  | \n'),
    write('                      /  [The Ranch]  \\  | \n'),
    write('                     /|     _____     |\\ |  \n'),
    write('                      |    |==|==|    |  |  \n'),
    write('  |---|---|---|---|---|    |--|--|    |  |  \n'),
    write('  |---|---|---|---|---|    |==|==|    |  |  \n'),
    write(' ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^').