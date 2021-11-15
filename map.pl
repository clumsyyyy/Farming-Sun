:- dynamic(map/3).
:- dynamic(pos/2).


changePos(X, Y):-
    retractall(pos(_, _)), assertz(pos(X, Y)).

initTest:-
    assertz(pos(7, 7)).
% ================= peta ================= %
mapSize(15, 15).
% border peta
map(0, _, '#'). map(_, 0, '#'). map(14, _, '#'). map(_, 14, '#'). 
% kolam (o)
map(3, 3, 'o'). map(3, 4, 'o'). map(3, 5, 'o').
map(4, 2, 'o'). map(4, 3, 'o'). map(4, 4, 'o'). map(4, 5, 'o'). map(4, 6, 'o').
map(5, 3, 'o'). map(5, 4, 'o'). map(5, 5, 'o').
% rumah (H)
map(11, 11, 'H').
% marketplace (M)
map(2, 9, 'M').
% ranch (R)
map(12, 4, 'R').
% quest (Q)
map(10, 5, 'Q').
printMapElmt(_, 15):- !, write('\n').
printMapElmt(X, Y):- pos(X, Y), !, write('P').
printMapElmt(X, Y):- map(X, Y, Z), !, write(Z).
printMapElmt(X, Y):- \+map(X, Y, _), !, write('-').

% ================= algo untuk cetak peta =================%
printMap(14, 15):- !.
printMap(A, B):-
    mapSize(X, Y), A < X, B =< Y,
    B =:= Y, printMapElmt(A, B),
    B1 is 0, A1 is A + 1, printMap(A1, B1).
printMap(A, B):-
    mapSize(X, Y), A < X, B =< Y,
    printMapElmt(A, B),
    B1 is (B + 1), printMap(A, B1).

map:-
    \+pos(_, _),
    initTest,
    printMap(0, 0).
map:-
    printMap(0, 0).

% ================= movement mechanics ================= %
w:- pos(A, B), A1 is (A - 1), map(A1, B, '#'), write('Anda menabrak pagar').
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'o'), write('Anda tidak bisa berjalan di air!').
w:- pos(A, B), A1 is (A - 1), write('Pindah ke atas'), changePos(A1, B).

a:- pos(A, B), B1 is (B - 1), map(A, B1, '#'), write('Anda menabrak pagar').
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'o'), write('Anda tidak bisa berjalan di air!').
a:- pos(A, B), B1 is (B - 1), write('Pindah ke kiri'), changePos(A, B1).

s:- pos(A, B), A1 is (A + 1), map(A1, B, '#'), write('Anda menabrak pagar').
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'o'), write('Anda tidak bisa berjalan di air!').
s:- pos(A, B), A1 is (A + 1), write('Pindah ke bawah'), changePos(A1, B).

d:- pos(A, B), B1 is (B + 1), map(A, B1, '#'), write('Anda menabrak pagar').
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'o'), write('Anda tidak bisa berjalan di air!').
d:- pos(A, B), B1 is (B + 1), write('Pindah ke kanan'), changePos(A, B1).
