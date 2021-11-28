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
            Gold is H*300+F*100+R*250,
            EXP is H*25+F*25+R*25,
            retract(rewardquest(_,_)),
            assertz(rewardquest(Gold,EXP)),
            write('_______________________________\n'),
            write('|                             |\n'),
            write('|   ( ( THE QUEST BOARD ) )   |\n'),
            write('|                             |\n'),
            write('|     You got a new quest!    |\n'),
            write('|                             |\n'),
            write('|     You need to collect:    |\n'),
            format('|   - ~d harvest item          |~n',[H]),
            format('|   - ~d fish                  |~n',[F]),
            format('|   - ~d ranch item            |~n',[R]),
            format('|                             |~n', []),
            format('| Here, bring ANNA with you!  |~n', []),
            format('| (use quest. to use ANNA)    |~n', []),
            format('|                             |~n', []),
            format('===============================~n', []),
            format('Reward on completion:   ~n', []),
            format('~d GOLD and ~d EXP!      ~n', [Gold, EXP])
        )
        ;
        \+isNotInQuest, \+isQuestClear -> (
        /* Apabila sedang mengerjakan quest dan quest belum selesai*/
            myquest(Hi,Hf,Fi,Ff,Ri,Rf),
            H is Hi-Hf,
            F is Fi-Ff,
            R is Ri-Rf,
            rewardquest(Gold,EXP),
            format('_________________________________________________~n', []),
            format('[                                               ]~n', []),
            format('[   Hello, I am Anna. ^_^         [v0.2.1]      ]~n', []),
            format('[  (Automated Natural Navigation Assistant)     ]~n', []),
            format('[                                               ]~n', []),
            format('[ You currently have an on-going quest.         ]~n', []),
            format('[ Your quest progress status:                   ]~n', []),
            format('[ - ~d/~d harvest item collected                  ]~n',[H,Hi]),
            format('[ - ~d/~d fish collected                          ]~n',[F,Fi]),
            format('[ - ~d/~d ranch item collected                    ]~n',[R,Ri]),
            format('[_______________________________________________]~n~n', []),
            format('Reward on completion:  ~n ~d Gold - ~d EXP ~n',[Gold,EXP]),
            format('Whenever you\'ve finished the tasks, you can~n use me again using \'quest.\'~n', [])
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
            format('_________________________________________________~n', []),
            format('[                                               ]~n', []),
            format('[   Hello, I am Anna. ^_^          [v0.2.1]     ]~n', []),
            format('[  (Automated Natural Navigation Assistant)     ]~n', []),
            format('[                                               ]~n', []),
            format('[ Congratulations, you have finished the quests.]~n', []),
            format('[ The rewards have been added to your accounts. ]~n', []),
            format('[ I wish you well for your next adventures.     ]~n', []),
            format('[                                               ]~n', []),
            format('[_______________________________________________]~n~n', []),
            write('You have completed the quest, Here is the reward: \n'),
            format('~d Gold - ~d EXP~n',[Gold,EXP]),
            write('Reward has been added. Your current status: \n'),
            format('Gold: ~d~n',[Gplus]),
            format('EXP : ~d~n',[Eplus]),
            checkGameState,
            retract(myquest(_,_,_,_,_,_)),
            assertz(myquest(-1,-1,-1,-1,-1,-1)),
            retract(rewardquest(_,_)),
            assertz(rewardquest(-1,-1))
        )
        ;
        \+isOnTileQ -> (
        /* Apabila tidak berada di tile Q*/
            format('_________________________________________________~n', []),
            format('[                                               ]~n', []),
            format('[   Hello, I am Anna. ^_^          [v0.2.1]     ]~n', []),
            format('[  (Automated Natural Navigation Assistant)     ]~n', []),
            format('[                                               ]~n', []),
            format('[ I am here to inform you that you have not     ]~n', []),
            format('[ picked up any quests. You can pick new ones   ]~n', []),
            format('[ You can go to the Quest Board (\'Q\') to        ]~n', []),
            format('[ take new quests.                              ]~n', []),
            format('[_______________________________________________]~n~n', [])
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

doRanch(Qty):-
/* Jika sedang mengerjakan quest, maka komponen quest untuk ranch berkurang 1*/
    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
    Rf > 0,
    Rfx is Rf-Qty,
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
    myquest(_,X,_,Y,_,Z),
    X =< 0, Y =< 0, Z =< 0.
