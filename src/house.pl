:- include('globals.pl').


house:-
/*  I.S. pemain berada di atas tile 'H'
    F.S. pemain dapat mengakses menu di rumah
    (untuk sementara, yang dapat diakses adalah fungsi `sleep`) */
    isOnHouse,
    houseArt,
    write('Welcome back to the house!\n'),
    write('What do you want to do?\n'),
    write('==================================\n'),
    write('|| 1. Sleep            (sleep.) ||\n'),
    write('|| 2. Write Diary (writeDiary.) ||\n'),
    write('|| 3. Read Diary   (readDiary.) ||\n'), 
    write('==================================\n'),!.

house:-
    \+isOnHouse,
    write('You\'re not at home!').

sleep:-
/* Fungsi meng-update day ke predikat global */
    isOnHouse,
    write('You went to sleep.\n\n'),
    fairy,
    nextDay,
    checkGameState,
    continue, 
    day(Day), alchemist(dayArrived, AlcheDay),
    (Day = AlcheDay) ->
        write('\n\nThere\'s something different upon this peaceful morning...\n'),
        write('Albedo the Alchemist has arrived to the town!\n'),
        write('Please kindly check the marketplace to find out what he has brought.\n'),
        retract(alchemist(hasArrived, _)),
        assertz(alchemist(hasArrived, true))
        ;true,
    !.

nextDay:-
    day(Day),
    Day1 is Day+1,
    retract(day(Day)),
    assertz(day(Day1)),
    retract(fishing_today(_)),
    assertz(fishing_today(0)),
    forall(myPlant(A,B,_,SymP,SymH,DayPlant,DayToHarvest), grow(A,B,SymP,SymH,DayPlant,DayToHarvest)),
    !.

isOnHouse:-
    pos(X, Y), map(X, Y, 'H').

writeDiary:-
    isOnHouse,
    write('Write your diary: '),
    read(Diary),
    write('Diary saved.'),
    day(Day),
    assertz(diary(Day, Diary)),
    write('\n'),
    house.
    
writeDiary:-
    \+isOnHouse, write('You\'re not at home!').

readDiary:-
    isOnHouse,
    write('Available diaries to read:\n'),
    (diary(Day, Diary) ->
        (
            forall(diary(Day, _), (
                format('- Day ~d~n', [Day])
            )),
            write('\nInput diary day: '),
            read(Date),
            write('Diary for day '), write(Date), write(':\n'),
            (diary(Date, Diary) -> write('Diary for day '), write(Date), write(':\n'), write(Diary) ; write('No diary for that day!')),
            write('\n\n'),
            house
        )
        ;
            write('No diaries available to read yet!')
    ).
    

    
readDiary:-
    \+isOnHouse, write('You\'re not at home!').

fairy:-
    random(1, 30, R),
    (R = 5)->
    (
        sleepStory,
        write('Input the X coordinate: '),
        read(X),
        write('Input the Y coordinate: '),
        read(Y),

        (
            isCoordinateValid(X, Y)->
            (
                pos(A, B),
                retract(pos(A, B)),
                assertz(pos(X, Y)),
                write('"Alrighty, see you there. See you later too."\n'),
                write('"Ah, yeah, thanks, but what do you mean see you la-"'),
                write('\n\n'),
                write('"Nggh... that was a weird dream."\n'),
                write('"Wait. Why did I wake up here?"\n'),
                write('\n\n')
            )        
            ;
            (
                fenceStory
            )    
        )
    )
    ;
    (
        write('')
    ).
    
isCoordinateValid(X, Y):-
    \+map(X, Y, 'o'), \+map(X, Y, '#').

sleepStory:-
    write('".....huh?"\n'),
    write('".....am I dead?\n'),
    write('"No, you\'re not. Hello there..."\n'),
    write('"Wait, wh-who are you?"\n'),
    write('"I am a fairy, here to-"\n'),
    write('"Oh God, don\'t tell me you\'re here to take my 2D waifus i-i-\n'),
    write('"Oh, no, rest assured, I won\'t take them."\n'),
    write('"Oh. Good."\n'),
    write('"I also possess no attraction to your worldly two-dimensional mammons."\n'),
    write('"Oh. So what are you here for?"\n'),
    write('"I understand that... doing this farm thing is tough. So I\'m here to give you this.\n'),
    write('"A chance to wake up anywhere you want."\n'),
    write('".....is that the best you can do?"\n'),
    write('"Oh, well, yes. You still have to pay those debts, yanno.\n"'),
    write('"Mmmmhm, okay."\n'),
    write('"So where do you wanna go?"\n').

fenceStory:-
    write('"Sorry, can\'t grant that."\n'),
    write('"Why?"\n'),
    write('"That\'s a place you can\'t get into. Sorry."\n'),
    write('"Oh. So now what?"\n'),
    write('"I can only grant your wish once. Well, until we meet again..."\n'),
    write('"Wait, wha-"\n'),
    write('\n\n'),
    write('"Nggh... that was a weird dream.').
lakeStory:-
    write('"Why would you want to drown yourself into a lake?"\n'),
    write('"Wait, wha-"\n'),
    write('\n\n'),
    write('"Nggh... that was a weird dream.').
houseArt:-
    write('           x   \n'),          
    write('.-. _______|   \n'),
    write('|=|/     /  \\ \n'),
    write('| |_____|_""_| \n'),
    write('|_|_[X]_|____| \n').
