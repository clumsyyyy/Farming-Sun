%kemungkinan rating ikan
:- include('items.pl').

rateFishing_SSR(0.03).
rateFishing_SR(0.2).
rateFishing_R(10).
rateFishing_C(30).

item_group_helper_FISHING(fishable_SSR, [endless_rizette, fornaxos, rolotia]). 
item_group_helper_FISHING(fishable_SR, [alira, shiori, cyrus, altaireon, maxima, norza]).
item_group_helper_FISHING(fishable_R, [rei, finn, kaidaros, voraxion, merdain, diabolos]).
item_group_helper_FISHING(fishable_C, [rashanar, vesh, kirin, artimeia, le_fay, orzachron, alice, shirra, grenzor]).

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
    Rarity = catching_fish_ssr ->
        item_alias(Item, ItemAlias),
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
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
        format('~nResult: You got a ~s (SSR) !~n', [ItemAlias])
    ;
    Rarity = catching_fish_sr ->
        item_alias(Item, ItemAlias),
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
        format('~nResult: You got a ~s (SR) !~n', [ItemAlias])
    ;
    Rarity = catching_fish_r ->
        item_alias(Item, ItemAlias),
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('|      Great stuff, You caught an R Fish!       |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', []),
        format('~nResult: You got a ~s (R) !~n', [ItemAlias])
    ;
    Rarity = catching_fish_c ->
        item_alias(Item, ItemAlias),
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('|          Nice, You caught a C Fish!           |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', []),
        format('~nResult: You got a ~s (C) !~n', [ItemAlias])
    ;
    Rarity = catching_fish_none ->
        format('-------------------------------------------------~n', []),
        format('|        FLYING FISH MANOR FISHING BOARD        |~n',[]),
        format('-------------------------------------------------~n', []),
        format('|                                               |~n', []),
        format('| I am sorry, but you caught nothing this time. |~n', []),
        format('|            Better Luck Next Time!             |~n', []),
        format('|                                               |~n', []),
        format('-------------------------------------------------~n', [])
    ;
        fail
    ).

fishit :-
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
            catchfishmsg(Item, catching_fish_ssr),
            doFish,
            !
        )
        ;
        Gacha >= MarkSSR, Gacha < MarkSR -> (
            rd_member(Item, PoolSR),
            catchfishmsg(Item, catching_fish_sr),
            doFish,
            !
        )
        ;
        Gacha >= MarkSR, Gacha < MarkR -> (
            rd_member(Item, PoolR),
            catchfishmsg(Item, catching_fish_r),
            doFish,
            !
        )
        ;
        Gacha >= MarkR, Gacha < MarkC -> (
            rd_member(Item, PoolC),
            catchfishmsg(Item, catching_fish_c),
            doFish,
            !
        )
        ;
        catchfishmsg(none_fish, catching_fish_none)
    ).



displayFishingRate :-
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
    nl.
    
fishing :-
    format('Welcome to Flying Fish Manor.~nHere are our Today\'s Menu~n', []),
    displayFishingRate,
    format('please type \'fishit\' to fish, and \'displayFishingRate\' to display our Today\'s Menu again ^_^~n', []).

