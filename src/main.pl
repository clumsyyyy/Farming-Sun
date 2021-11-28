:- include('game.pl').
:- include('globals.pl').

gameStarted:-
    playing(X), X = true.
playing(false).
startGame:-
/*  I.S. Game belum dimulai, gunakan perintah ini untuk memulai game dan menampilkan menu awal.
    F.S. Game berjalan, pemain dapat memilih job yang diinginkan dan memulai game */
    (
        \+gameStarted ->
        (
            
            write('  ____|                       _)                     ___|                \n'),
            write('  |     _` |   __|  __ `__ \\   |  __ \\    _` |    \\ ___ \\   |   |  __ \\  \n'),
            write('  __|  (   |  |     |   |   |  |  |   |  (   |           |  |   |  |   | \n'),
            write(' _|   \\__,_| _|    _|  _|  _| _| _|  _| \\__, |     _____/  \\__,_| _|  _| \n'),
            write('                                        |___/                            \n'),
            write('                                                                         \n'),
            write('             Your journey awaits! TYPE \'start.\' TO BEGIN!               \n')
        )
        ;
        gameStarted ->
        (
            write('You cannot execute this procedure, as you are currently playing!')
        )
    ).
    

selectJob(Num, Output):-
/* Fungsi perantara untuk memilih pekerjaan */
    (Num = 1 -> assertz(occupation(fisherman)), Output = 'You chose fisherman!\n';
    Num = 2 -> assertz(occupation(farmer)) ,Output = 'You chose farmer!\n';
    Num = 3 -> assertz(occupation(rancher)) ,Output = 'You chose rancher!\n').
    

start:-
/*  I.S. dynamic predicate global untuk permainan belum terdefinisi, pemain memilih class
    F.S. dynamic predicate global (gold, day, exp permainan) diinisialisasi, permainan akan dimulai */
    % cek file 'game.pl' untuk melihat permainan

    (
        \+gameStarted->
        (
            story,
            write('1. Fisherman\n'),
            write('2. Farmer\n'),
            write('3. Rancher\n'),
            write('>>> '),
            read(Option),
            selectJob(Option, Output),
            write(Output),
            write('Beginning game....\n'),
            assertz(day(1)),
            assertz(gold(1000)), assertz(exp(0)),    
            assertz(fishEXP(exp, 0)), assertz(fishEXP(lvl, 1)), 
            assertz(fishEXP(level_up_ceil_exp, 300)), assertz(fishing_today(0)), 
            write('Use W, A, S, and D (.) to move!\n\n'),
            write('Use the HELP menu for more information!\n\n'),
            initQuest, initRanch, initFarm, status, map,
            retract(playing(false)), assertz(playing(true))
        )
        ;
        gameStarted->
        (
            write('You cannot execute this procedure, as you are currently playing!')
        )
    ).

    

story:-
    write('\n\n\n'),
    write('Soooo, situation update. You just got scammed overnight.\n\n'),
    write('Remember that project worth 10.000 gold? Yeah, that was a scam.\n\n'),
    write('And you really had to spend all your money on Benshin last night, huh?\n\n'),
    write('But not all hope is lost! You can either go to the loans (and probably get scammed again), \n\n'),
    write('Or you can return to your home village for a short two-month trip!\n (You\'re a freelancer anyways, what\'s office work?\n\n'),
    write('You have to do all the fun harvestry stuff to solve your electric bills,\n\n'),
    write('Before you lose everything. Yes, everything. Including your gachas.\n\n'),
    write('So, what are you waiting for?\n\n'),
    write('As a starter, your family has provided you with 1000 gold (don\'t spend them all on gachas again)\n and some seeds that you can plant!\n\n'),
    write('You have two months to collect 10.000 gold, so it\'s a go-big-or-go-home situation!\n\nGood luck!\n\n'),
    write('Oh, and one last thing before beginning... which role do you prefer to take?\n\n').