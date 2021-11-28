:-include('globals.pl').

initFarm:-
/* Menginisialisasi predikat-predikat yang digunakan untuk aktivitas Farming */
    % seed(SeedName, Product, PlantName, SymbolPLanted, SymbolHarvested, DayToHarvest)
    % definisi untuk seed
    assertz(seed(tomato_seed, tomato, 't','T', 5)),
    assertz(seed(corn_seed, corn, 'c', 'C', 6)),
    assertz(seed(carrot_seed, carrot, 'c', 'C', 3)),
    assertz(seed(potato_seed,potato, 'p', 'P', 8)),
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
            item_in_inventory(shovel,ShovelExp,1), %cek apakah pemain memiliki shovel
            EXPGiven is 10*ShovelExp,
            assertz(map(A,B,'=')),
            write('\n'),
            write('\nYou digged the tile!\nUse the command \'plant.\' to plant a seed!\n\n'),
            occupation(O),
            (
                O = 'farmer'  -> (
                    EXPGiven1 is EXPGiven+10,
                    farmEXPUp(EXPGiven1)
                 ) 
                 ; 
                 (
                     EXPGiven1 is EXPGiven+5,
                     farmEXPUp(5)
                 )
            ),
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
    ( 
        isTileDigged(A,B) -> (
            map(A,B,Z),
            write('\nYou have:\n'),
            displaySeed,
            write('\nWhat do you want to plant?\n'),
            read(SelectSeed),
            seed(SeedName,SelectSeed,SymP,SymH,DayToHarvest),
            item_in_inventory(SeedName,Level,Qty),
            Qty > 0,
            format('You planted a ~w seed!~n',[SelectSeed]),
            retract(map(A,B,Z)),
            assertz(map(A,B,SymP)),
            QtyNew is Qty-1,
            retract(item_in_inventory(SeedName,Level,Qty)),
            day(Day),
            assertz(item_in_inventory(SeedName,Level,QtyNew)),
            (retract(myPlant(-1,-1,-1,-1,-1,-1,-1)) -> true ; true),
            assertz(myPlant(A,B,SelectSeed,SymP,SymH,Day,DayToHarvest)),
            format('The ~w can be harvested in ~d days...~n~n',[SelectSeed,DayToHarvest]),
            map
        )
        ; 
        isTilePlanted(A,B) -> (
            myPlant(A,B,Name,_,_,_,DayToHarvest),
            format('This tile is already planted with ~w~n',[Name]),
            showInfoHarvest(A,B)
        )
        ;
        write('You can only plant on digged tile\n')
    ),
    !.
        
harvest:-
/*  I.S. tile yang telah ditanamkan siap untuk dipanen
    F.S. tanaman berhasil dipanen, tile akan diubah ke status bisa digali */
    pos(A,B),
    timeToHarvest(A1,B,RemainingDay),
    map(A,B,Z),
    myPlant(A,B,Name,_,_,_,_),
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
            myquest(Hi,Hf,Fi,Ff,Ri,Rf),
            Hf > 0,
            Hfx is Hf-1,
            retract(myquest(_,_,_,_,_,_)),
            assertz(myquest(Hi,Hfx,Fi,Ff,Ri,Rf)),!;true
        )
        ; ( 
            write('You cannot harvest this plant yet.\n'),
            showInfoHarvest(A,B)
        )
    ),
    !.

% ======= Predikat pembantu ======== %

isTileEmpty(A,B):-
/* Mengecek apakah tile kosong dan dapat digali */
    \+map(A,B,_).    % yang dipijak

isTilePlanted(A,B):-
/* Mengecek apakah tile berisi tanaman atau tidak*/
    myPlant(A,B,_,_,_,_,_).
    
isTileDigged(A,B):-
/* Mengecek apakah tile sudah digali atau belum*/
    map(A,B,'=').

displaySeed:-
/* Menampilkan bibit yang dapat ditanamkan */
    forall(seed(SeedName, Product,_,_,_), ( 
        item_in_inventory(SeedName, _, Qty),
        (Qty > 0 ->  format('- ~d ~w seed~n',[Qty, Product]) ;  true)
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
            format('The ~w can be harvested in ~d days~n',[Name,RemainingDay])
        ; %else remainingday <= 0
            format('The ~w is ready to be harvested~n',[Name])
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
            retract(seed(SeedName,tomato,SymP,SymH,8)),
            assertz(seed(SeedName,tomato,SymP,SymH,7))
        )
        ; Level = 3 -> (
            retract(seed(SeedName,corn,SymP,SymH,6)),
            assertz(seed(SeedName,corn,SymP,SymH,5))
        )
        ; Level = 5 -> (
            retract(seed(SeedName1,tomato,SymP1,SymH1,5)),
            retract(seed(SeedName2,corn,SymP2,SymH2,5)),
            retract(seed(SeedName3,potato,SymP3,SymH3,7)),
            assertz(seed(SeedName1,tomato,SymP1,SymH1,4)),
            assertz(seed(SeedName2,corn,SymP2,SymH2,4)),
            assertz(seed(SeedName3,potato,SymP3,SymH3,6))
        )
        ; Level = 7 -> (   
            retract(seed(SeedName1,corn,SymP1,SymH1,4)),
            retract(seed(SeedName2,carrot,SymP2,SymH2,3)),
            retract(seed(SeedName3,potato,SymP3,SymH3,6)),
            assertz(seed(SeedName1,corn,SymP1,SymH1,3)),
            assertz(seed(SeedName2,carrot,SymP2,SymH2,2)),
            assertz(seed(SeedName3,potato,SymP3,SymH3,5))
        )
        ; Level = 8 -> (
            retract(seed(SeedName,tomato,SymP,SymH,4)),
            assertz(seed(SeedName,tomato,SymP,SymH,3))
        )
        ; Level = 9 -> (
            retract(seed(SeedName1,corn,SymP1,SymH1,3)),
            retract(seed(SeedName2,potato,SymP2,SymH2,5)),
            assertz(seed(SeedName1,corn,SymP1,SymH1,2)),
            assertz(seed(SeedName2,potato,SymP2,SymH2,4))
        )
        ; Level = 10 -> (
            retract(seed(SeedName1,tomato,SymP1,SymH1,3)),
            retract(seed(SeedName2,carrot,SymP2,SymH2,2)),
            retract(seed(SeedName3,potato,SymP3,SymH3,4)),
            assertz(seed(SeedName1,tomato,SymP1,SymH1,2)),
            assertz(seed(SeedName2,carrot,SymP2,SymH2,1)),
            assertz(seed(SeedName3,potato,SymP3,SymH3,3))
        )
    ),
    !.
