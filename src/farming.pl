:-include('globals.pl').

initFarm:-
/* Menginisialisasi predikat-predikat yang digunakan untuk aktivitas Farming */
    % seed(Name, Quantity, Alias, SymbolPLanted, SymbolHarvested, DayToHarvest)
    assertz(seed(tomato, 2, 't','T', 5)),
    assertz(seed(corn, 1, 'c', 'C', 6)),
    assertz(seed(carrot, 1, 'c', 'C', 3)),
    assertz(seed(potato, 1, 'p', 'P', 8)),
    % myPlant(A,B,Name,SymbolPlanted,SymbolHarvest,DayPlant,DayToHarvest)
    assertz(myPlant(-1,-1,-1,-1,-1,-1,-1)),
    % farmEXP(Component,Value)
    assertz(farmEXP(exp, 0)),
    assertz(farmEXP(lvl, 1)),
    assertz(farmEXP(lvlUpReq, 75)).
    
% ======= Predikat utama ======== %
dig:-
/*  I.S. tanah yang akan digali kosong
    F.S. tanah digali, pemain dapat menanam di sana */
    pos(A,B),
    ( 
        isTileEmpty(A,B) -> (
            item_in_inventory(shovel,_,1), %cek apakah pemain memiliki shovel 
            A1 is (A-1), 
            changePos(A1, B),
            assertz(map(A,B,'=')),
            write('\n'),
            write('\nYou digged the tile!\nUse the command \'plant.\' to plant a seed!\n\n'),
            occupation(O),
            (O = 'farmer'  -> farmEXPUp(10) ; farmEXPUp(5)),
            map
        )
        ;
        write('You can\'t dig here. Dig somewhere else.\n')
    ),
    !.
    
plant:-
/*  I.S. tanah telah tergali, program menampilkan bibit yang dapat ditanamkan
    F.S. bibit akan ditanam, jumlah bibit diupdate, pemain dapat memanen
    di waktu yang ditentukan */
    pos(A,B),
    A1 is A+1,
    ( 
        isTileDigged(A1,B) -> (
            map(A1,B,Z),
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
            (retract(myPlant(-1,-1,-1,-1,-1,-1,-1)) -> true ; true),
            assertz(myPlant(A1,B,SelectSeed,SymP,SymH,Day,DayToHarvest)),
            format('The ~w can be harvested in ~d days...~n~n',[SelectSeed,DayToHarvest]),
            map
        )
        ; 
        isTilePlanted(A1,B) -> (
            myPlant(A1,B,Name,_,_,_,DayToHarvest),
            format('This tile is already planted with ~w~n',[Name]),
            showInfoHarvest(A1,B)
        )
        ;
        write('You can only plant on digged tile\n')
    ),
    !.
        
harvest:-
/*  I.S. tile yang telah ditanamkan siap untuk dipanen
    F.S. tanaman berhasil dipanen, tile akan diubah ke status bisa digali */
    pos(A,B),
    A1 is A+1,
    timeToHarvest(A1,B,RemainingDay),
    map(A1,B,Z),
    myPlant(A1,B,Name,_,_,_,_),
    ( 
        RemainingDay =< 0 -> (
            retract(map(A1,B,Z)),
            item_in_inventory(Name,_,Qty),
            QtyPlus is Qty+1,
            retract(item_in_inventory(Name,_,Qty)),
            assertz(item_in_inventory(Name,_,QtyPlus)),
            format('Yay, you successfully harvested a ~w!~n',[Name]),
            write('It has been added to your inventory.\n'),
            occupation(O),
            (O = 'farmer'  -> farmEXPUp(40) ; farmEXPUp(25)),
            doHarvest
        )
        ; ( 
            write('You cannot harvest this plant yet.\n'),
            showInfoHarvest(A1,B)
        )
    ),
    !.

% ======= Predikat pembantu ======== %

isTileEmpty(A,B):-
/* Mengecek apakah tile kosong dan dapat digali */
    A1 is A-1,
    A2 is A+1,
    \+map(A1,B,_),   % di belakang
    \+map(A2,B,'='), % di depan
    \+isTilePlanted(A2,B),
    \+map(A,B,_).    % yang dipijak

isTilePlanted(A,B):-
/* Mengecek apakah tile berisi tanaman atau tidak*/
    myPlant(A,B,_,_,_,_,_).
    
isTileDigged(A,B):-
/* Mengecek apakah tile sudah digali atau belum*/
    map(A,B,'=').

displaySeed:-
/* Menampilkan bibit yang dapat ditanamkan */
    forall(seed(Name, Qty,_,_,_), ( 
        Qty > 0 ->  format('- ~d ~w seed~n',[Qty, Name]) ;  true
    )).


timeToHarvest(A,B,RemainingDay):-
/* Menerima informasi lokasi tanaman
   Mengembalikan nilai berapa hari lagi tanaman siap dipanen */
    map(A,B,_),
    myPlant(A,B,_,_,_,DayPlant,DayToHarvest),
    day(Day),
    RemainingDay is DayToHarvest - Day + DayPlant.

showInfoHarvest(A,B):-
/* Menerima informasi lokasi tanaman
   Memberikan informasi status tanaman */
    myPlant(A,B,Name,_,_,_,_),
    timeToHarvest(A,B,RemainingDay),
    (
        RemainingDay > 0 -> 
            format('~w can be harvested in ~d days~n',[Name,RemainingDay])
        ; %else remainingday <= 0
            format('~w is ready to be harvested~n',[Name])
    ),
    !.

grow(A,B,SymP,SymH,DayPlant,DayToHarvest):-
/* Memperbarui status tanaman (tanaman bertumbuh)*/
    day(Day),
    RemainingDay is DayToHarvest - Day + DayPlant,
    (
        RemainingDay = 0 -> (
            retract(map(A,B,SymP)),
            assertz(map(A,B,SymH))
        )
        ; 
        true
    )
    ;
    true.

farmEXPUp(EXPGiven):-
/* Melakukan prosedur untuk menaikkan EXP*/
    farmEXP(exp, E), farmEXP(lvl, L), farmEXP(lvlUpReq, R),
    E1 is E + EXPGiven,
    (
        E1 < R -> (
            retract(farmEXP(exp, E)),
            assertz(farmEXP(exp, E1)),
            format('~nYou gained ~d farm EXP!~n',[EXPGiven]),
            format('You are at level ~d.~n',[L]),
            format('EXP Status ~d/~d~n',[E1,R])
        )
        ; % else : E1 >= R
        (
            L1 is L + 1,
            E2 is E1 - R,
            R1 is R + 25,
            retract(farmEXP(lvl, L)),
            retract(farmEXP(exp, E)),
            retract(farmEXP(lvlUpReq, R)),
            assertz(farmEXP(lvl, L1)),
            assertz(farmEXP(exp, E2)),
            assertz(farmEXP(lvlUpReq, R1)),
            format('~nYou gained ~d farm EXP!~n',[EXPGiven]),
            write('Level Up!\n'),
            format('Your farming experience is now at level ~d~n', [L1]),
            format('EXP Status ~d/~d~n',[E2,R1]),
            farmLvlUpEffect
        )
    ),
    !.

farmLvlUpEffect:-
/* Menerapkan efek dari kenaikan level farming */
    farmEXP(lvl, Level),
    (
        Level = 2 -> (
            retract(seed(potato,Qty,SymP,SymH,8)),
            assertz(seed(potato,Qty,SymP,SymH,7))
        )
        ; Level = 3 -> (
            retract(seed(corn,Qty,SymP,SymH,6)),
            assertz(seed(corn,Qty,SymP,SymH,5))
        )
        ; Level = 5 -> (
            retract(seed(tomato,Qty1,SymP1,SymH1,5)),
            retract(seed(corn,Qty2,SymP2,SymH2,5)),
            retract(seed(potato,Qty3,SymP3,SymH3,7)),
            assertz(seed(tomato,Qty1,SymP1,SymH1,4)),
            assertz(seed(corn,Qty2,SymP2,SymH2,4)),
            assertz(seed(potato,Qty3,SymP3,SymH3,6))
        )
        ; Level = 7 -> (   
            retract(seed(corn,Qty1,SymP1,SymH1,4)),
            retract(seed(carrot,Qty2,SymP2,SymH2,3)),
            retract(seed(potato,Qty3,SymP3,SymH3,6)),
            assertz(seed(corn,Qty1,SymP1,SymH1,3)),
            assertz(seed(carrot,Qty2,SymP2,SymH2,2)),
            assertz(seed(potato,Qty3,SymP3,SymH3,5))
        )
        ; Level = 8 -> (
            retract(seed(tomato,Qty,SymP,SymH,4)),
            assertz(seed(tomato,Qty,SymP,SymH,3))
        )
        ; Level = 9 -> (
            retract(seed(corn,Qty1,SymP1,SymH1,3)),
            retract(seed(potato,Qty2,SymP2,SymH2,5)),
            assertz(seed(corn,Qty1,SymP1,SymH1,2)),
            assertz(seed(potato,Qty2,SymP2,SymH2,4))
        )
        ; Level = 10 -> (
            retract(seed(tomato,Qty1,SymP1,SymH1,3)),
            retract(seed(carrot,Qty2,SymP2,SymH2,2)),
            retract(seed(potato,Qty3,SymP3,SymH3,4)),
            assertz(seed(tomato,Qty1,SymP1,SymH1,2)),
            assertz(seed(carrot,Qty2,SymP2,SymH2,1)),
            assertz(seed(potato,Qty3,SymP3,SymH3,3))
        )
    ),
    !.
