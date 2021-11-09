/* dump predicate */

:- dynamic(level/1).
:- dynamic(farmLevel/1).
:- dynamic(farmEXP/1).
:- dynamic(fishLevel/1).
:- dynamic(fishEXP/1).
:- dynamic(ranchLevel/1).
:- dynamic(ranchEXP/1).
:- dynamic(exp/1).
:- dynamic(gold/1).

:- dynamic(inventory/1).

startGame:-
    write(' _   _                          _   \n'),
    write('| | | | __ _ _ ____ _____ _____| |_  \n'),
    write('| |_| |/ _` | __\\ \\ / / _ \\/ __| __| \n'),
    write('|  _  | (_| | |  \\ V / __/ \\__ \\ |_  \n'),
    write('|_| |_|\\__,_|_|  \\/\\ \\___||___/\\__| \n'),
    write('Harvest Star!!!\n'),
    write('Lets play and pay our debts together\n'),
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
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%').



start:-
    write('Welcome to Harvest Star. Choose your job\n'),
    write('1. Fisherman\n'),
    write('2. Farmer\n'),
    write('3. Rancher\n'),
    write('>>> '),
    read(Option),
    write(Option).
    