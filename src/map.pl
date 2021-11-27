:- include('globals.pl').
:- dynamic(map/3).

changePos(X, Y):-
/* Fungsi perantara untuk meng-updateposisi pemain */
    retractall(pos(_, _)), assertz(pos(X, Y)).

initTest:-
/* Apabila posisi pemain belum terinisialisasi, maka akan diinisialisasi di tengah */
    assertz(pos(7, 7)).


% ================= peta ================= %
mapSize(17, 17).
% border peta
map(0, _, '#'). map(_, 0, '#'). map(16, _, '#'). map(_, 16, '#'). 
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

/* Penulisan peta secara rekursif.
- Apabila telah mencapai kolom 15, peta akan dituliskan dengan simbol \n
- Apabila elemen peta adalah posisi pemain, peta akan dituliskan dengan simbol 'P'
- Apabila elemen peta terdefinisi, peta akan dituliskan sesuai simbol tersebut
- Apabila elemen peta tidak terdefinisi (tanah kosong), peta akan dituliskan dengan simbol '-' */
printMapElmt(_, 17):- !, write('\n').
printMapElmt(X, Y):- pos(X, Y), !, write('P').
printMapElmt(X, Y):- map(X, Y, Z), !, write(Z).
printMapElmt(X, Y):- \+map(X, Y, _), !, write('-').

% ================= algoritma untuk cetak peta =================%
printMap(16, 17):- !.
% penulisan peta berhenti saat peta habis
printMap(A, B):- 
% apabila telah mencapai kolom akhir, maka penulisan peta diulang di baris baru
    mapSize(X, Y), A < X, B =< Y,
    B =:= Y, printMapElmt(A, B),
    B1 is 0, A1 is A + 1, printMap(A1, B1).
% apabila belum mencapai kolom akhir, tetap menuliskan elemen peta.
printMap(A, B):-
    mapSize(X, Y), A < X, B =< Y,
    printMapElmt(A, B),
    B1 is (B + 1), printMap(A, B1).

map:-
% inisialisasi posisi peta apabila posisi belum terdefinisi 
    \+pos(_, _),
    initTest,
    printMap(0, 0), !.
map:-
% apabila posisi terdefinisi, tidak perlu inisialisasi
    printMap(0, 0), !.

% ================= movement mechanics ================= %

/* Prekondisi secara umum:
- Apabila pemain telah sampai di ujung peta, akan muncul pesan bahwa pemain telah sampai di pagar
(posisi pemain tidak akan diubah)
- Apabila pemain telah sampai di tile yang ditanam, akan muncul pesan pemain bisa menanam
- Apabila pemain telah sampai di lokasi-lokasi terdefinisi, akan muncul pesan pemain bisa menggunakan fungsi-fungsi tertentu
- Apabila pemain bergerak biasa, posisi akan diupdate dan map baru akan dicetak.
*/

w:- pos(A, B), A1 is (A - 1), map(A1, B, '#'), write('Oops, you\'ve hit a fence!\n\n'), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, _), myPlant(A1,B,_,_,_,_,_), write('Oops, you can\'t step over the planted tile!\n\n'), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, '='), write('You\'ve arrived at the digged tile!\nYou can plant seed here.\nUse command \'dig.\' then \'plant.\' ...\n'), A2 is A1-1, changePos(A2, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'o'), write('You\'ve arrived at the Lake!\nYou can fish here.\nUse command \'fish.\'...\n'), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'H'), write('You\'ve arrived at your House!\nUse command \'house.\' to access your house...\n'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'Q'), write('You\'ve arrived at the Quest Centre!\nYou can pick up quests here.\nUse command \'quest\' ...\n'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'M'), write('You\'ve arrived at the Marketplace!\nYou can buy items here.\nUse command \'market.\' ...\n'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'R'), write('You\'ve arrived at the Ranch!\nUse command \'ranch.\' to start ranching...\n'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), write('Moved one tile above!\n\n'), changePos(A1, B), map, !.


a:- pos(A, B), B1 is (B - 1), map(A, B1, '#'), write('Oops, you\'ve hit a fence!\n\n'), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, _), myPlant(A,B1,_,_,_,_,_), write('Oops, you can\'t step over the planted tile!\n\n'), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, '='), write('You\'ve arrived at the digged tile!\nYou can plant seed here.\nUse command \'dig.\' then \'plant.\' ...\n'), A1 is A-1, changePos(A1,B1), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'o'),  write('You\'ve arrived at the Lake!\nYou can fish here.\nUse command \'fish.\'...\n'), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'H'), write('You\'ve arrived at your House!\nUse command \'house.\' to access your house...\n'), changePos(A, B1), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'Q'), write('You\'ve arrived at the Quest Centre!\nYou can pick up quests here.\nUse command \'quest\' ...\n'), changePos(A, B1), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'M'), write('You\'ve arrived at the Marketplace!\nYou can buy items here.\nUse command \'market.\' ...\n'), changePos(A, B1),map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'R'), write('You\'ve arrived at the Ranch!\nUse command \'ranch.\' to start ranching...\n'), changePos(A, B1), map, !.
a:- pos(A, B), B1 is (B - 1), write('Moved one tile left!\n\n'), changePos(A, B1), map, !.


s:- pos(A, B), A1 is (A + 1), map(A1, B, '#'), write('Oops, you\'ve hit a fence!\n\n'), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, _), myPlant(A1,B,_,_,_,_,_), write('Oops, you can\'t step over the planted tile!\n\n'), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, '='), write('You\'ve arrived at the digged tile!\nYou can plant seed here.\nUse command \'dig.\' then \'plant.\' ...\n'), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'o'),  write('You\'ve arrived at the Lake!\nYou can fish here.\nUse command \'fish.\'...\n'), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'H'), write('You\'ve arrived at your House!\nUse command \'house.\' to access your house...\n'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'Q'), write('You\'ve arrived at the Quest Centre!\nYou can pick up quests here.\nUse command \'quest\' ...\n'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'M'), write('You\'ve arrived at the Marketplace!\nYou can buy items here.\nUse command \'market.\' ...\n'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'R'), write('You\'ve arrived at the Ranch!\nUse command \'ranch.\' to start ranching...\n'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), write('Moved one tile below!\n'), changePos(A1, B), map, !.


d:- pos(A, B), B1 is (B + 1), map(A, B1, '#'), write('Oops, you\'ve hit a fence!\n\n'), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, _), myPlant(A,B1,_,_,_,_,_), write('Oops, you can\'t step over the planted tile!\n\n'), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, '='), write('You\'ve arrived at the digged tile!\nYou can plant seed here.\nUse command \'dig.\' then \'plant.\' ...\n'), A1 is A-1, changePos(A1,B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'o'),  write('You\'ve arrived at the Lake!\nYou can fish here.\nUse command \'fish.\'...\n'), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'H'), write('You\'ve arrived at your House!\nUse command \'house.\' to access your house...\n'), changePos(A, B1), map.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'Q'), write('You\'ve arrived at the Quest Centre!\nYou can pick up quests here.\nUse command \'quest\' ...\n'), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'M'), write('You\'ve arrived at the Marketplace!\nYou can buy items here.\nUse command \'market.\' ...\n'), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'R'), write('You\'ve arrived at the Ranch!\nUse command \'ranch.\' to start ranching...\n'), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), write('Moved one tile right!\n\n'), changePos(A, B1), map, !.

