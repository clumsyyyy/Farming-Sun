:- include('globals.pl').
:- include('map.pl').
:- include('fishing.pl').
:- include('ranching.pl').
:- include('inventory.pl').
:- include('house.pl').

game:-
    write('Use W, A, S, and D (.) to move!\n\n'),
    info,
    map.

info:-
    day(Day), gold(Gold),
    farmEXP(exp, FarmEXP), farmEXP(lvl, Farmlvl),
    fishEXP(exp, FishEXP), fishEXP(lvl, Fishlvl),
    ranchEXP(exp, RanchEXP), ranchEXP(lvl, Ranchlvl),
    write('     Day: '), write(Day), write(' | '),
    write('Gold: '), write(Gold), write('\n'),
    write('========== LEVELS ==========\n'),
    write(' Farming | EXP: '), write(FarmEXP), write(' | LVL: '), write(Farmlvl), write('\n'),
    write(' Fishing | EXP: '), write(FishEXP), write(' | LVL: '), write(Fishlvl), write('\n'),
    write(' Ranching| EXP: '), write(RanchEXP), write(' | LVL: '), write(Ranchlvl), write('\n').