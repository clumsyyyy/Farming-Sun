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
    write('\n  Occupation: '), write(Occupation), write('\n'),
    write('     Day: '), write(Day), write(' | '),
    write('Gold: '), write(Gold), write('\n'),
    write('========== LEVELS ==========\n'),
    write(' Farming | EXP: '), write(FarmEXP), write(' | LVL: '), write(Farmlvl), write('\n'),
    write(' Fishing | EXP: '), write(FishEXP), write(' | LVL: '), write(Fishlvl), write('\n'),
    write(' Ranching| EXP: '), write(RanchEXP), write(' | LVL: '), write(Ranchlvl), write('\n').

quit:-
    write('Terima kasih telah bermain!\n'),
    halt(0).

help:-
    write('================================== HELP MENU ==================================\n\n'),
    write('1. The objective of the game is to obtain 20.000 gold before a year passes by!\n'),
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
    write('8. The occupation you selected will give you perks in certain activities!\n').

checkGameState:-
    gold(Gold), day(Day),
    (
        (Gold >= 10000, Day =< 60)->
        (
            write('Yay, you have completed the game!\n'),
            write('You\'ve collected 5000 gold in less than two months!\n'),
            write('You can continue playing, or use the command \'quit\' to exit the game...\n')
        )
        ;
        (Gold < 10000, Day > 60) ->
        (
            write('Sorry, you\'re unable to complete the objective! :(\n'),
            write('Better luck next time!\n')
        )
        ;
        (
            write('')
        )

    ).