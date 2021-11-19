:- include('globals.pl').


house:-
    pos(X, Y), map(X, Y, 'H'),
    write('Welcome back to the house.\n'),
    write('What do you want to do?\n'),
    write('1. Sleep\n'),
    write('(gatau bonusnya mo gimana)\n'),
    read(Option),
    Option =:= 1 -> sleep.

house:-
    pos(X, Y), map(X, Y, Z), Z \== 'H',
    write('You\'re not at home').
sleep:-
    write('konTOL'),
    time(X),
    write(X).