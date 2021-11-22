% PRACTICALLY INI AVAILABLE ITEMS


:- dynamic(item_in_inventory/3). 

% ITEM ALIAS GUA BIKIN STATIC KARENA SEMUA HARUS PREDEFINED DARI AWAL ITEM APA AJA YANG BISA DIAKSES DI GAME
% (ITEM CODENAME, ITEM NAME (string))
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

% ITEM GROUP JUGA STATIC KARENA SEMUA HARUS PREDEFINED DARI AWAL ITEM APA AJA YANG BISA DIAKSES DI GAME
% NOTE, GABOLEH ADA ITEM YANG ADA DI DUA ITEM GROUPS YANG BERBEDA

item_group(waifu_thirafi, [utaha_kasumigaoka, shiori, endless_rizette]).
item_group(istri_thirafi, [eriri_spencer]).
item_group(bodyguard_thirafi, [fornaxos, rolotia, alira, shiori, cyrus, altaireon, maxima, norza, rei, finn, kaidaros, voraxion, merdain, diabolos, rashanar, vesh, kirin, artimeia, le_fay, orzachron, alice, shirra, grenzor]).


% (ITEM CODENAME, ITEM LEVEL, ITEMQTY)
% ITEM QTY BISA NOL ATAU NEGATIF (DISARANKAN TIDAK KALO EMANG GAPERLU-PERLU BANGET)
% YANG BAKAL DIDISPLAY DI INVENTORY CUMA YANG POSITIF AJA
item_in_inventory(shovel,1,1).
item_in_inventory(fishing_rod, 1, 1).
item_in_inventory(carrot, -1, 3).
item_in_inventory(corn, -1, 4).
item_in_inventory(egg, -1, 3).
item_in_inventory(salmon, -1, 5).
item_in_inventory(tuna, -1, 3).
item_in_inventory(utaha_kasumigaoka, 100, 0).
item_in_inventory(eriri_spencer, 100, 1).