% PRACTICALLY INI AVAILABLE ITEMS
:- dynamic(item_in_inventory/3). 

% (ITEM CODENAME, ITEM NAME (string))
item_alias(shovel, "Shovel").
item_alias(fishing_rod, "Fishing Rod").
item_alias(carrot, "Carrot").
item_alias(corn, "Corn").
item_alias(egg, "Egg").
item_alias(wool, "Pack of Wool").
item_alias(milk, "Bottle of Milk").
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

% ITEM GROUP : unik untuk setiap item
item_group(fishing, [endless_rizette, fornaxos, rolotia,
                alira, shiori, cyrus, altaireon, maxima, norza,
                rei, finn, kaidaros, voraxion, merdain, diabolos,
                rashanar, vesh, kirin, artimeia, le_fay, orzachron, alice, shirra, grenzor]).
item_group(farming, [shovel, tomato, corn, tomato_seed, corn_seed, carrot]).
item_group(ranching, [egg, wool, milk]).

% (ITEM CODENAME, ITEM LEVEL, ITEMQTY)
% ITEM QTY BISA NOL ATAU NEGATIF (DISARANKAN TIDAK KALO EMANG GAPERLU-PERLU BANGET)
% YANG BAKAL DIDISPLAY DI INVENTORY CUMA YANG POSITIF AJA
item_in_inventory(shovel,1,1).
item_in_inventory(fishing_rod, 1, 1).


% equipment level up mechanics (Max level: 10)
levelUpEquipment(Equipment) :-
    item_in_inventory(Equipment, Level, Qty),
    Qty == 1,
    Level < 10,
    L1 is Level+1,
    retract(item_in_inventory(Equipment, Level, Qty)),
    assertz(item_in_inventory(Equipment, L1, Qty)).