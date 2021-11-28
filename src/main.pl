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
    story,
    start.

selectJob(Num, Output):-
/* Fungsi perantara untuk memilih pekerjaan */
    (Num = 1 -> assertz(occupation(fisherman)), Output = 'You chose fisherman!\n';
    Num = 2 -> assertz(occupation(farmer)) ,Output = 'You chose farmer!\n';
    Num = 3 -> assertz(occupation(rancher)) ,Output = 'You chose rancher!\n').
    

start:-
/*  I.S. dynamic predicate global untuk permainan belum terdefinisi, pemain memilih class
    F.S. dynamic predicate global (gold, day, exp permainan) diinisialisasi, permainan akan dimulai */
    % cek file 'game.pl' untuk melihat permainan
    write('1. Fisherman\n'),
    write('2. Farmer\n'),
    write('3. Rancher\n'),
    write('>>> '),
    read(Option),
    selectJob(Option, Output),
    write(Output),
    write('Beginning game....\n'),
    story,
    assertz(day(1)),
    assertz(gold(500)), assertz(exp(0)),
    assertz(fishEXP(exp, 0)), assertz(fishEXP(lvl, 1)),
    write('Use W, A, S, and D (.) to move!\n\n'),
    write('Use the HELP menu for more information!\n\n'),
    initQuest,
    initRanch,
    initFarm,
    status,
    map,
    assertz(fishEXP(exp, 0)), assertz(fishEXP(lvl, 1)), assertz(fishEXP(level_up_ceil_exp, 300)),
    assertz(ranchEXP(exp, 0)), assertz(ranchEXP(lvl, 1)).
    

story:-
    write('\n\n\n'),
    write('Soooo, situation update. You just got scammed overnight.\n\n'),
    write('Remember that project worth 5.000 gold? Yeah, that was a scam.\n\n'),
    write('And you really had to spend all your money on Benshin last night, huh?\n\n'),
    write('But not all hope is lost! You can either go to the loans (and probably get scammed again), \n\n'),
    write('Or you can return to your home village for a short two-month trip!\n (You\'re a freelancer anyways, what\'s office work?\n\n'),
    write('You have to do all the fun harvestry stuff to solve your electric bills,\n\n'),
    write('Before you lose everything. Yes, everything. Including your gachas.\n\n'),
    write('So, what are you waiting for?\n\n'),
    write('As a starter, your family has provided you with 500 gold (don\'t spend them all on gachas again)\n and some seeds that you can plant!\n\n'),
    write('You have two months to collect 5.000 gold, so it\'s a go-big-or-go-home situation!\n\nGood luck!\n\n'),
    write('Oh, and one last thing before beginning... which role do you prefer to take?\n\n').