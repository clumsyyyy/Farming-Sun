:- include('globals.pl').
:- dynamic(myquest/6). 
:- dynamic(rewardquest/2).
myquest(-1,-1,-1,-1,-1,-1).
rewardquest(-1,-1).
quest:-
    isNotInQuest,
    isOnTileQ,
    random(1,10,H),
    random(1,10,F),
    random(1,10,R),
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(H,H,F,F,R,R)),
    Gold is H*10+F*10+R*10,
    EXP is H*25+F*25+R*25,
    retract(rewardquest(_,_)),
    assertz(rewardquest(Gold,EXP)),
    write('You got a new quest!\n'),
    write('\nYou need to collect: \n'),
    format('- ~d harvest item~n',[H]),
    format('- ~d fish~n',[F]),
    format('- ~d ranch item~n',[R]),
    format('Reward on completion: ~d Gold - ~d EXP ~n',[Gold,EXP]),!.

quest:-
    \+isNotInQuest,
    \+isQuestClear,
    isOnTileQ,
    write('You have an on-going quest!\n'),
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    H is Hi-Hf,
    F is Fi-Ff,
    R is Ri-Rf,
    rewardquest(Gold,EXP),
    write('\nYour quest progress status:\n'),
    format('- ~d/~d harvest item collected~n',[H,Hi]),
    format('- ~d/~d fish collected~n',[F,Fi]),
    format('- ~d/~d ranch item collected~n',[R,Ri]),
    format('Reward on completion: ~d Gold - ~d EXP ~n',[Gold,EXP]),!.

quest:-
    isQuestClear,
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(-1,-1,-1,-1,-1,-1)),
    rewardquest(Gold,EXP),
    gold(G),
    exp(E),
    Gplus is G+Gold,
    Eplus is E+EXP,
    retract(gold(_)),
    retract(exp(_)),
    assertz(gold(Gplus)),
    assertz(gold(Eplus)),
    write('You have completed the quest, Here is the reward: \n'),
    format('~d Gold - ~d EXP~n',[Gold,EXP]),
    write('Reward has been added. Your current status: \n'),
    format('Gold: ~d~n',[Gplus]),
    format('EXP : ~d~n',[Eplus]),
    retract(rewardquest(_,_)),
    assertz(rewardquest(-1,-1)),!.

quest:-
    \+isOnTileQ,
    write('You are not in tile Q!\n'),!.

doHarvest:-
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    Hf > 0,
    Hfx is Hf-1,
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(Hi,Hfx,Fi,Ff,Ri,Rf)),!;true.
    

doFish:-
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    Ff > 0,
    Ffx is Ff-1,
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(Hi,Hf,Fi,Ffx,Ri,Rf)),!;true.

doRanch:-
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    Rf > 0,
    Rfx is Rf-1,
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(Hi,Hf,Fi,Ff,Ri,Rfx)),!;true.

isNotInQuest:-
    myquest(X,X,X,X,X,X),
    X = -1.

isOnTileQ:-
    pos(X, Y), map(X, Y, 'Q').

isQuestClear:-
    \+isNotInQuest,
    myquest(_,X,_,X,_,X),
    X = 0.



    

