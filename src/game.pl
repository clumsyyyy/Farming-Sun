/*  include file-file untuk fungsi lain secara modular.
    File akan terkompilasi apabila fungsi `game` diinisialisasi */
:- include('globals.pl').
:- include('map.pl').
:- include('fishing.pl').
:- include('ranching.pl').
:- include('inventory.pl').
:- include('market.pl').
:- include('house.pl').
:- include('quest.pl').
:- include('farming.pl').


continue:-
    status,
    map.
status:-
/* Fungsi untuk menampilkan informasi terkait uang, hari, dan EXP pemain */
    day(Day), gold(Gold), occupation(Occupation),
    farmEXP(exp, FarmEXP), farmEXP(lvl, Farmlvl),
    fishEXP(exp, FishEXP), fishEXP(lvl, Fishlvl),
    ranchEXP(exp, RanchEXP), ranchEXP(lvl, Ranchlvl),
    write('\n   Occupation: '), write(Occupation), write('\n'),
    write('     Day: '), write(Day), write(' | '),
    write('Gold: '), write(Gold), write('\n'),
    write('========== LEVELS ==========\n'),
    write(' Farming | EXP: '), write(FarmEXP), write(' | LVL: '), write(Farmlvl), write('\n'),
    write(' Fishing | EXP: '), write(FishEXP), write(' | LVL: '), write(Fishlvl), write('\n'),
    write(' Ranching| EXP: '), write(RanchEXP), write(' | LVL: '), write(Ranchlvl), write('\n'), !.

quit:-
    write('Thank you for playing the game! We hope to see you again soon!\n'),
    halt(0).

help:-
    write('================================== HELP MENU ==================================\n\n'),
    write('1. The objective of the game is to obtain 20.000 gold before two months passes by!\n'),
    write('2. Move with the command w., a., s., or d.\n'),
    write('3. Location definitions are as such:\n'),
    write('     - R: Ranch, use the command ranch. at this tile to begin ranching!\n'),
    write('     - o: Lake, use the command fish. near this tile to begin fishing!\n'),
    write('     - -: Land, use the command dig. and plant. at the tile to begin planting a seed!\n'),
    write('     - Q: Quest, use the command quest. at this tile to pick quests up!\n'),
    write('     - M: Marketplace, use the command market. at this tile to buy/sell items!\n'),
    write('     - H: House, use the command house. at this tile to access your house menu!\n'),
    write('4. You can plant a seed and harvest it after a certain amount of time passes by \nusing the harvest. command.\n'),
    write('     - small characters represent the seed, while capital characters represent a harvest-ready plant.\n'),
    write('5. You can produce animal goods by ranching and sell it at the marketplace.\n'),
    write('     - use the command cow., sheep., or chicken., at the ranch to produce goods in a set amount of time.\n'),
    write('6. Completing quests will give you extra EXP and money. You can only pick up more\n quests after the current quest have been completed.\n'),
    write('7. The day will update when you sleep at your home.\n'),
    write('     - use the command sleep. to sleep\n'),
    write('     - use the command read. / write. to read / write your diary.\n'),
    write('8. The occupation you selected will give you perks in certain activities!\n'),
    write('9. Type \'commands.\' to see the list of commands you can do!').

commands:-
    write('====================== [ COMMANDS  LIST ] ======================\n'),
    write('                                                                \n'),
    write('1. w. , a. , s. , d.         - to move your character (symbol P)\n'),
    write('2. dig.                      - to dig an empty tile             \n'),
    write('3. plant.                    - to plant a seed on a digged tile \n'),
    write('4. harvest.                  - to harvest a plant               \n'),
    write('                (capital symbol represents a harvestable plant) \n'),
    write('5. ranch.                    - to open the ranch menu           \n'),
    write('                          (can only be performed in the R tile) \n'),
    write('6. chicken. , cow. , sheep.  - to produce animal goods          \n'),
    write('7. fish   .                  - to open the fish menu            \n'),
    write('                          (can only be performed near the o tile\n'),
    write('8. market. , buy. , sell.    - to open the market menu, buy/sell\n'),
    write('                          (can only be performed in the M tile) \n'),
    write('9. house.                    - to open the house menu           \n'),
    write('                          (can only be performed in the H tile) \n'),
    write('                                                                \n'),
    write('Information regarding helper commands can be seen when          \n'),
    write('performing other commands!                                      \n'),
    write('                                                                \n'),
    write('====================== [ COMMANDS  LIST ] ======================\n'), 
    write('\n\n').

checkGameState:-
    gold(Gold), day(Day),
    (
        (Gold >= 20000, Day =< 60, goal(false))->
        (
            write('\nYay, you have completed the game!\n'),
            write('You\'ve collected 20000 gold in less than two months!\n'),
            write('You can continue playing, or use the command \'quit\' to exit the game...\n'),
            retract(goal(false)), assertz(goal(true))
        )
        ;
        (Gold < 20000, Day > 60) ->
        (
            write('\nSorry, you\'re unable to complete the objective! :(\n'),
            write('Better luck next time!\n')
        )
        ;
        (
            write('')
        )

    ).

globalEXPUp(EXPGiven) :-
    globalEXP(lvlUpReq, R), globalEXP(exp, X),
    TotalEXP is X + EXPGiven,
    ((TotalEXP >= R) -> (
        retract(globalEXP(lvl, L)),
        retract(globalEXP(lvlUpReq, R)),
        retract(globalEXP(exp, X)),
        NewL is L + 1,
        NewR is R + (L * 100),
        NewX is TotalEXP - R,
        assertz(globalEXP(lvl, NewL)),
        assertz(globalEXP(lvlUpReq, NewR)),
        assertz(globalEXP(exp, NewX)),!
    ));
    retract(globalEXP(exp, X)),
    NewX is X + EXPGiven,
    assertz(globalEXP(exp, NewX)),!.