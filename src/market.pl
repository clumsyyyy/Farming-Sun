:- include('globals.pl').

/*

item_group_helper_FISHING(fishable_SSR, [anemone, blackfin_tuna, moonfish]). 
item_group_helper_FISHING(fishable_SR, [marblefish, longfin, lionfish, mooneye, jewelfish]).
item_group_helper_FISHING(fishable_R, [gudgeon, glassfish, eulachon, dwarf_gourami, angelfish, spearfish]).
item_group_helper_FISHING(fishable_C, [salmon, tuna, catfish, swordfish, mackarel, common_carp, tilapia, trout]).
*/
/*

item_in_inventory(shovel,1,1).
item_in_inventory(fishing_rod, 1, 1).
item_in_inventory(carrot_seed, -1, 0).
item_in_inventory(corn_seed, -1, 0).
item_in_inventory(tomato_seed, -1, 0).
item_in_inventory(potato_seed, -1, 0).
item_in_inventory(carrot, -1, 0).
item_in_inventory(corn, -1, 0).
item_in_inventory(tomato, -1, 0).
item_in_inventory(potato, -1, 0).
item_in_inventory(chicken, -1, 0).
item_in_inventory(sheep, -1, 0).
item_in_inventory(cow, -1, 0).
item_in_inventory(egg, -1, 0).
item_in_inventory(wool, -1, 0).
item_in_inventory(milk, -1, 0).
item_in_inventory(anemone, -1, 0).
item_in_inventory(blackfin_tuna, -1, 0).
item_in_inventory(moonfish, -1, 0).
item_in_inventory(marblefish, -1, 0).
item_in_inventory(longfin, -1, 0).
item_in_inventory(lionfish, -1, 0).
item_in_inventory(mooneye, -1, 0).
item_in_inventory(jewelfish, -1, 0).
item_in_inventory(gudgeon, -1, 0).
item_in_inventory(glassfish, -1, 0).
item_in_inventory(eulachon, -1, 0).
item_in_inventory(dwarf_gourami, -1, 0).
item_in_inventory(angelfish, -1, 0).
item_in_inventory(spearfish, -1, 0).
item_in_inventory(salmon, -1, 0).
item_in_inventory(tuna, -1, 0).
item_in_inventory(catfish, -1, 0).
item_in_inventory(swordfish, -1, 97).
item_in_inventory(mackarel, -1, 0).
item_in_inventory(common_carp, -1, 0).
item_in_inventory(tilapia, -1, 0).
item_in_inventory(trout, -1, 0).

*/

% fakta item
% ITEM ID, ITEM CODENAME, ITEM LEVEL, ITEM PRICE
% ITEM ID: 1XX for Tools, 2XX for farming, 3XX for ranching, 
% 40X for SSR fish
% 41X for SR fish
% 42X for R fish
% 43X for C fish 
market_item(101, shovel, 2, 500).
market_item(102, fishing_rod, 2, 500).

market_item(201, carrot_seed, -1, 500).
market_item(202, corn_seed, -1, 500).
market_item(203, tomato_seed, -1, 500).
market_item(204, potato_seed, -1, 500).
market_item(205, carrot, -1, 500).
market_item(206, corn, -1, 500).
market_item(207, tomato, -1, 500).
market_item(208, potato, -1, 500).

market_item(301, chicken, -1, 500).
market_item(302, sheep, -1, 500).
market_item(303, cow, -1, 500).
market_item(304, egg, -1, 500).
market_item(305, wool, -1, 500).
market_item(306, milk, -1, 500).

market_item(401, anemone, -1, 500).
market_item(402, blackfin_tuna, -1, 500).
market_item(403, moonfish, -1, 500).

market_item(411, marblefish, -1, 500).
market_item(412, longfin, -1, 500).
market_item(413, lionfish, -1, 500).
market_item(414, mooneye, -1, 500).
market_item(415, jewelfish, -1, 500).

market_item(421, gudgeon, -1, 500).
market_item(422, glassfish, -1, 500).
market_item(423, eulachon, -1, 500).
market_item(424, dwarf_gourami, -1, 500).
market_item(425, angelfish, -1, 500).
market_item(426, spearfish, -1, 500).

market_item(431, salmon, -1, 500).
market_item(432, tuna, -1, 500).
market_item(433, catfish, -1, 500).
market_item(434, swordfish, -1, 500).
market_item(435, mackarel, -1, 500).
market_item(436, common_carp, -1, 500).
market_item(437, tilapia, -1, 500).
market_item(438, trout, -1, 500).

item_group_helper_MARKET(sellable_market_item, [101, 203, 401, 402, 403, 411, 412, 413, 414, 415, 421, 422, 423, 424, 425, 426, 431, 432, 433, 434, 435, 436, 437, 438]).

isOnMarket:-
    pos(X, Y), map(X, Y, 'M').

marketValidationMSG :-
    \+ isOnMarket,
    write('You are not on the market.\n'), nl.

market:-
    marketValidationMSG, !.

market:-
    isOnMarket,
    write('Welcome to the Marketplace!\n'),
    write('What do you want to do?\n'),
    write('1. Buy\n'),
    write('2. Sell\n').



print_market_item_details(ID) :-
    market_item(ID, _, _, Price),
    print_market_item_name(ID), format(' (~d Gold) | ID: ~d', [Price, ID]).


print_market_item_name(ID):-
    market_item(ID, Item, Level, _),
    item_alias(Item, Alias),
    (
        Level =:= -1 -> (
            format('~s', [Alias])
        );
        format('Level ~d ~s', [Level, Alias])
    ).

display_market_tools_sell(ID) :-
    item_group_helper_MARKET(sellable_market_item, List),
    member(ID, List),
    (
        ID >= 100, ID =< 199 -> (
            print_market_item_details(ID), nl
        );
        true
    ); true.

display_market_farming_sell(ID) :-
    item_group_helper_MARKET(sellable_market_item, List),
    member(ID, List), 
    (
        ID >= 200, ID =< 299 -> (
            print_market_item_details(ID), nl
        );
        true
    ); true.

display_market_ranching_sell(ID) :-
    item_group_helper_MARKET(sellable_market_item, List),
    member(ID, List),
    (
        ID >= 300, ID =< 399 -> (
            print_market_item_details(ID), nl
        );
        true
    ); true.

display_market_fishing_ssr_sell(ID) :-
    item_group_helper_MARKET(sellable_market_item, List),
    member(ID, List),
    (
        ID >= 400, ID =< 409 -> (
            print_market_item_details(ID), nl
        );
        true
    ); true.

display_market_fishing_sr_sell(ID) :-
    item_group_helper_MARKET(sellable_market_item, List),
    member(ID, List),
    (
        ID >= 410, ID =< 419 -> (
            print_market_item_details(ID), nl
        );
        true
    ); true.

display_market_fishing_r_sell(ID) :-
    item_group_helper_MARKET(sellable_market_item, List),
    member(ID, List),
    (
        ID >= 420, ID =< 429 -> (
            print_market_item_details(ID), nl
        );
        true
    ); true.

display_market_fishing_c_sell(ID) :-
    item_group_helper_MARKET(sellable_market_item, List),
    member(ID, List),
    (
        ID >= 430, ID =< 439 -> (
            print_market_item_details(ID), nl
        );
        true
    ); true.

displayAvailableToSell :-
    marketValidationMSG, !.

displayAvailableToSell :-
    format('|------------------- TOOLS -------------------|~n', []),
    forall(market_item(ID, _, _, _), display_market_tools_sell(ID)), nl,
    format('|------------------- FARMING ------------------|~n', []),
    forall(market_item(ID, _, _, _), display_market_farming_sell(ID)), nl,
    format('|------------------ RANCHING -----------------|~n', []),
    forall(market_item(ID, _, _, _), display_market_ranching_sell(ID)), nl,
    format('|---------------- FISHING (SSR) --------------|~n', []),
    forall(market_item(ID, _, _, _), display_market_fishing_ssr_sell(ID)), nl,
    format('|---------------- FISHING (SR) ---------------|~n', []),
    forall(market_item(ID, _, _, _), display_market_fishing_sr_sell(ID)), nl,
    format('|----------------- FISHING (R) ---------------|~n', []),
    forall(market_item(ID, _, _, _), display_market_fishing_r_sell(ID)), nl,
    format('|----------------- FISHING (C) ---------------|~n', []),
    forall(market_item(ID, _, _, _), display_market_fishing_c_sell(ID)), nl.

% buy:-
%     \+isOnMarket,
%     write('You\'re currently not at the market!\n').

% buy:-
%     isOnMarket,
%     write('What do you want to buy? (input the number) \n'),
%     write('1. Carrot seed (50 golds)\n'),
%     write('2. Corn seed (50 golds)\n'),
%     write('3. Tomato seed (50 golds)\n'),
%     write('4. Potato seed (50 golds)\n'),
%     write('5. Chicken (500 golds)\n'),
%     write('6. Sheep (1000 golds)\n'),
%     write('7. Cow (1500 golds)\n'),
%     write('8. Level 2 shovel (300 golds)\n'),
%     write('9. Level 2 fishing rod (500 golds)\n'),
%     write('\n>>> '),
%     read(Option),
%     write('How many do you want to buy?\n>>> '),
%     read(Quantity),
%     market_item(Option, Item, ItemName, Price, Level),
%     FinalPrice is Price * Quantity,
%     write('You bought '), write(Quantity), write(' '), write(ItemName), write('.'),
%     buyItem(FinalPrice, Item, Quantity, Level).

% buyItem(FinalPrice, Item, Quantity, Level):-
%     gold(Gold), FinalPrice =< Gold,
%     NewGold is Gold - FinalPrice,
%     retract(gold(Gold)),
%     assertz(gold(NewGold)),
%     write('\nYou are charged '), write(FinalPrice), write(' golds.\n'),
%     item_in_inventory(Item, Level, Qty),
%     Qty1 is Qty + Quantity,
%     (Item = chicken ; Item = cow; Item = sheep) ->
%         ( 
%             updateRanch(Item, Quantity) 
%         )
%         ;
%         (Item = carrot; Item = tomato; Item = potato; Item = corn) ->
%         (
%             updateSeed(Item, Quantity)
%         )
%         ;
%         (
%             retract(item_in_inventory(Item, Level, Qty)),
%             assertz(item_in_inventory(Item, Level, Qty1))
%         ).

% buyItem(FinalPrice, _, _, _):-
%     gold(Gold), FinalPrice > Gold,
%     write('You have insufficient gold!\n').

% updateRanch(Item, Quantity):-
%     livestock(Item, Qty),
%     NewQty is Qty + Quantity,
%     retract(livestock(Item, Qty)),
%     assertz(livestock(Item, NewQty)),
%     write('Livestock bought! Check it out at your Ranch!\n'),
%     Item = cow -> ranchEXPUp(15) ;
%     Item = sheep -> ranchEXPUp(10) ;
%     Item = chicken -> ranchEXPUp(5).
sell:-
    marketValidationMSG, !.

sell:-
    isOnMarket,
    format('Hello, Fellow Traveler.~n', []),
    format('To see what are we having today, you can type \'displayAvailableToSell.\' and type its MARKET ID to sell.~n', []),
    format('You can also type \'inventory.\' to see what you have in your inventory.~n', []),
    format('if you\'re ready to sell, please type \'sellitnow.\'~n', []).

sellitnow :-
    marketValidationMSG, !.

sellitnow :-
    format('so, what do you want to sell? ', []),
    item_group_helper_MARKET(sellable_market_item, PoolSellable),
    read(IDSELL),
    % CALCULATE PRICE
    (
        market_item(IDSELL, CODENAME, _, Price), member(IDSELL, PoolSellable) -> (
            item_in_inventory(CODENAME, _, Qty) -> (
                format('You have ~d ', [Qty]), print_market_item_details(IDSELL), write(' in your inventory.\n'),
                write('and, how many do you want to sell? '), read(QtySELL),
                (
                    QtySELL =<  Qty -> (
                        FinalPrice is Price * QtySELL,
                        format('~n|--------- MARKET RECEIPT ---------|~n', []),
                        format(' ~d ', [QtySELL]), print_market_item_details(IDSELL), write(' sold.\n'),
                        format('|-----------------------------------|~n', []),
                        format('You will earn ~d gold(s)!~n~n', [FinalPrice]),
                        write('Do you want still want to proceed? type \'yes\' to continue! '), read(CONFIRM),
                        (
                            CONFIRM == yes -> (
                                gold(Gold), NewGold is Gold + FinalPrice,
                                retract(gold(Gold)),
                                assertz(gold(NewGold)),
                                NewQty is Qty - QtySELL,
                                retract(item_in_inventory(CODENAME, _, Qty)),
                                assertz(item_in_inventory(CODENAME, _, NewQty)),
                                format('Selling succeed! your current gold is now ~d~n', [NewGold])
                            );
                            write('You have cancelled the transaction.\n')
                        )
                    );
                    write('You don\'t have that many!\n')
                )
            );
            write('You don\'t have that item in your inventory!\n')
        );
        format('I am sorry but, it looks like you\'ve inputted the wrong ID, try again!~n', [])
    ).


updateSeed(Item, Quantity):-
    seed(Item, Qty, ID1, ID2, Duration),
    NewQty is Qty + Quantity,
    write('Seed bought! Check it out at your plant menu!\n'),
    retract(seed(Item, Qty, ID1, ID2, Duration)),
    assertz(seed(Item, NewQty, ID1, ID2, Duration)).

