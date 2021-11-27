:- include('globals.pl').


% fakta item
market_item(1, carrot, 'Carrot', 50, 0).
market_item(2, corn, 'Corn', 50, 0).
market_item(3, tomato, 'Tomato', 50, 0).
market_item(4, potato, 'Potato', 50, 0).
market_item(5, chicken, 'Chicken', 500, 0).
market_item(6, sheep, 'Sheep', 1000, 0).
market_item(7, cow, 'Cow', 1500, 0).
market_item(8, shovel, 'Lvl 2 Shovel', 300, 2).
market_item(9, fishing_rod, 'Lvl 2 Fishing Rod', 500, 2).

isOnMarket:-
    pos(X, Y), map(X, Y, 'M').

market:-
    isOnMarket,
    write('Welcome to the Marketplace!\n'),
    write('What do you want to do?\n'),
    write('1. Buy\n'),
    write('2. Sell\n').

market:-
    \+isOnMarket,
    write('You\'re currently not at the market!\n').


buy:-
    \+isOnMarket,
    write('You\'re currently not at the market!\n').

buy:-
    isOnMarket,
    write('What do you want to buy? (input the number) \n'),
    write('1. Carrot seed (50 golds)\n'),
    write('2. Corn seed (50 golds)\n'),
    write('3. Tomato seed (50 golds)\n'),
    write('4. Potato seed (50 golds)\n'),
    write('5. Chicken (500 golds)\n'),
    write('6. Sheep (1000 golds)\n'),
    write('7. Cow (1500 golds)\n'),
    write('8. Level 2 shovel (300 golds)\n'),
    write('9. Level 2 fishing rod (500 golds)\n'),
    write('\n>>> '),
    read(Option),
    write('How many do you want to buy?\n>>> '),
    read(Quantity),
    market_item(Option, Item, ItemName, Price, Level),
    FinalPrice is Price * Quantity,
    write('You bought '), write(Quantity), write(' '), write(ItemName), write('.'),
    buyItem(FinalPrice, Item, Quantity, Level).

buyItem(FinalPrice, Item, Quantity, Level):-
    gold(Gold), FinalPrice =< Gold,
    NewGold is Gold - FinalPrice,
    retract(gold(Gold)),
    assertz(gold(NewGold)),
    write('\nYou are charged '), write(FinalPrice), write(' golds.\n'),
    item_in_inventory(Item, Level, Qty),
    Qty1 is Qty + Quantity,
    (Item = chicken ; Item = cow; Item = sheep) ->
        ( 
            updateRanch(Item, Quantity) 
        )
        ;
        (Item = carrot; Item = tomato; Item = potato; Item = corn) ->
        (
            updateSeed(Item, Quantity)
        )
        ;
        (
            retract(item_in_inventory(Item, Level, Qty)),
            assertz(item_in_inventory(Item, Level, Qty1))
        ).

buyItem(FinalPrice, _, _, _):-
    gold(Gold), FinalPrice > Gold,
    write('You have insufficient gold!\n').

updateRanch(Item, Quantity):-
    livestock(Item, Qty),
    NewQty is Qty + Quantity,
    retract(livestock(Item, Qty)),
    assertz(livestock(Item, NewQty)),
    write('Livestock bought! Check it out at your Ranch!\n'),
    Item = cow -> ranchEXPUp(15) ;
    Item = sheep -> ranchEXPUp(10) ;
    Item = chicken -> ranchEXPUp(5).

updateSeed(Item, Quantity):-
    seed(Item, Qty, ID1, ID2, Duration),
    NewQty is Qty + Quantity,
    write('Seed bought! Check it out at your plant menu!\n'),
    retract(seed(Item, Qty, ID1, ID2, Duration)),
    assertz(seed(Item, NewQty, ID1, ID2, Duration)).

