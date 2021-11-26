:- include('game.pl').
:- include('globals.pl').


startGame:-
/*  I.S. Game belum dimulai, gunakan perintah ini untuk memulai game dan menampilkan menu awal.
    F.S. Game berjalan, pemain dapat memilih job yang diinginkan dan memulai game */
    write(' _   _                          _   \n'),
    write('| | | | __ _ _ ____ _____ _____| |_  \n'),
    write('| |_| |/ _` | __\\ \\ / / _ \\/ __| __| \n'),
    write('|  _  | (_| | |  \\ V / __/ \\__ \\ |_  \n'),
    write('|_| |_|\\__,_|_|   \\/ \\ ___||___/\\__| \n'),
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
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    start.

selectJob(Num, Output):-
/* Fungsi perantara untuk memilih pekerjaan */
    (Num = 1 -> assertz(occupation('Fisherman')), Output = 'You chose fisherman!\n';
    Num = 2 -> assertz(occupation('Farmer')) ,Output = 'You chose farmer!\n';
    Num = 3 -> assertz(occupation('Rancher')) ,Output = 'You chose rancher!\n').
    

start:-
/*  I.S. dynamic predicate global untuk permainan belum terdefinisi, pemain memilih class
    F.S. dynamic predicate global (gold, day, exp permainan) diinisialisasi, permainan akan dimulai */
    % cek file 'game.pl' untuk melihat permainan
    write('Welcome to Harvest Star. Choose your job\n'),
    write('1. Fisherman\n'),
    write('2. Farmer\n'),
    write('3. Rancher\n'),
    write('>>> '),
    read(Option),
    selectJob(Option, Output),
    write(Output),
    write('Beginning game....\n'),
    assertz(day(1)),
    assertz(gold(5000)), assertz(exp(0)),
    assertz(farmEXP(exp, 0)), assertz(farmEXP(lvl, 1)),
    assertz(fishEXP(exp, 0)), assertz(fishEXP(lvl, 1)),
    assertz(ranchEXP(exp, 0)), assertz(ranchEXP(lvl, 1)),
    game.
    

