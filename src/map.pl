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

w:- pos(A, B), A1 is (A - 1), map(A1, B, '#'), mapArt('#'), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, _), myPlant(A1,B,Name,_,_,_,_), mapArtPlant(A1,B,Name), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, '='), mapArt('equal'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'o'), mapArt('o'), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'H'), mapArt('H'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'Q'), mapArt('Q'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'M'), mapArt('M'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), map(A1, B, 'R'), mapArt('R'), changePos(A1, B), map, !.
w:- pos(A, B), A1 is (A - 1), mapArt('Above'), changePos(A1, B), map, !.


a:- pos(A, B), B1 is (B - 1), map(A, B1, '#'), mapArt('#'), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, _), myPlant(A,B1,Name,_,_,_,_), mapArtPlant(A,B1,Name), changePos(A, B1), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, '='), mapArt('equal'), changePos(A,B1), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'o'),  mapArt('o'), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'H'), mapArt('H'), changePos(A, B1), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'Q'), mapArt('Q'), changePos(A, B1), map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'M'), mapArt('M'), changePos(A, B1),map, !.
a:- pos(A, B), B1 is (B - 1), map(A, B1, 'R'), mapArt('R'), changePos(A, B1), map, !.
a:- pos(A, B), B1 is (B - 1), mapArt('Left'), changePos(A, B1), map, !.


s:- pos(A, B), A1 is (A + 1), map(A1, B, '#'), mapArt('#'), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, _), myPlant(A1,B,Name,_,_,_,_), mapArtPlant(A1,B,Name), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, '='), mapArt('equal'), changePos(A1,B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'o'),  mapArt('o'), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'H'), mapArt('H'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'Q'), mapArt('Q'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'M'), mapArt('M'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), map(A1, B, 'R'), mapArt('R'), changePos(A1, B), map, !.
s:- pos(A, B), A1 is (A + 1), mapArt('Below'), changePos(A1, B), map, !.


d:- pos(A, B), B1 is (B + 1), map(A, B1, '#'), mapArt('#'), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, _), myPlant(A,B1,Name,_,_,_,_), mapArtPlant(A,B1,Name), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, '='), mapArt('equal'), changePos(A,B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'o'),  mapArt('o'), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'H'), mapArt('H'), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'Q'), mapArt('Q'), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'M'), mapArt('M'), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), map(A, B1, 'R'), mapArt('R'), changePos(A, B1), map, !.
d:- pos(A, B), B1 is (B + 1), mapArt('Right'), changePos(A, B1), map, !.

mapArt(Symbol):-
    format('~n-------------------------------------------------~n', []),
    printArrivedAt(Symbol),
    format('-------------------------------------------------~n~n', []).

mapArtPlant(A,B,Name):-
    format('~n-------------------------------------------------~n', []),
    format('         You\'ve arrived at ~w plant !~n', [Name]),
    write('     '),showInfoHarvest(A,B),
    format('-------------------------------------------------~n~n', []).

printArrivedAt(Symbol):-
    Symbol = '#' -> (
        write('          Oops, you\'ve hit a fence!\n')
    )
    ; 
    Symbol = 'Right' -> (
        write('            Moved one tile right!\n')
    )
    ;
    Symbol = 'Left' -> (
        write('            Moved one tile left!\n')
    )
    ;
    Symbol = 'Above' -> (
        write('            Moved one tile above!\n')
    )
    ;
    Symbol = 'Below' -> (
        write('            Moved one tile below!\n')
    )
    ;
    Symbol = 'o' -> (
        write('         You\'ve arrived at the Lake!\n'),
        write('              You can fish here.\n'),
        write('            Use command \'fish.\'...\n')
    )
    ;
    Symbol = 'H' -> (
        write('        You\'ve arrived at your House!\n'),
        write('  Use command \'house.\' to access your house...\n')
    )
    ;
    Symbol = 'Q' -> (
        write('       You\'ve arrived at the Quest Centre!\n'),
        write('           You can pick up quests here.\n'),
        write('             Use command \'quest\' ...\n')
    )
    ;
    Symbol = 'M' -> (
        write('      You\'ve arrived at the Marketplace!\n'),
        write('        You can buy or sell items here.\n'),
        write('            Use command \'market.\' ...\n')
    )
    ;
    Symbol = 'R' -> (
        write('         You\'ve arrived at the Ranch!\n'),
        write('   Use command \'ranch.\' to start ranching...\n')
    )
    ;
    Symbol = 'equal' -> (
        write('        You\'ve arrived at the digged tile!\n'),
        write('             You can plant seed here.\n'),
        write('    Use command \'dig.\' then \'plant.\' ...\n')
    )
    ,
    true.