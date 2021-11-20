:-include('globals.pl').
:-dynamic(seed/6).
:-dynamic(myseed/2).
:-dynamic(myplant/8).

seed(tomato, 2, 'tomato', 't','T',3).
seed(corn, 1, 'corn', 'c','C',2).


dig:-
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
    write('You can only plant in digged tile\n').

plant:-
    isTilePlanted,
    format('This tile is already planted~n'),!.

plant:-
    isTileReadyToHarvest,
    format('This tile is ready to Harvest~n'),!.

harvest:-
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
    forall(seed(Name, Qty,_,_,_,_), print_seed(Name, Qty)).

print_seed(Name, Qty):-
    (
    Qty > 0 ->
        format('- ~d ~w seed~n',[Qty, Name]);
    true
    ).

isTilePlanted:-
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    myplant(X1,Y,_,_,Z,_,_,_).

isTileReadyToHarvest:-
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,Z),
    myplant(X1,Y,_,_,_,Z,_,_).

isTileDigged:-
    pos(X,Y),
    X1 is X+1,
    map(X1,Y,'=').

isTileEmpty:-
    pos(X,Y),
    X1 is X-1,
    X2 is X+1,
    \+map(X1,Y,_),
    \+map(X2,Y,'='),
    \+map(X,Y,_).


    