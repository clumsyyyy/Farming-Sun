:- include('globals.pl').


house:-
/*  I.S. pemain berada di atas tile 'H'
    F.S. pemain dapat mengakses menu di rumah
    (untuk sementara, yang dapat diakses adalah fungsi `sleep`) */
    isOnHouse,
    write('Welcome back to the house.\n'),
    write('What do you want to do?\n'),
    write('1. Sleep\n'),
    write('2. Write Diary\n'),
    write('3. Read Diary\n'), !.

house:-
    \+isOnHouse,
    write('You\'re not at home!').

sleep:-
/* Fungsi meng-update day ke predikat global */
    isOnHouse,
    write('You went to sleep.\n\n'),
    nextDay,
    continue.

nextDay:-
    day(Day),
    Day1 is Day+1,
    retract(day(Day)),
    assertz(day(Day1)),
    forall(myPlant(A,B,_,SymP,SymH,DayPlant,DayToHarvest), grow(A,B,SymP,SymH,DayPlant,DayToHarvest)),
    !.

isOnHouse:-
    pos(X, Y), map(X, Y, 'H').

write:-
    isOnHouse,
    write('Write your diary: '),
    read(Diary),
    write('Diary saved.'),
    day(Day),
    assertz(diary(Day, Diary)),
    write('\n'),
    house.
    
write:-
    \+isOnHouse, write('You\'re not at home!').

read:-
    isOnHouse,
    write('Input diary day: '),
    read(Date),
    day(Day),
    Date < Day, 
    write('Diary for day'), write(Date), write(':\n'),
    diary(Date, Diary), write(Diary),
    write('\n\n'),
    house.
read:-
    isOnHouse,
    write('Input diary day: '),
    read(Date),
    day(Day),
    Day >= Date, write('You cannot read the diary, as it has not existed yet!').
    
read:-
    \+isOnHouse, write('You\'re not at home!').