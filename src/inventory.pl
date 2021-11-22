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
    findall(X, item_in_inventory(_, _, X), List),
    sum_list(List, Res).


displayInventory :-
    forall(item_in_inventory(Name, Level, Qty), print_items(Name, Level, Qty)).

inventory :-
    getTotalInv(Total),
    format('Your Inventory: (~w / 100) ~n', [Total]),
    displayInventory.

throwItem :-
    inventory,
    write('Which item do you want to throw? '),
    read(Item),
    (
    item_in_inventory(Item, Level, Qty) ->
        (
        Qty > 0 ->
            write('You have '), print_items(Item, Level, Qty), nl,
            write('How many do you want to throw? '),
            read(ToThrow),
            item_alias(Item, Alias),
            (
            ToThrow =< Qty, ToThrow >= 0 ->
                retract(item_in_inventory(Item, Level, Qty)),
                NewQty is Qty - ToThrow,
                asserta(item_in_inventory(Item, Level, NewQty)),
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