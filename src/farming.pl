:-include('globals.pl').
:-dynamic(seed/6).
:-dynamic(myplant/8).

% fakta untuk jenis bibit yang dapat ditanam
seed(tomato, 2, 'tomato', 't','T',3).
seed(corn, 1, 'corn', 'c','C',2).


dig:-
/*  I.S. tanah yang akan digali kosong
    F.S. tanah digali, pemain dapat menanam di sana */
    isTileEmpty,
    pos(A, B), 
    A1 is (A - 1), 
    changePos(A1, B),
    assertz(map(A,B,'=')),
    write('You digged the tile\n'),
    map, 
    !.

dig:-
    \+isTileEmpty,
    write('You can\'t dig here. Dig somewhere else.\n'),!.

plant:-
/*  I.S. tanah telah tergali, program menampilkan bibit yang dapat ditanamkan
    F.S. bibit akan ditanam, jumlah bibit diupdate, pemain dapat memanen
    di waktu yang ditentukan
*/
    isTileDigged,
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    write('\nYou have:\n'),
    displaySeed,
    write('\nWhat do you want to plant?\n'),
    read(Selectseed),
    seed(Selectseed,Qty,Alias,SymP,SymH,TimeH),
    format('You planted a ~w seed~n',[Alias]),
    retract(map(X1,Y,Z)),
    assertz(map(X1,Y,SymP)),
    QtyNew is Qty-1,
    retract(seed(Selectseed,Qty,Alias,SymP,SymH,TimeH)),
    assertz(seed(Selectseed,QtyNew,Alias,SymP,SymH,TimeH)),
    assertz(myplant(X1,Y,Selectseed,Alias,SymP,SymH,TimeH,TimeH)),
    format('~w can be harvested in ~d days~n',[Alias,TimeH]),
    map,
    !.

plant:-
    \+isTileDigged,
    \+isTilePlanted,
    write('You can only plant on digged tile\n'),!.

plant:-
    isTilePlanted,
    format('This tile is already planted~n'),!.

plant:-
    isTileReadyToHarvest,
    format('This tile is ready to Harvest~n'),!.

harvest:-
/*  I.S. tile yang telah ditanamkan siap untuk dipanen
    F.S. tanaman berhasil dipanen, tile akan diubah ke status bisa digali */
    isTileReadyToHarvest,
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    myplant(X1,Y,Name,Alias,_,Z,_,_),
    retract(map(X1,Y,Z)),
    assertz(map(X1,Y,_)),
    item(Name,_,Qty),
    QtyNew is Qty+1,
    retract(Name,_,Qty),
    assertz(Name,_,QtyNew),
    format('You harvested ~w~n',[Alias]),
    doHarvest,!.

displaySeed:-
/* Menampilkan bibit yang dapat ditanamkan */
    forall(seed(Name, Qty,_,_,_,_), print_seed(Name, Qty)).

print_seed(Name, Qty):-
    (
    Qty > 0 ->
        format('- ~d ~w seed~n',[Qty, Name]);
    true
    ).

isTilePlanted:-
/* Mengecek apakah ada yang ditanam di tile */
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    myplant(X1,Y,_,_,Z,_,_,_).

isTileReadyToHarvest:-
/* Mengecek apakah ada yang siap dipanen di tile */
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    myplant(X1,Y,_,_,_,Z,_,_).

isTileDigged:-
/* Mengecek apakah tile telah digali */
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,'=').

isTileEmpty:-
/* Mengecek apakah tile kosong */
    pos(X,Y),
    X1 is X-1,
    X2 is X+1,
    \+map(X1,Y,_),
    \+map(X2,Y,'='),
    \+map(X,Y,_).


    