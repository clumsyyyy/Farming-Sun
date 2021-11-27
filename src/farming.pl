:-include('globals.pl').
% :-dynamic(seed/5).
% % seed(Name, Quantity, Alias, SymbolPLanted, SymbolHarvested, DayToHarvest)
:-dynamic(myPlant/7).
% % myPlant(X,Y,Name,SymbolPlanted,SymbolHarvest,DayPlant,DayToHarvest)

% fakta untuk jenis bibit yang dapat ditanam
initSeed:-
    assertz(seed(tomato, 2, 't','T', 5)),
    assertz(seed(corn, 1, 'c', 'C', 6)),
    assertz(seed(carrot, 1, 'c', 'C', 3)),
    assertz(seed(potato, 1, 'p', 'P', 8)).

% fakta untuk tanaman yang sedang ditanam
myPlant(-1,-1,-1,-1,-1,-1,-1).

% command: dig
dig:-
/*  I.S. tanah yang akan digali kosong
    F.S. tanah digali, pemain dapat menanam di sana */
    pos(A,B),
    isTileEmpty(A,B) -> 
        item_in_inventory(shovel,_,1), %cek apakah pemain memiliki shovel 
        A1 is (A-1), 
        changePos(A1, B),
        assertz(map(A,B,'=')),
        write('You digged the tile!\nUse the command \'plant.\' to plant a seed!\n\n'),
        farmEXP(exp,Exp),
        occupation(O),
        (O = 'farmer'  -> ExpPlus is Exp+10 ; ExpPlus is Exp+5),
        retract(farmEXP(exp,Exp)),
        assertz(farmEXP(exp,ExpPlus)),
        map
    ;
        write('You can\'t dig here. Dig somewhere else.\n'),
    !.
    
plant:-
/*  I.S. tanah telah tergali, program menampilkan bibit yang dapat ditanamkan
    F.S. bibit akan ditanam, jumlah bibit diupdate, pemain dapat memanen
    di waktu yang ditentukan
*/
    pos(A,B),
    A1 is A+1,
    map(A1,B,Z),
    isTileDigged(A1,B) ->
        write('\nYou have:\n'),
        displaySeed,
        write('\nWhat do you want to plant?\n'),
        read(SelectSeed),
        seed(SelectSeed,Qty,SymP,SymH,DayToHarvest),
        format('You planted a ~w seed!~n',[SelectSeed]),
        retract(map(A1,B,Z)),
        assertz(map(A1,B,SymP)),
        QtyNew is Qty-1,
        retract(seed(SelectSeed,Qty,SymP,SymH,DayToHarvest)),
        day(Day),
        assertz(seed(SelectSeed,QtyNew,SymP,SymH,DayToHarvest)),
        %retract(myPlant(-1,-1,-1,-1,-1,-1,-1)),
        assertz(myPlant(A1,B,SelectSeed,SymP,SymH,Day,DayToHarvest)),
        format('The ~w can be harvested in ~d days...~n~n',[SelectSeed,DayToHarvest]),
        map
    ;
        isTilePlanted(A1,B) ->
            myPlant(A1,B,Name,_,_,_,DayToHarvest),
            format('This tile is already planted with ~w~n\n',[Name]),
            showInfoHarvest(A1,B)
        ;
            write('You can only plant on digged tile\n'),
    !.

grow(A,B,SymP,SymH,DayPlant,DayToHarvest):-
    day(Day),
    RemainingDay is DayToHarvest - Day + DayPlant,
    (RemainingDay = 0 ->
        retract(map(A,B,SymP)),
        assertz(map(A,B,SymH)); true);
    true.
        


harvest:-
/*  I.S. tile yang telah ditanamkan siap untuk dipanen
    F.S. tanaman berhasil dipanen, tile akan diubah ke status bisa digali */
    pos(A,B),
    A1 is A+1,
    timeToHarvest(A1,B,RemainingDay),
    map(A1,B,Z),
    myPlant(A1,B,Name,_,Z,_,_),
    RemainingDay =< 0 ->
        retract(map(A1,B,Z)),
        item_in_inventory(Name,_,Qty),
        QtyPlus is Qty+1,
        retract(item_in_inventory(Name,_,Qty)),
        assertz(item_in_inventory(Name,_,QtyPlus)),
        format('Yay, you successfully harvested a ~w~n!',[Name]),
        write('It has been added to your inventory.\n\n'),
        farmEXP(exp,Exp),
        occupation(O),
        (O = farmer  -> ExpPlus is Exp+10 ; ExpPlus is Exp+5),
        retract(farmEXP(exp,Exp)),
        assertz(farmEXP(exp,ExpPlus)),
        doHarvest
    ;   
        write('You cannot harvest this plant yet.\n'),
        showInfoHarvest(A1,B),
    !.

displaySeed:-
/* Menampilkan bibit yang dapat ditanamkan */
    forall(seed(Name, Qty,_,_,_), printSeed(Name, Qty)).

printSeed(Name, Qty):-
    Qty > 0 ->
        format('- ~d ~w seed~n',[Qty, Name])
    ;
        true.

isTilePlanted(A,B):- % mengecek ada tanaman atau tidak
    myPlant(A,B,_,_,_,_,_).

timeToHarvest(A,B,RemainingDay):- % mengembalikan sisa hari untuk panen
    map(A,B,_),
    myPlant(A,B,_,_,_,DayPlant,DayToHarvest),
    day(Day),
    RemainingDay is DayToHarvest - Day + DayPlant.

showInfoHarvest(A,B):-
    myPlant(A,B,Name,_,_,_,_),
    timeToHarvest(A,B,RemainingDay),
    format('~w can be harvested in ~d days~n',[Name,RemainingDay]).

isTileDigged(A,B):-
    map(A,B,'=').

isTileEmpty(A,B):-
    A1 is A-1,
    A2 is A+1,
    \+map(A1,B,_),   % di belakang
    \+map(A2,B,'='), % di depan
    \+isTilePlanted(A2,B),
    \+map(A,B,_).    % yang dipijak
