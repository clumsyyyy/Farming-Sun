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
    nextDay,
    checkGameState,
    continue, !.

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

houseArt:-
    write('           x   \n'),          
    write('.-. _______|   \n'),
    write('|=|/     /  \\ \n'),
    write('| |_____|_""_| \n'),
    write('|_|_[X]_|____| \n').
