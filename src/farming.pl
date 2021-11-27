% :-include('globals.pl').
% :-dynamic(seed/5).
% % seed(Name, Quantity, Alias, SymbolPLanted, SymbolHarvested, DayToHarvest)
% :-dynamic(myPlant/7).
% % myPlant(X,Y,Name,SymbolPlanted,SymbolHarvest,DayPlant,DayToHarvest)

% fakta untuk jenis bibit yang dapat ditanam
initSeed:-
    assertz(seed(tomato, 2, 't','T', 5)),
    assertz(seed(corn, 1, 'c', 'C', 6)),
    assertz(seed(carrot, 1, 'c', 'C', 3)),
    assertz(seed(potato, 1, 'p', 'P', 8)),
    assertz(farmEXP(exp, 0)),
    assertz(farmEXP(lvl, 1)),
    assertz(farmEXP(lvlUpReq, 75)).

% fakta untuk tanaman yang sedang ditanam
% myPlant(-1,-1,-1,-1,-1,-1,-1).

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
        map,
        occupation(O),
        O = 'farmer'  -> farmEXPUp(20) ; farmEXPUp(10)
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
        occupation(O),
        O = 'farmer'  -> farmEXPUp(40) ; farmEXPUp(25),
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

% untuk exp

farmEXPUp(EXP_Given):-
    % regular EXP
    farmEXP(exp, E), farmEXP(lvl, L), farmEXP(lvlUpReq, R),
    E1 is E + EXP_Given,
    E1 < R,
    retract(farmEXP(exp, E)),
    assertz(farmEXP(exp, E1)),
    write('\nYou gained '), write(EXP_Given), write(' Farm EXP!\n'),
    write('You are at level '), write(L), write('.\n'),
    write('EXP Status: '), write(E1), write('/'), write(R), write('\n'),
    !.

farmEXPUp(EXP_Given):-
    % level up
    farmEXP(exp, E), farmEXP(lvl, L), farmEXP(lvlUpReq, R),
    L1 is L + 1, E1 is E + EXP_Given,
    E1 >= R,
    E2 is E1 - R,
    R1 is R + 25,
    retract(farmEXP(lvl, L)),
    retract(farmEXP(exp, E)),
    retract(farmEXP(lvlUpReq, R)),
    assertz(farmEXP(lvl, L1)),
    assertz(farmEXP(exp, E2)),
    assertz(farmEXP(lvlUpReq, R1)),
    write('\nYou gained '), write(EXP_Given), write(' farm EXP!\n'),
    write('Level Up!\n'),
    write('Your farming experience is now at level '), write(L1), write('\n'),
    write('EXP Status: '), write(E2), write('/'), write(R1), write('\n'),
    farmLvlUpEffect,!.


% Efek level up, lama hari untuk melakukan aktivitas farming berkurang
farmLvlUpEffect:-
    farmEXP(lvl, Level),
    Level = 2 ->
        retract(seed(potato,_,_,_,8)),
        assertz(seed(potato,_,_,_,7))
    ; Level = 3 ->
        retract(seed(corn,_,_,_,6)),
        assertz(seed(corn,_,_,_,5))
    ; Level = 5 ->
        retract(seed(tomato,_,_,_,5)),
        retract(seed(corn,_,_,_,5)),
        retract(seed(potato,_,_,_,7)),
        assertz(seed(tomato,_,_,_,4)),
        assertz(seed(corn,_,_,_,4)),
        assertz(seed(potato,_,_,_,6))
    ; Level = 7 ->
        retract(seed(corn,_,_,_,4)),
        retract(seed(carrot,_,_,_,3)),
        retract(seed(potato,_,_,_,6)),
        assertz(seed(corn,_,_,_,3)),
        assertz(seed(carrot,_,_,_,2)),
        assertz(seed(potato,_,_,_,5))
    ; Level = 8 ->
        retract(seed(tomato,_,_,_,4)),
        assertz(seed(tomato,_,_,_,3))
    ; Level = 9 ->
        retract(seed(corn,_,_,_,3)),
        retract(seed(potato,_,_,_,5)),
        assertz(seed(corn,_,_,_,2)),
        assertz(seed(potato,_,_,_,4))
    ; Level = 10 ->
        retract(seed(tomato,_,_,_,3)),
        retract(seed(carrot,_,_,_,2)),
        retract(seed(potato,_,_,_,4)),
        assertz(seed(tomato,_,_,_,2)),
        assertz(seed(carrot,_,_,_,1)),
        assertz(seed(potato,_,_,_,3)),
    !.