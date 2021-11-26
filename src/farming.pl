:-include('globals.pl').
:-dynamic(seed/6).
% seed(Name, Quantity, Alias, SymbolPLanted, SymbolHarvested, HarvestDay).
:-dynamic(myplant/8).
% myplant(X,Y,Name,Alias,SymbolPlanted,SymbolHarvest,DayPlant,HarvestDay)

% fakta untuk jenis bibit yang dapat ditanam
seed(tomato, 2, 'tomato', 't','T',3).
seed(corn, 1, 'corn', 'c','C',2).

% command: dig
dig:-
/*  I.S. tanah yang akan digali kosong
    F.S. tanah digali, pemain dapat menanam di sana */
    isTileEmpty, %cek terlebih dahulu apakah tile kosong
    item_in_inventory(shovel,_,1), %cek apakah pemain memiliki shovel
    pos(A, B), 
    A1 is (A - 1), 
    changePos(A1, B),
    assertz(map(A,B,'=')),
    write('You digged the tile\n'),
    retract(farmEXP(exp,Exp)),
    ExpPlus is Exp+10, 
    assertz(farmEXP(exp,ExpPlus)),
    map, 
    !.

dig:-
    \+isTileEmpty,
    write('You can\'t dig here. Dig somewhere else.\n'),!.


% command: plant
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
    day(DayPlant),
    assertz(myplant(X1,Y,Selectseed,Alias,SymP,SymH,DayPlant,TimeH)),
    format('~w can be harvested in ~d days~n',[Alias,TimeH]),
    map,
    !.

plant:-
    \+isTileDigged,
    write('You can only plant on digged tile\n'),!.

plant:-
    isTilePlanted,
    format('This tile is already planted~n'),!.

plant:-
    isTileReadyToHarvest,
    format('This tile is ready to Harvest~n'),!.

% command: harvest
harvest:-
/*  I.S. tile yang telah ditanamkan siap untuk dipanen
    F.S. tanaman berhasil dipanen, tile akan diubah ke status bisa digali */
    isTileReadyToHarvest,
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    myplant(X1,Y,Name,Alias,_,Z,_,_),
    retract(map(X1,Y,Z)),
    assertz(map(X1,Y,' ')),
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

plantedTilePos(X,Y):-
/* Mengembalikan posisi tile yang telah ditanam */
    myplant(X,Y,_,_,_,_,_,RemainingTimeHarvest),
    RemainingTimeHarvest > 0.

isTileReadyToHarvest:-
/* Mengecek apakah ada yang siap dipanen di tile */
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    myplant(X1,Y,_,_,_,Z,_,_).

readyToHarvestTilePos(X,Y):-
/* Mengembalikan posisi tile yang siap dipanen */
    myplant(X,Y,_,_,_,_,_,RemainingTimeHarvest),
    RemainingTimeHarvest = 0. 

isTileDigged:-
/* Mengecek apakah tile telah digali */
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,'=').

isTileEmpty:-
/* Mengecek apakah tile kosong 
   Jika player berada di posisi (X,Y)
   maka (X+1,Y) tidak boleh tanaman dan (X-1,Y) harus kosong
*/
    pos(X,Y),
    X1 is X-1,
    X2 is X+1,
    (myplant(X2,Y,_,_,_,_,_,_)) -> false; true,
    \+map(X1,Y,_),
    \+map(X2,Y,'='),
    \+map(X,Y,_).