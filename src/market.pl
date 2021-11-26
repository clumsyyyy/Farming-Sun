:- include('globals.pl').


% fakta item
market_item(1, carrot, 'Carrot', 50, -1).
market_item(2, corn_seed, 'Corn', 50, -1).
market_item(3, tomato_seed, 'Tomato', 50, -1).
market_item(4, potato, 'Potato', 50, -1).
market_item(5, chicken, 'Chicken', 500, -1).
market_item(6, sheep, 'Sheep', 1000, -1).
market_item(7, cow, 'Cow', 1500, -1).
market_item(8, shovel2, 'Lvl 2 Shovel', 300, 2).
market_item(9, fishing_rod2, 'Lvl 2 Fishing Rod', 500, 2).

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
    assertz(item_in_inventory(Item, Level, Quantity)).

buyItem(FinalPrice, _, _, _):-
    gold(Gold), FinalPrice > Gold,
    write('Gold insufficient!\n').



