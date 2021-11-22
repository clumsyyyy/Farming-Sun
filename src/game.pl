/*  include file-file untuk fungsi lain secara modular.
    File akan terkompilasi apabila fungsi `game` diinisialisasi */
:- include('globals.pl').
:- include('map.pl').
:- include('farming.pl').
:- include('fishing.pl').
% :- include('ranching.pl').
:- include('inventory.pl').
:- include('house.pl').
:- include('quest.pl').


game:-
/* Inisialisasi permainan */
    write('Use W, A, S, and D (.) to move!\n\n'),
    write('Use the HELP menu for more information!\n\n'),
    status,
    map.

status:-
/* Fungsi untuk menampilkan informasi terkait uang, hari, dan EXP pemain */
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

quit:-
    write('Terima kasih telah bermain!\n'),
    halt(0).

help:-
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('% 1. start  : untuk memulai petualanganmu                                      %\n'),
    write('% 2. map    : menampilkan peta                                                 %\n'),
    write('% 3. status : menampilkan kondisimu terkini                                    %\n'),
    write('% 4. w      : gerak ke utara 1 langkah                                         %\n'),
    write('% 5. s      : gerak ke selatan 1 langkah                                       %\n'),
    write('% 6. d      : gerak ke ke timur 1 langkah                                      %\n'),
    write('% 7. a      : gerak ke barat 1 langkah                                         %\n'),
    write('% 8. Status : menampilkan status pemain                                        %\n'),
    write('% 9. help   : menampilkan segala bantuan                                       %\n'),
    write('% 0. quit   : keluar dari permainan                                            %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').