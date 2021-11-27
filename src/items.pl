% PRACTICALLY INI AVAILABLE ITEMS
:- dynamic(item_in_inventory/3). 
/*
Item yang ada:

Tools Berlevel:
Shovel
Fishing rod

Tools tanpa level:

Farming:
Carrot seed
Corn seed
Tomato seed
Potato seed
Carrot
Corn
Tomato
Potato

Ranching: Chicken, sheep, cow, egg, milk, pack of wool

Fishing:
SSR:
Anemone
Blackfin Tuna
Moonfish
SR:	
Marblefish
Longfin
Lionfish
Mooneye
Jewelfish
R:
Gudgeon
Glassfish
Eulachon
Dwarf Gourami
Angelfish
Spearfish
C:
Salmon
Tuna
Catfish
Swordfish
Mackarel
Common Carp
Tilapia
Trout
*/



% (ITEM CODENAME, ITEM NAME (string))

% ITEM GROUP : unik untuk setiap item
item_group(tools, [shovel, fishing_rod]).
item_group(farming, [carrot_seed, corn_seed, tomato_seed, potato_seed, carrot, corn, tomato, potato]).
item_group(ranching, [chicken, sheep, cow, egg, wool, milk]).
item_group(fishing, [anemone, blackfin_tuna, moonfish, marblefish, longfin, lionfish, mooneye, jewelfish, gudgeon, glassfish, eulachon, dwarf_gourami, angelfish, spearfish, salmon, tuna, catfish, swordfish, mackarel, common_carp, tilapia, trout]).

item_alias(shovel, "Shovel").
item_alias(fishing_rod, "Fishing Rod").
item_alias(carrot_seed, "Carrot Seed").
item_alias(corn_seed, "Corn Seed").
item_alias(tomato_seed, "Tomato Seed").
item_alias(potato_seed, "Potato Seed").
item_alias(carrot, "Carrot").
item_alias(corn, "Corn").
item_alias(tomato, "Tomato").
item_alias(potato, "Potato").
item_alias(chicken, "Chicken").
item_alias(sheep, "Sheep").
item_alias(cow, "Cow").
item_alias(egg, "Egg").
item_alias(wool, "Wool").
item_alias(milk, "Milk").
item_alias(anemone, "Anemone").
item_alias(blackfin_tuna, "Blackfin Tuna").
item_alias(moonfish, "Moonfish").
item_alias(marblefish, "Marblefish").
item_alias(longfin, "Longfin").
item_alias(lionfish, "Lionfish").
item_alias(mooneye, "Mooneye").
item_alias(jewelfish, "Jewelfish").
item_alias(gudgeon, "Gudgeon").
item_alias(glassfish, "Glassfish").
item_alias(eulachon, "Eulachon").
item_alias(dwarf_gourami, "Dwarf Gourami").
item_alias(angelfish, "Angelfish").
item_alias(spearfish, "Spearfish").
item_alias(salmon, "Salmon").
item_alias(tuna, "Tuna").
item_alias(catfish, "Catfish").
item_alias(swordfish, "Swordfish").
item_alias(mackarel, "Mackarel").
item_alias(common_carp, "Common Carp").
item_alias(tilapia, "Tilapia").
item_alias(trout, "Trout").


% (ITEM CODENAME, ITEM LEVEL, ITEMQTY)
% ITEM QTY BISA NOL ATAU NEGATIF (DISARANKAN TIDAK KALO EMANG GAPERLU-PERLU BANGET)
% YANG BAKAL DIDISPLAY DI INVENTORY CUMA YANG POSITIF AJA
item_in_inventory(shovel,1,1).
item_in_inventory(fishing_rod, 1, 1).
item_in_inventory(carrot_seed, 0, 2).
item_in_inventory(corn_seed, 0, 2).
item_in_inventory(tomato_seed, 0, 4).
item_in_inventory(potato_seed, 0, 3).
item_in_inventory(carrot, 0, 0).
item_in_inventory(corn, 0, 0).
item_in_inventory(tomato, 0, 0).
item_in_inventory(potato, 0, 0).
item_in_inventory(chicken, 0, 0).
item_in_inventory(sheep, 0, 0).
item_in_inventory(cow, 0, 0).
item_in_inventory(egg, 0, 0).
item_in_inventory(wool, 0, 0).
item_in_inventory(milk, 0, 0).
item_in_inventory(anemone, 0, 0).
item_in_inventory(blackfin_tuna, 0, 0).
item_in_inventory(moonfish, 0, 0).
item_in_inventory(marblefish, 0, 0).
item_in_inventory(longfin, 0, 0).
item_in_inventory(lionfish, 0, 0).
item_in_inventory(mooneye, 0, 0).
item_in_inventory(jewelfish, 0, 0).
item_in_inventory(gudgeon, 0, 0).
item_in_inventory(glassfish, 0, 0).
item_in_inventory(eulachon, 0, 0).
item_in_inventory(dwarf_gourami, 0, 0).
item_in_inventory(angelfish, 0, 0).
item_in_inventory(spearfish, 0, 0).
item_in_inventory(salmon, 0, 0).
item_in_inventory(tuna, 0, 0).
item_in_inventory(catfish, 0, 0).
item_in_inventory(swordfish, 0, 0).
item_in_inventory(mackarel, 0, 0).
item_in_inventory(common_carp, 0, 0).
item_in_inventory(tilapia, 0, 0).
item_in_inventory(trout, 0, 0).


% equipment level up mechanics (Max level: 10)
levelUpEquipment(Equipment) :-
    item_in_inventory(Equipment, Level, Qty),
    Qty == 1,
    Level < 10,
    L1 is Level+1,
    retract(item_in_inventory(Equipment, Level, Qty)),
    assertz(item_in_inventory(Equipment, L1, Qty)).