# Farming Sun
> Permainan bertani berbasis CLI menggunakan _GNU Prolog_ - Tugas Besar Mata Kuliah IF2121 Logika Komputasional



## Table of Contents
* [Informasi Umum](#informasi-umum)
* [Struktur](#struktur)
* [Cara Bermain](#cara-bermain)
* [Anggota](#anggota)

## Informasi Umum
_Farming Sun_ adalah permainan bertani berbasis CLI menggunakan GNU Prolog. Permainan ini mensimulasikan sebuah kehidupan bertani dimana pemain dapat bercocok tanam, melakukan kegiatan memancing, dan kegiatan beternak. Pemain mempunyai tujuan akhir mengumpulkan 20.000 _gold_ dalam waktu < 2 bulan. Pemain dapat menjual barang-barang yang telah diperoleh atau menyelesaikan _quests_ untuk mendapatkan _gold_. Permainan ini dibuat dengan bahasa Prolog (GNU Prolog `1.4.5 WSL2/ 1.5.0 Windows`) dengan mengimplementasikan paradigma pemrograman deklaratif dan _dynamic predicate_ dalam bahasa Prolog.

## Struktur
* `farming.pl`: pengaturan kegiatan bertani (`dig., plant. harvest.`)
* `fishing.pl`: pengaturan kegiatan memancing (`fish.`)
* `game.pl`: pengaturan permainan utama
* `globals.pl`: penyimpanan predikat dinamis secara umum sehingga dapat dipakai di fungsi-fungsi lainnya
* `house.pl`: pengaturan kegiatan yang dapat dilakukan di rumah
* `inventory.pl`: pengaturan _inventory_ pemain
* `items.pl`: pengaturan _item_ yang ada di permainan
* `main.pl`: program utama, **[IMPORTANT]** kompilasi program ini untuk memainkan permainan
* `map.pl`: pengaturan peta dan mekanisme pergerakan pemain
* `market.pl`: pengaturan sistem transaksi di permainan (membeli/menjual barang)
* `quest.pl`: pengaturan sistem pengambilan _quest_ di permainan
* `ranching.pl`: pengaturan sistem beternak (`ranch.`)

## Cara Bermain
1. Pastikan anda sudah mempunyai _compiler_ GNU Prolog (disarankan menggunakan versi `1.5.0`)
2. Buka terminal GNU Prolog Anda, lalu navigasikan ke folder `src`
3. Lakukan kompilasi terhadap file `main.pl` (pastikan sudah berada di direktori _game_)
4. Gunakan perintah `startGame.` untuk membuka menu awal, lalu menu `start.` untuk memulai permainan.
5. Pilihlah _role_ awal Anda (fisherman, farmer, atau rancher). _Role_ ini akan menentukan _perks_ tambahan yang akan Anda terima saat bermain.
6. _Good luck, have fun!_

## Anggota
* [13520124 Owen Christian Wijaya](#https://github.com/reverseon)
* [13520139 Fachry Dennis Heraldi](#https://github.com/dennisheraldi)
* [13520153 Vito Ghifari](#https://github.com/VanillaMacchiato)
* [13520156 Thirafi Najwan Kurniatama](#https://github.com/reverseon)
