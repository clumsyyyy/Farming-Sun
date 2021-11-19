:- include('globals.pl').
:- include('map.pl').
:- include('fishing.pl').
:- include('inventory.pl').
:- include('ranch.pl').
:- include('house.pl').

game:-
    write('Use W, A, S, and D (.) to move!\n\n'),
    info,
    map.

info:-
    day(Day), gold(Gold),
    write('Day: '), write(Day), write('\n'),
    write('Gold: '), write(Gold), write('\n').