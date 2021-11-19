:- dynamic(item/3). % name, level (-1 if not used), qty.

item(shovel,1,1).
item(fishing_rod, 1, 1).
item(carrot, -1, 3).
item(corn, -1, 4).
item(egg, -1, 3).
item(salmon, -1, 5).
item(tuna, -1, 3).
item(utaha_kasumigaoka, 100, 0).
item(eriri_spencer, 100, 1).

item_group(fishable_SSR, [endless_rizette, fornaxos, rolotia]). 
item_group(fishable_SR, [alira, shiori, cyrus, altaireon, maxima, norza]).
item_group(fishable_R, [rei, finn, kaidaros, voraxion, merdain, diabolos]).
item_group(fishable_C, [rashanar, vesh, kirin, artimeia, le_fay, orzachron, alice, shirra, grenzor]).

item_alias(shovel, "Shovel").
item_alias(fishing_rod, "Fishing Rod").
item_alias(carrot, "Carrot").
item_alias(corn, "Corn").
item_alias(egg, "Egg").
item_alias(salmon, "Salmon").
item_alias(tuna, "Tuna").
item_alias(utaha_kasumigaoka, "Utaha Kasumigaoka").
item_alias(eriri_spencer, "Eriri Spencer").
item_alias(endless_rizette, "Endless Rizette").
item_alias(fornaxos, "Fornaxos").
item_alias(rolotia, "Rolotia").
item_alias(alira, "Alira").
item_alias(shiori, "Shiori").
item_alias(cyrus, "Cyrus").
item_alias(altaireon, "Altaireon").
item_alias(maxima, "Maxima").
item_alias(norza, "Norza").
item_alias(rei, "Rei").
item_alias(finn, "Finn").
item_alias(kaidaros, "Kaidaros").
item_alias(voraxion, "Voraxion").
item_alias(merdain, "Merdain").
item_alias(diabolos, "Diabolos").
item_alias(rashanar, "Rashanar").
item_alias(vesh, "Vesh").
item_alias(kirin, "Kirin").
item_alias(artimeia, "Artimeia").
item_alias(le_fay, "Le Fay").
item_alias(orzachron, "Orzachron").
item_alias(alice, "Alice").
item_alias(shirra, "Shirra").
item_alias(grenzor, "Grenzor").

print_items(Item, Level, Qty) :- 
    (
    Qty > 0 ->
        item_alias(Item, Alias),
        (  
        Level =:= -1 ->
            format('~w ~s (~w) ~n', [Qty, Alias, Item])
        ;
            format('~w Level ~w ~s (~w) ~n', [Qty, Level, Alias, Item])
        )
    ;
        true
    ).

getTotalInv(Res) :-
    findall(X, item(_, _, X), List),
    sum_list(List, Res).


displayInventory :-
    forall(item(Name, Level, Qty), print_items(Name, Level, Qty)).

inventory :-
    getTotalInv(Total),
    format('Your Inventory: (~w / 100) ~n', [Total]),
    displayInventory.

throwItem :-
    inventory,
    write('Which item do you want to throw? '),
    read(Item),
    (
    item(Item, Level, Qty) ->
        (
        Qty > 0 ->
            write('You have '), print_items(Item, Level, Qty), nl,
            write('How many do you want to throw? '),
            read(ToThrow),
            item_alias(Item, Alias),
            (
            ToThrow =< Qty, ToThrow >= 0 ->
                retract(item(Item, Level, Qty)),
                NewQty is Qty - ToThrow,
                asserta(item(Item, Level, NewQty)),
                format('You threw ~w ~s ~n', [ToThrow, Alias]),
                (
                NewQty =:= 0 ->
                    format('Your ~s is completely removed from your inventory ~n', [Alias])
                ;
                    format('Your ~s is now only ~w left in your inventory ~n', [Alias, NewQty])
                )
            ;
                format('either You do not have that many ~s or you input a negative number ~nExiting...~n', [Alias]), false
            )
        ;
            format('You do not have that item in your inventory ~nExiting...~n', []), false
        )
    ;
        format('That item doesn\'t exists ~nExiting...~n', []), false
    ).