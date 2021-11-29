%kemungkinan rating ikan
:- include('items.pl').
:- dynamic(rateFishing_SSR/1).
:- dynamic(rateFishing_SR/1).
:- dynamic(rateFishing_R/1).
:- dynamic(rateFishing_C/1).    
 % level up when 300, next level + 100

expGain_SSR(250).
expGain_SR(100).
expGain_R(40).
expGain_C(20).
rateFishing_SSR_base(0.03).
rateFishing_SR_base(0.2).
rateFishing_R_base(10).
rateFishing_C_base(30).
rateFishing_SSR_multibase(0.01).
rateFishing_SR_multibase(0.1).
rateFishing_R_multibase(0.5).
rateFishing_C_multibase(1).
rateFishing_SSR(0.03).
rateFishing_SR(0.2).
rateFishing_R(10).
rateFishing_C(30).
daily_fish_limit(20).

item_group_helper_FISHING(fishable_SSR, [anemone, blackfin_tuna, moonfish]). 
item_group_helper_FISHING(fishable_SR, [marblefish, longfin, lionfish, mooneye, jewelfish]).
item_group_helper_FISHING(fishable_R, [gudgeon, glassfish, eulachon, dwarf_gourami, angelfish, spearfish]).
item_group_helper_FISHING(fishable_C, [salmon, tuna, catfish, swordfish, mackarel, common_carp, tilapia, trout]).

incrementFish(Item, Response) :-
    getTotalInv(TotalInv),
    (
        TotalInv < 100 -> (
            retract(item_in_inventory(Item, Level, Qty)),
            NewQty is Qty + 1,
            assertz(item_in_inventory(Item, Level, NewQty)),
            Response = incSuccess
        );
        Response = incFail
    ).


getNormalizeVal(X, Res) :- getNormalizeVal(X, Res, 1).
getNormalizeVal(0, Res, _) :- Res is 100, !.
getNormalizeVal(X, Res, Base) :-
    X >= 1,
    Res is Base, !.
getNormalizeVal(X, Res, Base) :-
    X < 1,
    NewBase is Base*10,
    NewX is X*10,
    getNormalizeVal(NewX, Res, NewBase).

rd_member(Item, Pool) :-
    length(Pool, Len),
    random(0, Len, Index),
    nth0(Index, Pool, Item).

catchfishmsg(Item, Rarity) :-
    (
    Rarity == catching_fish_ssr ->
        item_alias(Item, ItemAlias),
        expGain_SSR(ExpGain),
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n', []),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('|         +-+-+-+-+-+-#####-+-+-+-+-+-+         |~n', []),
        format('|         |         SSR   SSR         |         |~n', []),
        format('| --------+-+-+-+-+-+-*****-+-+-+-+-+-+-------- |~n', []),
        format('| >       |                           |       < |~n', []),
        format('| >  S S  * WOAHH, LOOK AT THAT CATCH *  S S  < |~n', []),
        format('| >   R   * YOU CAUGHT AN SSR FISH!!! *   R   < |~n', []),
        format('| >       |                           |       < |~n', []),
        format('| --------+-+-+-+-+-+-*****-+-+-+-+-+-+-------- |~n', []),
        format('|         |         SSR   SSR         |         |~n', []),
        format('|         +-+-+-+-+-+-#####-+-+-+-+-+-+         |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', []),
        format('~nResult: You got a ~s (SSR) !~n', [ItemAlias]),
        format('You gained ~d EXP!~n', [ExpGain])
    ;
    Rarity == catching_fish_sr ->
        item_alias(Item, ItemAlias),
        expGain_SR(ExpGain),
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('|         *****************************         |~n', []),
        format('|         *                           *         |~n', []),
        format('|         * Hey, Awesome catch there. *         |~n', []),
        format('|         *  You caught an SR Fish!   *         |~n', []),
        format('|         *                           *         |~n', []),
        format('|         *****************************         |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', []),
        format('~nResult: You got a ~s (SR) !~n', [ItemAlias]),
        format('You gained ~d EXP!~n', [ExpGain])
    ;
    Rarity == catching_fish_r ->
        item_alias(Item, ItemAlias),
        expGain_R(ExpGain),
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('|      Great stuff, You caught an R Fish!       |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', []),
        format('~nResult: You got a ~s (R) !~n', [ItemAlias]),
        format('You gained ~d EXP!~n', [ExpGain])
    ;
    Rarity == catching_fish_c ->
        item_alias(Item, ItemAlias),
        expGain_C(ExpGain),
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('|          Nice, You caught a C Fish!           |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', []),
        format('~nResult: You got a ~s (C) !~n', [ItemAlias]),
        format('You gained ~d EXP!~n', [ExpGain])
    ;
    Rarity == catching_fish_none ->
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('| I am sorry, but you caught nothing this time. |~n', []),
        format('|            Better Luck Next Time!             |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', [])
    ;
    Rarity == catching_fish_fail_inven ->
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('|    I am sorry, but your inventory is full     |~n', []),
        format('|            Try to clear up some!              |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', [])
    ;
        fail
    ).

adjustRate :-  adjustRate(_, _, _).

adjustRate(LevelBonus, OccsBonus, RodBonus) :-
    occupation(Occs),
    fishEXP(lvl, FishingLevel),
    item_in_inventory(fishing_rod, RodLevel, _),
    (
        Occs == fisherman -> OccsBonus is 5;
        OccsBonus is 0
    ),
    (
        RodLevel >= 10 -> RodBonus is 10;
        RodBonus is RodLevel
    ),
    (
        FishingLevel >= 10 -> LevelBonus is 10;
        LevelBonus is FishingLevel 
    ),
    Multiplier is LevelBonus + OccsBonus + RodBonus,
    rateFishing_SSR_base(OldRateSSR),
    rateFishing_SR_base(OldRateSR),
    rateFishing_R_base(OldRateR),
    rateFishing_C_base(OldRateC),
    rateFishing_SSR_multibase(RateSSRMulti),
    rateFishing_SR_multibase(RateSRMulti),
    rateFishing_R_multibase(RateRMulti),
    rateFishing_C_multibase(RateCMulti),
    retract(rateFishing_SSR(_)),
    retract(rateFishing_SR(_)),
    retract(rateFishing_R(_)),
    retract(rateFishing_C(_)),
    NewRateSSR is OldRateSSR + Multiplier * RateSSRMulti,
    NewRateSR is OldRateSR + Multiplier * RateSRMulti,
    NewRateR is OldRateR + Multiplier * RateRMulti,
    NewRateC is OldRateC + Multiplier * RateCMulti,
    assertz(rateFishing_SSR(NewRateSSR)),
    assertz(rateFishing_SR(NewRateSR)),
    assertz(rateFishing_R(NewRateR)),
    assertz(rateFishing_C(NewRateC)).

adjustLevel(AddedExp) :-
    globalEXPUp(AddedExp),
    fishEXP(exp, Exp),
    fishEXP(lvl, Level),
    fishEXP(level_up_ceil_exp, LevelUpCeilExp),
    NewExp is Exp + AddedExp,
    (
        NewExp >= LevelUpCeilExp -> (
            NewLevel is Level + 1,
            NewCeil is 2*LevelUpCeilExp + 100,
            retract(fishEXP(level_up_ceil_exp, _)),
            retract(fishEXP(lvl, _)),
            assertz(fishEXP(level_up_ceil_exp, NewCeil)),
            assertz(fishEXP(lvl, NewLevel)),
            format('You Leveled Up to Level ~d!~n', [NewLevel])
        );
        true
    ),
    retract(fishEXP(exp, _)),
    assertz(fishEXP(exp, NewExp)).

incFishCount :-
    fishing_today(FishCount),
    NewFishCount is FishCount + 1,
    retract(fishing_today(_)),
    assertz(fishing_today(NewFishCount)).

fishit :- 
    isInAppropriateFishingTile(RESP),
    RESP == not_beside_lake, 
    format('Hello, this is Flying Fish Manor\'s Messenger Pigeon.~n', []),
    format('We are sorry to inform you that you should be beside a lake in order to fish.~n', []),
    format('Please move to an appropriate tile, we are happily waiting for your next visit!', []), !.
fishit :-
    item_in_inventory(fishing_rod, _, QTY), QTY =< 0, 
    format('Hello, this is Flying Fish Manor\'s Assistant, Ageha Himegi.~n', []),
    format('We are sorry to inform you that you do not have a fishing rod.~n', []),
    format('Please come back when you have one. We are waiting for your next visit!', []), !.
fishit :-
    daily_fish_limit(Limit),
    fishing_today(Today),
    Today >= Limit,
    format('Hello, this is Flying Fish Manor\'s Assistant, Ageha Himegi.~n', []),
    format('We are sorry to inform you that you have reached the daily fishing limit.~n', []),
    format('Please come back tomorrow. We are waiting for your next visit!', []), !.
fishit :-
    getTotalInv(TotalInv),
    TotalInv >= 100, catchfishmsg(none_fish, catching_fish_fail_inven), !.
fishit :-
    adjustRate,
    incFishCount,
    random(9999, 100000, Seed),
    set_seed(Seed),
    randomize,
    rateFishing_SSR(OldRateSSR),
    rateFishing_SR(OldRateSR),
    rateFishing_R(OldRateR),
    rateFishing_C(OldRateC),
    item_group_helper_FISHING(fishable_SSR, PoolSSR),
    item_group_helper_FISHING(fishable_SR, PoolSR),
    item_group_helper_FISHING(fishable_R, PoolR),
    item_group_helper_FISHING(fishable_C, PoolC),
    length(PoolSSR, PoolSSR_Len),
    length(PoolSR, PoolSR_Len),
    % length(PoolR, PoolR_Len),
    % length(PoolC, PoolC_Len),
    getNormalizeVal(OldRateSSR, Adjust),
    UpperBound is 100*Adjust,
    RateSSR is OldRateSSR*Adjust,
    RateSR is OldRateSR*Adjust,
    RateR is OldRateR*Adjust,
    RateC is OldRateC*Adjust,
    MarkSSR is RateSSR * PoolSSR_Len,
    MarkSR is MarkSSR + (RateSR * PoolSR_Len),
    MarkR is MarkSR + RateR,
    MarkC is MarkR + RateC,
    random(0, UpperBound, Gacha),
    (
        Gacha >= 0, Gacha < MarkSSR -> (
            rd_member(Item, PoolSSR),
            incrementFish(Item, RESP),
            (
                RESP == incSuccess -> (
                    catchfishmsg(Item, catching_fish_ssr),
                    expGain_SSR(ExpGain),
                    adjustLevel(ExpGain),
                    (
                        (
                            myquest(Hi,Hf,Fi,Ff,Ri,Rf),
                            Ff > 0,
                            Ffx is Ff-1,
                            retract(myquest(_,_,_,_,_,_)),
                            assertz(myquest(Hi,Hf,Fi,Ffx,Ri,Rf)),
                            !
                        )
                        ;
                        true
                    )
                );
                RESP == incFail -> (
                    catchfishmsg(Item, catching_fish_fail_inven)
                );
                fail
            ),
            !
        )
        ;
        Gacha >= MarkSSR, Gacha < MarkSR -> (
            rd_member(Item, PoolSR),
            incrementFish(Item, RESP),
            (
                RESP == incSuccess -> (
                    catchfishmsg(Item, catching_fish_sr),
                    expGain_SR(ExpGain),
                    adjustLevel(ExpGain),
                    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
                    Ff > 0,
                    Ffx is Ff-1,
                    retract(myquest(_,_,_,_,_,_)),
                    assertz(myquest(Hi,Hf,Fi,Ffx,Ri,Rf)),!;true
                );
                RESP == incFail -> (
                    catchfishmsg(Item, catching_fish_fail_inven)
                );
                fail
            ),
            !
        )
        ;
        Gacha >= MarkSR, Gacha < MarkR -> (
            rd_member(Item, PoolR),
            incrementFish(Item, RESP),
            (
                RESP == incSuccess -> (
                    catchfishmsg(Item, catching_fish_r),
                    expGain_R(ExpGain),
                    adjustLevel(ExpGain),
                    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
                    Ff > 0,
                    Ffx is Ff-1,
                    retract(myquest(_,_,_,_,_,_)),
                    assertz(myquest(Hi,Hf,Fi,Ffx,Ri,Rf)),!;true
                );
                RESP == incFail -> (
                    catchfishmsg(Item, catching_fish_fail_inven)
                );
                fail
            ),
            !
        )
        ;
        Gacha >= MarkR, Gacha < MarkC -> (
            rd_member(Item, PoolC),
            incrementFish(Item, RESP),
            (
                RESP == incSuccess -> (
                    catchfishmsg(Item, catching_fish_c),
                    expGain_C(ExpGain),
                    adjustLevel(ExpGain),
                    myquest(Hi,Hf,Fi,Ff,Ri,Rf),
                    Ff > 0,
                    Ffx is Ff-1,
                    retract(myquest(_,_,_,_,_,_)),
                    assertz(myquest(Hi,Hf,Fi,Ffx,Ri,Rf)),!;true
                );
                RESP == incFail -> (
                    catchfishmsg(Item, catching_fish_fail_inven)
                );
                fail
            ),
            !
        )
        ;
        catchfishmsg(none_fish, catching_fish_none)
    ), !.


displayFishingRate :-
    isInAppropriateFishingTile(RESP),
    RESP == not_beside_lake, 
    format('Hello, this is Flying Fish Manor\'s Messenger Pigeon.~n', []),
    format('We are sorry to inform you that you should be beside a lake in order to fish.~n', []),
    format('Please move to an appropriate tile, we are happily waiting for your next visit!', []), !.
displayFishingRate :-
    adjustRate,
    rateFishing_SSR(RateSSR),
    rateFishing_SR(RateSR),
    rateFishing_R(RateR),
    rateFishing_C(RateC),
    item_group_helper_FISHING(fishable_SSR, PoolSSR),
    item_group_helper_FISHING(fishable_SR, PoolSR),
    item_group_helper_FISHING(fishable_R, PoolR),
    item_group_helper_FISHING(fishable_C, PoolC),
    format('~nFlying Fish\'s Manor\'s Daily Menu~n',[]),
    format('~n---- SSR Tier ----~n',[]),
    forall(member(X, PoolSSR), (
        item_alias(X, Alias),
        format('~s | ~2f~w ~n', [Alias, RateSSR, '%'])
    )),
    format('~n---- SR Tier ----~n',[]),
    forall(member(X, PoolSR), (
        item_alias(X, Alias),
        format('~s | ~2f~w ~n', [Alias, RateSR, '%'])
    )),
    format('~n---- R Tier ----~n',[]),
    format('~2f~w chance to get any of these:~n', [RateR,'%']),
    forall(member(X, PoolR), (
        item_alias(X, Alias),
        format('~s ~n', [Alias])
    )),
    format('~n---- C Tier ----~n',[]),
    format('~2f~w chance to get any of these:~n', [RateC,'%']),
    forall(member(X, PoolC), (
        item_alias(X, Alias),
        format('~s ~n', [Alias])
    )),
    nl, !.

isInAppropriateFishingTile(Response) :- 
    pos(CurX, CurY),
    isInAppropriateFishingTile(Response, CurX, CurY).
isInAppropriateFishingTile(Response, CurX, CurY) :-
    Up is CurY - 1,
    map(CurX, Up, Tile), Tile == 'o', Response = is_beside_lake, !.
isInAppropriateFishingTile(Response, CurX, CurY) :-
    Down is CurY + 1,
    map(CurX, Down, Tile), Tile == 'o', Response = is_beside_lake, !.
isInAppropriateFishingTile(Response, CurX, CurY) :-
    Left is CurX - 1,
    map(Left, CurY, Tile), Tile == 'o', Response = is_beside_lake, !.
isInAppropriateFishingTile(Response, CurX, CurY) :-
    Right is CurX + 1,
    map(Right, CurY, Tile), Tile == 'o', Response = is_beside_lake, !.
isInAppropriateFishingTile(Response, _, _) :-
    Response = not_beside_lake.

displayFishingID :- 
    isInAppropriateFishingTile(RESP),
    RESP == not_beside_lake, 
    format('Hello, this is Flying Fish Manor\'s Messenger Pigeon.~n', []),
    format('We are sorry to inform you that you should be beside a lake in order to fish.~n', []),
    format('Please move to an appropriate tile, we are happily waiting for your next visit!', []), !.
displayFishingID :-
    fishEXP(level_up_ceil_exp, LevelUpCeilExp),
    fishEXP(lvl, Level),
    fishEXP(exp, Exp),
    item_in_inventory(fishing_rod, RodLevel, _),
    format('Here is your Fishing ID:~n', []),
    format('-------------------------------------------------~n', []),
    format('|         FLYING FISH MANOR FISHING ID          |~n', []),
    format('-------------------------------------------------~n', []),
    format('    NAME              : CANDICE N.~n', []),
    format('    FISHING ROD LEVEL : ~d~n', [RodLevel]),
    format('    FISHING LEVEL     : ~d~n', [Level]),
    format('    PLAYER EXP        : ~d~n', [Exp]),
    format('    NEXT LEVEL EXP    : ~d~n', [LevelUpCeilExp]),
    format('-------------------------------------------------~n', []), !.

fish :-
    isInAppropriateFishingTile(RESP),
    RESP == not_beside_lake, 
    format('Hello, this is Flying Fish Manor\'s Messenger Pigeon.~n', []),
    format('We are sorry to inform you that you should be beside a lake in order to fish.~n', []),
    format('Please move to an appropriate tile, we are waiting for your next visit!', []), !.
fish :-
    daily_fish_limit(Limit),
    format('Welcome to Flying Fish Manor.~nHere are our Today\'s Menu~n', []),
    displayFishingRate,
    displayFishingID, nl,
    format('please type \'fishit.\' to fish, ~n\'displayFishingID.\' to see your ID, ~nand \'displayFishingRate.\' to display our Today\'s Menu again~n', []), 
    format('please do note, however, that your fishing activity has limit up to ~d time(s) per day.~n',[Limit]), 
    format('Happy Fishing! ^_^~n', []),
    nl,
    format('Best Regards, ~nFlying Fish Manor\'s Personal Assistant~n',[]),
    format('Ageha Himegi~n', []), !.

