:- include('globals.pl').

initQuest:-
/* Menginisiasi predikat-predikat yang dibutuhkan untuk quest*/
    assertz(myquest(-1,-1,-1,-1,-1,-1)),
    assertz(rewardquest(-1,-1)).

%======== Predikat utama =========%

quest:-
    (
        isOnTileQ, isNotInQuest -> (
        /* Apabila berada di tile Q dan belum memulai quest*/ 
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
            format('Reward on completion: ~d Gold - ~d EXP ~n',[Gold,EXP])
        )
        ;
        \+isNotInQuest, \+isQuestClear -> (
        /* Apabila sedang mengerjakan quest dan quest belum selesai*/
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
            format('Reward on completion: ~d Gold - ~d EXP ~n',[Gold,EXP])
        )
        ;
        isQuestClear -> (
        /* Apabila quest telah selesai*/
            isQuestClear,
            rewardquest(Gold,EXP),
            gold(G),
            exp(E),
            Gplus is G+Gold,
            Eplus is E+EXP,
            retract(gold(G)),
            retract(exp(E)),
            assertz(gold(Gplus)),
            assertz(exp(Eplus)),
            write('You have completed the quest, Here is the reward: \n'),
            format('~d Gold - ~d EXP~n',[Gold,EXP]),
            write('Reward has been added. Your current status: \n'),
            format('Gold: ~d~n',[Gplus]),
            format('EXP : ~d~n',[Eplus]),
            retract(myquest(_,_,_,_,_,_)),
            assertz(myquest(-1,-1,-1,-1,-1,-1)),
            retract(rewardquest(_,_)),
            assertz(rewardquest(-1,-1))
        )
        ;
        \+isOnTileQ -> (
        /* Apabila tidak berada di tile Q*/
            write('You are not in tile Q!\n')
        )
    ),
    !.


%======== Predikat pembantu =========%

doHarvest:-
/* Jika sedang mengerjakan quest, maka komponen quest untuk harvest berkurang 1*/
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    Hf > 0,
    Hfx is Hf-1,
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(Hi,Hfx,Fi,Ff,Ri,Rf)),!;true.
    
doFish:-
/* Jika sedang mengerjakan quest, maka komponen quest untuk fish berkurang 1*/
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    Ff > 0,
    Ffx is Ff-1,
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(Hi,Hf,Fi,Ffx,Ri,Rf)),!;true.

doRanch:-
/* Jika sedang mengerjakan quest, maka komponen quest untuk ranch berkurang 1*/
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    Rf > 0,
    Rfx is Rf-1,
    retract(myquest(_,_,_,_,_,_)),
    assertz(myquest(Hi,Hf,Fi,Ff,Ri,Rfx)),!;true.

isNotInQuest:-
/* Mengecek apakah sedang berada dalam quest atau tidak*/
    myquest(X,X,X,X,X,X),
    X =:= -1.

isOnTileQ:-
/* Mengecek apakah sedang berada di tile Q atau tidak*/
    pos(X, Y), map(X, Y, 'Q').

isQuestClear:-
/* Mengecek apakah telah menyelesaikan quest*/
    \+isNotInQuest,
    myquest(_,X,_,X,_,X),
    X =:= 0.
