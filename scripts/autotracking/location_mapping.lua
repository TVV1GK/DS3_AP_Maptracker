-- use this file to map the AP location ids to your locations
-- to reference a location in Pop use @ in the beginning and then path to the section (more info: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#locations)
-- to reference an item use it's code
-- here are the SM locations as an example: https://github.com/Cyb3RGER/sm_ap_tracker/blob/main/scripts/autotracking/location_mapping.lua
LOCATION_MAPPING = {
    [100000] = {"@Firelink Shrine/FS: Broken Straight Sword/FS: Broken Straight Sword"}, 
    [100001] = {"@Firelink Shrine/FS: East-West Shield/FS: East-West Shield"},
    [100002] = {"@Firelink Shrine/FS: Master NPC/FS: Uchigatana"},   
    [100003] = {"@Firelink Shrine/FS: Master NPC/FS: Master's Attire"},  
    [100004] = {"@Firelink Shrine/FS: Master NPC/FS: Master's Gloves"},  
    
    
    [100005] = {"@Firelink Shrine/FSBT: Covetous Silver Serpent Ring/FSBT: Covetous Silver Serpent Ring"},
    [100006] = {"@Firelink Shrine/FSBT: Fire Keeper Set/FSBT: Fire Keeper Robe"},
    [100007] = {"@Firelink Shrine/FSBT: Fire Keeper Set/FSBT: Fire Keeper Gloves"},
    [100008] = {"@Firelink Shrine/FSBT: Fire Keeper Set/FSBT: Fire Keeper Skirt"},
    [100009] = {"@Firelink Shrine/FSBT: Estus Ring/FSBT: Estus Ring"},
    [100010] = {"@Firelink Shrine/FSBT: Fire Keeper Soul/FSBT: Fire Keeper Soul"},

    [100011] = {"@High Wall of Lothric/HWL: Deep Battle Axe/HWL: Deep Battle Axe"},
    [100012] = {"@High Wall of Lothric/HWL: Club/HWL: Club"},
    [100013] = {"@High Wall of Lothric/HWL: Claymore/HWL: Claymore"},
    [100014] = {"@High Wall of Lothric/HWL: Binoculars/HWL: Binoculars"},
    [100015] = {"@High Wall of Lothric/HWL: Longbow/HWL: Longbow"},
    [100016] = {"@High Wall of Lothric/HWL: Mail Breaker/HWL: Mail Breaker"},
    [100017] = {"@High Wall of Lothric/HWL: Broadsword/HWL: Broadsword"},
    [100018] = {"@High Wall of Lothric/HWL: Silver Eagle Kite Shield/HWL: Silver Eagle Kite Shield"},
    [100019] = {"@High Wall of Lothric/HWL: Astora's Straight Sword/HWL: Astora's Straight Sword"},
    [100020] = {"@High Wall of Lothric/HWL: Cell Key/HWL: Cell Key"},
    [100021] = {"@High Wall of Lothric/HWL: Rapier/HWL: Rapier"},
    [100022] = {"@High Wall of Lothric/HWL: Lucerne/HWL: Lucerne"},
    [100023] = {"@High Wall of Lothric/HWL: Banner+Basin+Way of Blue/HWL: Small Lothric Banner"},
    [100024] = {"@High Wall of Lothric/HWL: Banner+Basin+Way of Blue/HWL: Basin of Vows"},
    [100025] = {"@High Wall of Lothric/HWL: Soul of Boreal Valley Vordt/HWL: Soul of Boreal Valley Vordt"},
    [100026] = {"@High Wall of Lothric/HWL: Soul of the Dancer/HWL: Soul of the Dancer"},
    [100027] = {"@High Wall of Lothric/HWL: Banner+Basin+Way of Blue/HWL: Way of Blue Covenant"},
    [100028] = {"@High Wall of Lothric/HWL: Greirat's Ashes/HWL: Greirat's Ashes"},

    [100029] = {"@Undead Settlement/US: Small Leather Shield/US: Small Leather Shield"},
    [100030] = {"@Undead Settlement/US: Whip/US: Whip"},
    [100031] = {"@Undead Settlement/US: Reinforced Club/US: Reinforced Club"},
    [100032] = {"@Undead Settlement/US: Blue Wooden Shield+Cleric Set/US: Blue Wooden Shield"},
    [100033] = {"@Undead Settlement/US: Blue Wooden Shield+Cleric Set/US: Cleric Hat"},
    [100034] = {"@Undead Settlement/US: Blue Wooden Shield+Cleric Set/US: Cleric Blue Robe"},
    [100035] = {"@Undead Settlement/US: Blue Wooden Shield+Cleric Set/US: Cleric Gloves"},
    [100036] = {"@Undead Settlement/US: Blue Wooden Shield+Cleric Set/US: Cleric Trousers"},
    [100037] = {"@Undead Settlement/US: Mortician's Ashes/US: Mortician's Ashes"},
    [100038] = {"@Undead Settlement/US: Caestus/US: Caestus"},
    [100039] = {"@Undead Settlement/US: Plank Shield/US: Plank Shield"},
    [100040] = {"@Undead Settlement/US: Flame Stoneplate Ring/US: Flame Stoneplate Ring"},
    [100041] = {"@Undead Settlement/US: Caduceus Round Shield/US: Caduceus Round Shield"},
    [100042] = {"@Undead Settlement/US: Fire Clutch Ring/US: Fire Clutch Ring"},
    [100043] = {"@Undead Settlement/US: Partizan/US: Partizan"},
    [100044] = {"@Undead Settlement/US: Bloodbite Ring/US: Bloodbite Ring"},
    [100045] = {"@Undead Settlement/US: Red Hilted Halberd/US: Red Hilted Halberd"},
    [100046] = {"@Undead Settlement/US: Saint's Talisman/US: Saint's Talisman"},
    [100047] = {"@Undead Settlement/US: Irithyll Straight Sword/US: Irithyll Straight Sword"},
    [100048] = {"@Undead Settlement/US: Large Club/US: Large Club"},
    [100049] = {"@Undead Settlement/US: Northern Set/US: Northern Helm"},
    [100050] = {"@Undead Settlement/US: Northern Set/US: Northern Armor"},
    [100051] = {"@Undead Settlement/US: Northern Set/US: Northern Gloves"},
    [100052] = {"@Undead Settlement/US: Northern Set/US: Northern Trousers"},
    [100053] = {"@Undead Settlement/US: Flynn's Ring/US: Flynn's Ring"},
    [100054] = {"@Undead Settlement/US: Mirrah Set/US: Mirrah Vest"},
    [100055] = {"@Undead Settlement/US: Mirrah Set/US: Mirrah Gloves"},
    [100056] = {"@Undead Settlement/US: Mirrah Set/US: Mirrah Trousers"},
    [100057] = {"@Undead Settlement/US: Chloranthy Ring/US: Chloranthy Ring"},
    [100058] = {"@Undead Settlement/US: Loincloth/US: Loincloth"},
    [100059] = {"@Undead Settlement/US: Wargod Wooden Shield/US: Wargod Wooden Shield"},
    [100060] = {"@Undead Settlement/US: Loretta's Bone/US: Loretta's Bone"},
    [100061] = {"@Undead Settlement/US: Hand Axe/US: Hand Axe"},
    [100062] = {"@Undead Settlement/US: Great Scythe/US: Great Scythe"},
    [100063] = {"@Undead Settlement/US: Soul of the Rotted Greatwood/US: Soul of the Rotted Greatwood"},
    [100064] = {"@Undead Settlement/US: Hawk Ring/US: Hawk Ring"},
    [100065] = {"@Undead Settlement/US: Warrior of Sunlight Covenant/US: Warrior of Sunlight Covenant"},

    [100066] = {"@Road of Sacrifices/RS: Brigand Twindaggers/RS: Brigand Twindaggers"},
    [100067] = {"@Road of Sacrifices/RS: Brigand Set/RS: Brigand Hood"},
    [100068] = {"@Road of Sacrifices/RS: Brigand Set/RS: Brigand Armor"},
    [100069] = {"@Road of Sacrifices/RS: Brigand Set/RS: Brigand Gauntlets"},
    [100070] = {"@Road of Sacrifices/RS: Brigand Set/RS: Brigand Trousers"},
    [100071] = {"@Road of Sacrifices/RS: Butcher Knife/RS: Butcher Knife"},
    [100072] = {"@Road of Sacrifices/RS: Brigand Axe/RS: Brigand Axe"},
    [100073] = {"@Road of Sacrifices/RS: Divine Tome+Morne's Ring/RS: Braille Divine Tome of Carim"},
    [100074] = {"@Road of Sacrifices/RS: Divine Tome+Morne's Ring/RS: Morne's Ring"},
    [100075] = {"@Road of Sacrifices/RS: Twin Dragon Greatshield/RS: Twin Dragon Greatshield"},
    [100076] = {"@Road of Sacrifices/RS: Heretic's Staff/RS: Heretic's Staff"},
    [100077] = {"@Road of Sacrifices/RS: Sorcerer's Set/RS: Sorcerer Hood"},
    [100078] = {"@Road of Sacrifices/RS: Sorcerer's Set/RS: Sorcerer Robe"},
    [100079] = {"@Road of Sacrifices/RS: Sorcerer's Set/RS: Sorcerer Gloves"},
    [100080] = {"@Road of Sacrifices/RS: Sorcerer's Set/RS: Sorcerer Trousers"},
    [100081] = {"@Road of Sacrifices/RS: Sage Ring/RS: Sage Ring"},
    [100082] = {"@Road of Sacrifices/RS: Fallen Knight Set/RS: Fallen Knight Helm"},
    [100083] = {"@Road of Sacrifices/RS: Fallen Knight Set/RS: Fallen Knight Armor"},
    [100084] = {"@Road of Sacrifices/RS: Fallen Knight Set/RS: Fallen Knight Gauntlets"},
    [100085] = {"@Road of Sacrifices/RS: Fallen Knight Set/RS: Fallen Knight Trousers"},
    [100086] = {"@Road of Sacrifices/RS: Conjurator Set/RS: Conjurator Hood"},
    [100087] = {"@Road of Sacrifices/RS: Conjurator Set/RS: Conjurator Robe"},
    [100088] = {"@Road of Sacrifices/RS: Conjurator Set/RS: Conjurator Manchettes"},
    [100089] = {"@Road of Sacrifices/RS: Conjurator Set/RS: Conjurator Boots"},
    [100090] = {"@Road of Sacrifices/RS: Great Swamp Pyromancy Tome/RS: Great Swamp Pyromancy Tome"},
    [100091] = {"@Road of Sacrifices/RS: Great Club+Exile Greatsword/RS: Great Club"},
    [100092] = {"@Road of Sacrifices/RS: Great Club+Exile Greatsword/RS: Exile Greatsword"},
    [100093] = {"@Road of Sacrifices/RS: Farron Coal/RS: Farron Coal"},
    [100094] = {"@Road of Sacrifices/RS: Sellsword Twinblades/RS: Sellsword Twinblades"},
    [100095] = {"@Road of Sacrifices/RS: Sellsword Set/RS: Sellsword Helm"},
    [100096] = {"@Road of Sacrifices/RS: Sellsword Set/RS: Sellsword Armor"},
    [100097] = {"@Road of Sacrifices/RS: Sellsword Set/RS: Sellsword Gauntlet"},
    [100098] = {"@Road of Sacrifices/RS: Sellsword Set/RS: Sellsword Trousers"},
    [100099] = {"@Road of Sacrifices/RS: Golden Falcon Shield/RS: Golden Falcon Shield"},
    [100100] = {"@Road of Sacrifices/RS: Herald Set/RS: Herald Helm"},
    [100101] = {"@Road of Sacrifices/RS: Herald Set/RS: Herald Armor"},
    [100102] = {"@Road of Sacrifices/RS: Herald Set/RS: Herald Gloves"},
    [100103] = {"@Road of Sacrifices/RS: Herald Set/RS: Herald Trousers"},
    [100104] = {"@Road of Sacrifices/RS: Grass Crest Shield/RS: Grass Crest Shield"},
    [100105] = {"@Road of Sacrifices/RS: Soul of a Crystal Sage/RS: Soul of a Crystal Sage"},
    [100106] = {"@Road of Sacrifices/RS: Great Swamp Ring/RS: Great Swamp Ring"},

    [100107] = {"@Cathedral of the Deep/CD: Paladin's Ashes/CD: Paladin's Ashes"},
    [100108] = {"@Cathedral of the Deep/CD: Spider Shield/CD: Spider Shield"},
    [100109] = {"@Cathedral of the Deep/CD: Crest Shield/CD: Crest Shield"},
    [100110] = {"@Cathedral of the Deep/CD: Notched Whip/CD: Notched Whip"},
    [100111] = {"@Cathedral of the Deep/CD: Astora Greatsword/CD: Astora Greatsword"},
    [100112] = {"@Cathedral of the Deep/CD: Executioner's Greatsword/CD: Executioner's Greatsword"},
    [100113] = {"@Cathedral of the Deep/CD: Curse Ward Greatshield/CD: Curse Ward Greatshield"},
    [100114] = {"@Cathedral of the Deep/CD: Saint-tree Bellvine/CD: Saint-tree Bellvine"},
    [100115] = {"@Cathedral of the Deep/CD: Poisonbite Ring/CD: Poisonbite Ring"},
    [100116] = {"@Cathedral of the Deep/CD: Lloyd's Sword Ring/CD: Lloyd's Sword Ring"},
    [100117] = {"@Cathedral of the Deep/CD: Seek Guidance/CD: Seek Guidance"},
    [100118] = {"@Cathedral of the Deep/CD: Aldrich's Sapphire/CD: Aldrich's Sapphire"},
    [100119] = {"@Cathedral of the Deep/CD: Deep Braille Divine Tome/CD: Deep Braille Divine Tome"},
    [100120] = {"@Cathedral of the Deep/CD: Saint Bident/CD: Saint Bident"},
    [100121] = {"@Cathedral of the Deep/CD: Maiden Set/CD: Maiden Hood"},
    [100122] = {"@Cathedral of the Deep/CD: Maiden Set/CD: Maiden Robe"},
    [100123] = {"@Cathedral of the Deep/CD: Maiden Set/CD: Maiden Gloves"},
    [100124] = {"@Cathedral of the Deep/CD: Maiden Set/CD: Maiden Skirt"},
    [100125] = {"@Cathedral of the Deep/CD: Drang Armor/CD: Drang Armor"},
    [100126] = {"@Cathedral of the Deep/CD: Drang Gauntlets/CD: Drang Gauntlets"},
    [100127] = {"@Cathedral of the Deep/CD: Drang Shoes/CD: Drang Shoes"},
    [100128] = {"@Cathedral of the Deep/CD: Drang Hammers/CD: Drang Hammers"},
    [100129] = {"@Cathedral of the Deep/CD: Deep Ring/CD: Deep Ring"},
    [100130] = {"@Cathedral of the Deep/CD: Small Doll+Archdeacon Set/CD: Archdeacon White Crown"},
    [100131] = {"@Cathedral of the Deep/CD: Small Doll+Archdeacon Set/CD: Archdeacon Holy Garb"},
    [100132] = {"@Cathedral of the Deep/CD: Small Doll+Archdeacon Set/CD: Archdeacon Skirt"},
    [100133] = {"@Cathedral of the Deep/CD: Arbalest/CD: Arbalest"},
    [100134] = {"@Cathedral of the Deep/CD: Small Doll+Archdeacon Set/CD: Small Doll"},
    [100135] = {"@Cathedral of the Deep/CD: Soul of the Deacons of the Deep/CD: Soul of the Deacons of the Deep"},
    [100136] = {"@Cathedral of the Deep/CD: Rosaria's Fingers Covenant/CD: Rosaria's Fingers Covenant"},

    [100137] = {"@Farron Keep/FK: Ragged Mask/FK: Ragged Mask"},
    [100138] = {"@Farron Keep/FK: Iron Flesh/FK: Iron Flesh"},
    [100139] = {"@Farron Keep/FK: Golden Scroll/FK: Golden Scroll"},
    [100140] = {"@Farron Keep/FK: Antiquated Armor Set/FK: Antiquated Dress"},
    [100141] = {"@Farron Keep/FK: Antiquated Armor Set/FK: Antiquated Gloves"},
    [100142] = {"@Farron Keep/FK: Antiquated Armor Set/FK: Antiquated Skirt"},
    [100143] = {"@Farron Keep/FK: Nameless Knight Set/FK: Nameless Knight Helm"},
    [100144] = {"@Farron Keep/FK: Nameless Knight Set/FK: Nameless Knight Armor"},
    [100145] = {"@Farron Keep/FK: Nameless Knight Set/FK: Nameless Knight Gauntlets"},
    [100146] = {"@Farron Keep/FK: Nameless Knight Set/FK: Nameless Knight Leggings"},
    [100147] = {"@Farron Keep/FK: Sunlight Talisman/FK: Sunlight Talisman"},
    [100148] = {"@Farron Keep/FK: Wolf's Blood Swordgrass/FK: Wolf's Blood Swordgrass"},
    [100149] = {"@Farron Keep/FK: Greatsword/FK: Greatsword"},
    [100150] = {"@Farron Keep/FK: Sage's Coal/FK: Sage's Coal"},
    [100151] = {"@Farron Keep/FK: Stone Parma/FK: Stone Parma"},
    [100152] = {"@Farron Keep/FK: Sage's Scroll/FK: Sage's Scroll"},
    [100153] = {"@Farron Keep/FK: Crown of Dusk/FK: Crown of Dusk"},
    [100154] = {"@Farron Keep/FK: Lingering Dragoncrest Ring/FK: Lingering Dragoncrest Ring"},
    [100155] = {"@Farron Keep/FK: Pharis's Hat+Black Bow of Pharis/FK: Pharis's Hat"},
    [100156] = {"@Farron Keep/FK: Pharis's Hat+Black Bow of Pharis/FK: Black Bow of Pharis"},
    [100157] = {"@Farron Keep/FK: Dreamchaser's Ashes/FK: Dreamchaser's Ashes"},
    [100158] = {"@Farron Keep/FK: Great Axe/FK: Great Axe"},
    [100159] = {"@Farron Keep/FK: Dragon Crest Shield/FK: Dragon Crest Shield"},
    [100160] = {"@Farron Keep/FK: Lightning Spear/FK: Lightning Spear"},
    [100161] = {"@Farron Keep/FK: Atonement/FK: Atonement"},
    [100162] = {"@Farron Keep/FK: Great Magic Weapon/FK: Great Magic Weapon"},
    [100163] = {"@Farron Keep/FK: Cinders+Soul of Abyss Watchers/FK: Cinders of a Lord - Abyss Watchers"},
    [100164] = {"@Farron Keep/FK: Cinders+Soul of Abyss Watchers/FK: Soul of the Blood of the Wolf"},
    [100165] = {"@Farron Keep/FK: Soul of a Stray Demon/FK: Soul of a Stray Demon"},
    [100166] = {"@Farron Keep/FK: Watchdogs of Farron Covenant/FK: Watchdogs of Farron Covenant"},

    [100167] = {"@Catacombs of Carthus/CC: Carthus Pyromancy Tome/CC: Carthus Pyromancy Tome"},
    [100168] = {"@Catacombs of Carthus/CC: Carthus Milkring/CC: Carthus Milkring"},
    [100169] = {"@Catacombs of Carthus/CC: Grave Warden's Ashes/CC: Grave Warden's Ashes"},
    [100170] = {"@Catacombs of Carthus/CC: Carthus Bloodring/CC: Carthus Bloodring"},
    [100171] = {"@Catacombs of Carthus/CC: Grave Warden Pyromancy Tome/CC: Grave Warden Pyromancy Tome"},
    [100172] = {"@Catacombs of Carthus/CC: Old Sage's Blindfold+Witch's Ring/CC: Old Sage's Blindfold"},
    [100173] = {"@Catacombs of Carthus/CC: Old Sage's Blindfold+Witch's Ring/CC: Witch's Ring"},
    [100174] = {"@Catacombs of Carthus/CC: Black Blade/CC: Black Blade"},
    [100175] = {"@Catacombs of Carthus/CC: Soul of High Lord Wolnir/CC: Soul of High Lord Wolnir"},
    [100176] = {"@Catacombs of Carthus/CC: Soul of a Demon/CC: Soul of a Demon"},

    [100177] = {"@Smouldering Lake/SL: Shield of Want/SL: Shield of Want"},
    [100178] = {"@Smouldering Lake/SL: Speckled Stoneplate Ring/SL: Speckled Stoneplate Ring"},
    [100179] = {"@Smouldering Lake/SL: Dragonrider Bow/SL: Dragonrider Bow"},
    [100180] = {"@Smouldering Lake/SL: Lightning Stake/SL: Lightning Stake"},
    [100181] = {"@Smouldering Lake/SL: Izalith Pyromancy Tome/SL: Izalith Pyromancy Tome"},
    [100182] = {"@Smouldering Lake/SL: Black Knight Sword/SL: Black Knight Sword"},
    [100183] = {"@Smouldering Lake/SL: Quelana Pyromancy Tome/SL: Quelana Pyromancy Tome"},
    [100184] = {"@Smouldering Lake/SL: Toxic Mist/SL: Toxic Mist"},
    [100185] = {"@Smouldering Lake/SL: White Hair Talisman/SL: White Hair Talisman"},
    [100186] = {"@Smouldering Lake/SL: Izalith Staff/SL: Izalith Staff"},
    [100187] = {"@Smouldering Lake/SL: Sacred Flame/SL: Sacred Flame"},
    [100188] = {"@Smouldering Lake/SL: Fume Ultra Greatsword+Black Iron Greatshield/SL: Fume Ultra Greatsword"},
    [100189] = {"@Smouldering Lake/SL: Fume Ultra Greatsword+Black Iron Greatshield/SL: Black Iron Greatshield"},
    [100190] = {"@Smouldering Lake/SL: Soul of the Old Demon King/SL: Soul of the Old Demon King"},
    [100191] = {"@Smouldering Lake/SL: Knight Slayer Tsorig NPC/SL: Knight Slayer's Ring"},

    [100192] = {"@Irithyll of the Boreal Valley/IBV: Dorhys' Gnawing/IBV: Dorhys' Gnawing"},
    [100193] = {"@Irithyll of the Boreal Valley/IBV: Witchtree Branch/IBV: Witchtree Branch"},
    [100194] = {"@Irithyll of the Boreal Valley/IBV: Magic Clutch Ring/IBV: Magic Clutch Ring"},
    [100195] = {"@Irithyll of the Boreal Valley/IBV: Ring of the Sun's First Born/IBV: Ring of the Sun's First Born"},
    [100196] = {"@Irithyll of the Boreal Valley/IBV: Roster of Knights/IBV: Roster of Knights"},
    [100197] = {"@Irithyll of the Boreal Valley/IBV: Pontiff's Right Eye/IBV: Pontiff's Right Eye"},
    [100198] = {"@Irithyll of the Boreal Valley/IBV: Yorshka's Spear/IBV: Yorshka's Spear"},
    [100199] = {"@Irithyll of the Boreal Valley/IBV: Great Heal/IBV: Great Heal"},
    [100200] = {"@Irithyll of the Boreal Valley/IBV: Smough's Great Hammer+Leo Ring/IBV: Smough's Great Hammer"},
    [100201] = {"@Irithyll of the Boreal Valley/IBV: Smough's Great Hammer+Leo Ring/IBV: Leo Ring"},
    [100202] = {"@Irithyll of the Boreal Valley/IBV: Excrement-covered Ashes/IBV: Excrement-covered Ashes"},
    [100203] = {"@Irithyll of the Boreal Valley/IBV: Dark Stoneplate Ring/IBV: Dark Stoneplate Ring"},
    [100204] = {"@Irithyll of the Boreal Valley/IBV: Easterner's Ashes/IBV: Easterner's Ashes"},
    [100205] = {"@Irithyll of the Boreal Valley/IBV: Painting Guardian's Curved Sword/IBV: Painting Guardian's Curved Sword"},
    [100206] = {"@Irithyll of the Boreal Valley/IBV: Painting Guardian Set/IBV: Painting Guardian Hood"},
    [100207] = {"@Irithyll of the Boreal Valley/IBV: Painting Guardian Set/IBV: Painting Guardian Gown"},
    [100208] = {"@Irithyll of the Boreal Valley/IBV: Painting Guardian Set/IBV: Painting Guardian Gloves"},
    [100209] = {"@Irithyll of the Boreal Valley/IBV: Painting Guardian Set/IBV: Painting Guardian Waistcloth"},
    [100210] = {"@Irithyll of the Boreal Valley/IBV: Dragonslayer Greatbow/IBV: Dragonslayer Greatbow"},
    [100211] = {"@Irithyll of the Boreal Valley/IBV: Reversal Ring/IBV: Reversal Ring"},
    [100212] = {"@Irithyll of the Boreal Valley/IBV: Brass Set/IBV: Brass Helm"},
    [100213] = {"@Irithyll of the Boreal Valley/IBV: Brass Set/IBV: Brass Armor"},
    [100214] = {"@Irithyll of the Boreal Valley/IBV: Brass Set/IBV: Brass Gauntlets"},
    [100215] = {"@Irithyll of the Boreal Valley/IBV: Brass Set/IBV: Brass Leggings"},
    [100216] = {"@Irithyll of the Boreal Valley/IBV: Ring of Favor/IBV: Ring of Favor"},
    [100217] = {"@Irithyll of the Boreal Valley/IBV: Golden Ritual Spear/IBV: Golden Ritual Spear"},
    [100218] = {"@Irithyll of the Boreal Valley/IBV: Soul of Pontiff Sulyvahn/IBV: Soul of Pontiff Sulyvahn"},
    [100219] = {"@Irithyll of the Boreal Valley/IBV: Aldrich Faithful Covenant/IBV: Aldrich Faithful Covenant"},

    [100253] = {"@Anor Londo/AL: Giant's Coal/AL: Giant's Coal"},
    [100254] = {"@Anor Londo/AL: Sun Princess Ring/AL: Sun Princess Ring"},
    [100255] = {"@Anor Londo/AL: Aldrich's Ruby/AL: Aldrich's Ruby"},
    [100256] = {"@Anor Londo/AL: Cinders+Soul of Aldrich/AL: Cinders of a Lord - Aldrich"},
    [100257] = {"@Anor Londo/AL: Cinders+Soul of Aldrich/AL: Soul of Aldrich"},

    [100221] = {"@Irithyll Dungeon/ID: Bellowing Dragoncrest Ring/ID: Bellowing Dragoncrest Ring"},
    [100222] = {"@Irithyll Dungeon/ID: Jailbreaker's Key/ID: Jailbreaker's Key"},
    [100223] = {"@Irithyll Dungeon/ID: Prisoner Chief's Ashes/ID: Prisoner Chief's Ashes"},
    [100224] = {"@Irithyll Dungeon/ID: Old Sorcerer Set/ID: Old Sorcerer Hat"},
    [100225] = {"@Irithyll Dungeon/ID: Old Sorcerer Set/ID: Old Sorcerer Coat"},
    [100226] = {"@Irithyll Dungeon/ID: Old Sorcerer Set/ID: Old Sorcerer Gauntlets"},
    [100227] = {"@Irithyll Dungeon/ID: Old Sorcerer Set/ID: Old Sorcerer Boots"},
    [100228] = {"@Irithyll Dungeon/ID: Great Magic Shield/ID: Great Magic Shield"},
    [100229] = {"@Irithyll Dungeon/ID: Dragon Torso Stone/ID: Dragon Torso Stone"},
    [100230] = {"@Irithyll Dungeon/ID: Lightning Blade/ID: Lightning Blade"},
    [100231] = {"@Irithyll Dungeon/ID: Profaned Coal/ID: Profaned Coal"},
    [100232] = {"@Irithyll Dungeon/ID: Xanthous Ashes/ID: Xanthous Ashes"},
    [100233] = {"@Irithyll Dungeon/ID: Old Cell Key+Dark Clutch Ring/ID: Old Cell Key"},
    [100234] = {"@Irithyll Dungeon/ID: Pickaxe/ID: Pickaxe"},
    [100235] = {"@Irithyll Dungeon/ID: Profaned Flame/ID: Profaned Flame"},
    [100236] = {"@Irithyll Dungeon/ID: Covetous Gold Serpent Ring/ID: Covetous Gold Serpent Ring"},
    [100237] = {"@Irithyll Dungeon/ID: Jailer's Key Ring/ID: Jailer's Key Ring"},
    [100238] = {"@Irithyll Dungeon/ID: Dusk Crown Ring/ID: Dusk Crown Ring"},
    [100239] = {"@Irithyll Dungeon/ID: Old Cell Key+Dark Clutch Ring/ID: Dark Clutch Ring"},

    [100240] = {"@Profaned Capital/PC: Cursebite Ring/PC: Cursebite Ring"},
    [100241] = {"@Profaned Capital/PC: Court Sorcerer Set+Wrath of the Gods/PC: Court Sorcerer Hood"},
    [100242] = {"@Profaned Capital/PC: Court Sorcerer Set+Wrath of the Gods/PC: Court Sorcerer Robe"},
    [100243] = {"@Profaned Capital/PC: Court Sorcerer Set+Wrath of the Gods/PC: Court Sorcerer Gloves"},
    [100244] = {"@Profaned Capital/PC: Court Sorcerer Set+Wrath of the Gods/PC: Court Sorcerer Trousers"},
    [100245] = {"@Profaned Capital/PC: Court Sorcerer Set+Wrath of the Gods/PC: Wrath of the Gods"},
    [100246] = {"@Profaned Capital/PC: Logan's Scroll/PC: Logan's Scroll"},
    [100247] = {"@Profaned Capital/PC: Eleonora/PC: Eleonora"},
    [100248] = {"@Profaned Capital/PC: Court Sorcerer's Staff/PC: Court Sorcerer's Staff"},
    [100249] = {"@Profaned Capital/PC: Greatshield of Glory/PC: Greatshield of Glory"},
    [100250] = {"@Profaned Capital/PC: Storm Ruler/PC: Storm Ruler"},
    [100251] = {"@Profaned Capital/PC: Cinders+Soul of Yhorm the Giant/PC: Cinders of a Lord - Yhorm the Giant"},
    [100252] = {"@Profaned Capital/PC: Cinders+Soul of Yhorm the Giant/PC: Soul of Yhorm the Giant"},

    [100277] = {"@Consumed King's Garden/CKG: Dragonscale Ring/CKG: Dragonscale Ring"},
    [100278] = {"@Consumed King's Garden/CKG: Shadow Set/CKG: Shadow Mask"},
    [100279] = {"@Consumed King's Garden/CKG: Shadow Set/CKG: Shadow Garb"},
    [100280] = {"@Consumed King's Garden/CKG: Shadow Set/CKG: Shadow Gauntlets"},
    [100281] = {"@Consumed King's Garden/CKG: Shadow Set/CKG: Shadow Leggings"},
    [100282] = {"@Consumed King's Garden/CKG: Claw/CKG: Claw"},
    [100283] = {"@Consumed King's Garden/CKG: Soul of Consumed Oceiros/CKG: Soul of Consumed Oceiros"},

    [100298] = {"@Untended Graves/UG: Ashen Estus Ring/UG: Ashen Estus Ring"},
    [100299] = {"@Untended Graves/UG: Black Knight Glaive/UG: Black Knight Glaive"},
    [100300] = {"@Untended Graves/UG: Hornet Ring/UG: Hornet Ring"},
    [100301] = {"@Untended Graves/UG: Chaos Blade/UG: Chaos Blade"},
    [100302] = {"@Untended Graves/UG: Blacksmith Hammer/UG: Blacksmith Hammer"},
    [100303] = {"@Untended Graves/UG: Eyes of a Fire Keeper/UG: Eyes of a Fire Keeper"},
    [100304] = {"@Untended Graves/UG: Coiled Sword Fragment/UG: Coiled Sword Fragment"},
    [100305] = {"@Untended Graves/UG: Soul of Champion Gundyr/UG: Soul of Champion Gundyr"},

    [100258] = {"@Lothric Castle/LC: Prayer Set/LC: Hood of Prayer"},
    [100259] = {"@Lothric Castle/LC: Prayer Set/LC: Robe of Prayer"},
    [100260] = {"@Lothric Castle/LC: Prayer Set/LC: Skirt of Prayer"},
    [100261] = {"@Lothric Castle/LC: Sacred Bloom Shield/LC: Sacred Bloom Shield"},
    [100262] = {"@Lothric Castle/LC: Winged Knight Set/LC: Winged Knight Helm"},
    [100263] = {"@Lothric Castle/LC: Winged Knight Set/LC: Winged Knight Armor"},
    [100264] = {"@Lothric Castle/LC: Winged Knight Set/LC: Winged Knight Gauntlets"},
    [100265] = {"@Lothric Castle/LC: Winged Knight Set/LC: Winged Knight Leggings"},
    [100266] = {"@Lothric Castle/LC: Greatlance/LC: Greatlance"},
    [100267] = {"@Lothric Castle/LC: Sniper Crossbow/LC: Sniper Crossbow"},
    [100268] = {"@Lothric Castle/LC: Spirit Tree Crest Shield/LC: Spirit Tree Crest Shield"},
    [100269] = {"@Lothric Castle/LC: Red Tearstone Ring/LC: Red Tearstone Ring"},
    [100270] = {"@Lothric Castle/LC: Caitha's Chime/LC: Caitha's Chime"},
    [100271] = {"@Lothric Castle/LC: Braille Divine Tome of Lothric/LC: Braille Divine Tome of Lothric"},
    [100272] = {"@Lothric Castle/LC: Knight's Ring/LC: Knight's Ring"},
    [100273] = {"@Lothric Castle/LC: Sunlight Straight Sword/LC: Sunlight Straight Sword"},
    [100274] = {"@Lothric Castle/LC: Soul of Dragonslayer Armour/LC: Soul of Dragonslayer Armour"},
    [100275] = {"@Lothric Castle/LC: Grand Archives Key+Gotthard Twinswords/LC: Grand Archives Key"},
    [100276] = {"@Lothric Castle/LC: Grand Archives Key+Gotthard Twinswords/LC: Gotthard Twinswords"},

    [100284] = {"@Grand Archives/GA: Avelyn/GA: Avelyn"},
    [100285] = {"@Grand Archives/GA: Witch's Locks+Power Within/GA: Witch's Locks"},
    [100286] = {"@Grand Archives/GA: Witch's Locks+Power Within/GA: Power Within"},
    [100287] = {"@Grand Archives/GA: Scholar Ring/GA: Scholar Ring"},
    [100288] = {"@Grand Archives/GA: Soul Stream/GA: Soul Stream"},
    [100289] = {"@Grand Archives/GA: Fleshbite Ring/GA: Fleshbite Ring"},
    [100290] = {"@Grand Archives/GA: Crystal Chime/GA: Crystal Chime"},
    [100291] = {"@Grand Archives/GA: Hostile NPC Trio/GA: Golden Wing Crest Shield"},
    [100292] = {"@Grand Archives/GA: Hostile NPC Trio/GA: Onikiri and Ubadachi"},
    [100293] = {"@Grand Archives/GA: Hunter's Ring/GA: Hunter's Ring"},
    [100294] = {"@Grand Archives/GA: Divine Pillars of Light/GA: Divine Pillars of Light"},
    [100295] = {"@Grand Archives/GA: Cinders+Soul of Lothric Prince/GA: Cinders of a Lord - Lothric Prince"},
    [100296] = {"@Grand Archives/GA: Cinders+Soul of Lothric Prince/GA: Soul of the Twin Princes"},
    [100297] = {"@Grand Archives/GA: Hostile NPC Trio/GA: Sage's Crystal Staff"},

    [100306] = {"@Archdragon Peak/AP: Lightning Clutch Ring/AP: Lightning Clutch Ring"},
    [100307] = {"@Archdragon Peak/AP: Ancient Dragon Greatshield/AP: Ancient Dragon Greatshield"},
    [100308] = {"@Archdragon Peak/AP: Ring of Steel Protection/AP: Ring of Steel Protection"},
    [100309] = {"@Archdragon Peak/AP: Calamity Ring (use POTG)/AP: Calamity Ring"},
    [100310] = {"@Archdragon Peak/AP: Drakeblood Greatsword/AP: Drakeblood Greatsword"},
    [100311] = {"@Archdragon Peak/AP: Dragonslayer Spear/AP: Dragonslayer Spear"},
    [100312] = {"@Archdragon Peak/AP: Thunder Stoneplate Ring/AP: Thunder Stoneplate Ring"},
    [100313] = {"@Archdragon Peak/AP: Great Magic Barrier/AP: Great Magic Barrier"},
    [100314] = {"@Archdragon Peak/AP: Dragon Chaser's Ashes/AP: Dragon Chaser's Ashes"},
    [100315] = {"@Archdragon Peak/AP: Twinkling Dragon Torso Stone/AP: Twinkling Dragon Torso Stone"},
    [100316] = {"@Archdragon Peak/AP: Dragonslayer Set/AP: Dragonslayer Helm"},
    [100317] = {"@Archdragon Peak/AP: Dragonslayer Set/AP: Dragonslayer Armor"},
    [100318] = {"@Archdragon Peak/AP: Dragonslayer Set/AP: Dragonslayer Gauntlets"},
    [100319] = {"@Archdragon Peak/AP: Dragonslayer Set/AP: Dragonslayer Leggings"},
    [100320] = {"@Archdragon Peak/AP: Ricard's Rapier/AP: Ricard's Rapier"},
    [100321] = {"@Archdragon Peak/AP: Soul of the Nameless King/AP: Soul of the Nameless King"},
}
