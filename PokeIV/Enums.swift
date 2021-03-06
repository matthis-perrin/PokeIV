//
//  Enums.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import RealmSwift


enum PokemonNum: NSNumber {
    case Unknown = 0
    case Bulbasaur = 1
    case Ivysaur = 2
    case Venusaur = 3
    case Charmander = 4
    case Charmeleon = 5
    case Charizard = 6
    case Squirtle = 7
    case Wartortle = 8
    case Blastoise = 9
    case Caterpie = 10
    case Metapod = 11
    case Butterfree = 12
    case Weedle = 13
    case Kakuna = 14
    case Beedrill = 15
    case Pidgey = 16
    case Pidgeotto = 17
    case Pidgeot = 18
    case Rattata = 19
    case Raticate = 20
    case Spearow = 21
    case Fearow = 22
    case Ekans = 23
    case Arbok = 24
    case Pikachu = 25
    case Raichu = 26
    case Sandshrew = 27
    case Sandslash = 28
    case NidoranFemale = 29
    case Nidorina = 30
    case Nidoqueen = 31
    case NidoranMale = 32
    case Nidorino = 33
    case Nidoking = 34
    case Clefairy = 35
    case Clefable = 36
    case Vulpix = 37
    case Ninetales = 38
    case Jigglypuff = 39
    case Wigglytuff = 40
    case Zubat = 41
    case Golbat = 42
    case Oddish = 43
    case Gloom = 44
    case Vileplume = 45
    case Paras = 46
    case Parasect = 47
    case Venonat = 48
    case Venomoth = 49
    case Diglett = 50
    case Dugtrio = 51
    case Meowth = 52
    case Persian = 53
    case Psyduck = 54
    case Golduck = 55
    case Mankey = 56
    case Primeape = 57
    case Growlithe = 58
    case Arcanine = 59
    case Poliwag = 60
    case Poliwhirl = 61
    case Poliwrath = 62
    case Abra = 63
    case Kadabra = 64
    case Alakazam = 65
    case Machop = 66
    case Machoke = 67
    case Machamp = 68
    case Bellsprout = 69
    case Weepinbell = 70
    case Victreebel = 71
    case Tentacool = 72
    case Tentacruel = 73
    case Geodude = 74
    case Graveler = 75
    case Golem = 76
    case Ponyta = 77
    case Rapidash = 78
    case Slowpoke = 79
    case Slowbro = 80
    case Magnemite = 81
    case Magneton = 82
    case Farfetchd = 83
    case Doduo = 84
    case Dodrio = 85
    case Seel = 86
    case Dewgong = 87
    case Grimer = 88
    case Muk = 89
    case Shellder = 90
    case Cloyster = 91
    case Gastly = 92
    case Haunter = 93
    case Gengar = 94
    case Onix = 95
    case Drowzee = 96
    case Hypno = 97
    case Krabby = 98
    case Kingler = 99
    case Voltorb = 100
    case Electrode = 101
    case Exeggcute = 102
    case Exeggutor = 103
    case Cubone = 104
    case Marowak = 105
    case Hitmonlee = 106
    case Hitmonchan = 107
    case Lickitung = 108
    case Koffing = 109
    case Weezing = 110
    case Rhyhorn = 111
    case Rhydon = 112
    case Chansey = 113
    case Tangela = 114
    case Kangaskhan = 115
    case Horsea = 116
    case Seadra = 117
    case Goldeen = 118
    case Seaking = 119
    case Staryu = 120
    case Starmie = 121
    case MrMime = 122
    case Scyther = 123
    case Jynx = 124
    case Electabuzz = 125
    case Magmar = 126
    case Pinsir = 127
    case Tauros = 128
    case Magikarp = 129
    case Gyarados = 130
    case Lapras = 131
    case Ditto = 132
    case Eevee = 133
    case Vaporeon = 134
    case Jolteon = 135
    case Flareon = 136
    case Porygon = 137
    case Omanyte = 138
    case Omastar = 139
    case Kabuto = 140
    case Kabutops = 141
    case Aerodactyl = 142
    case Snorlax = 143
    case Articuno = 144
    case Zapdos = 145
    case Moltres = 146
    case Dratini = 147
    case Dragonair = 148
    case Dragonite = 149
    case Mewtwo = 150
    case Mew = 151
}

enum PokemonMove: NSNumber {
    case Unknown = 0
    case ThunderShock = 1
    case QuickAttack = 2
    case Scratch = 3
    case Ember = 4
    case VineWhip = 5
    case Tackle = 6
    case RazorLeaf = 7
    case TakeDown = 8
    case WaterGun = 9
    case Bite = 10
    case Pound = 11
    case DoubleSlap = 12
    case Wrap = 13
    case HyperBeam = 14
    case Lick = 15
    case DarkPulse = 16
    case Smog = 17
    case Sludge = 18
    case MetalClaw = 19
    case ViceGrip = 20
    case FlameWheel = 21
    case Megahorn = 22
    case WingAttack = 23
    case Flamethrower = 24
    case SuckerPunch = 25
    case Dig = 26
    case LowKick = 27
    case CrossChop = 28
    case PsychoCut = 29
    case Psybeam = 30
    case Earthquake = 31
    case StoneEdge = 32
    case IcePunch = 33
    case HeartStamp = 34
    case Discharge = 35
    case FlashCannon = 36
    case Peck = 37
    case DrillPeck = 38
    case IceBeam = 39
    case Blizzard = 40
    case AirSlash = 41
    case HeatWave = 42
    case Twineedle = 43
    case PoisonJab = 44
    case AerialAce = 45
    case DrillRun = 46
    case PetalBlizzard = 47
    case MegaDrain = 48
    case BugBuzz = 49
    case PoisonFang = 50
    case NightSlash = 51
    case Slash = 52
    case BubbleBeam = 53
    case Submission = 54
    case KarateChop = 55
    case LowSweep = 56
    case AquaJet = 57
    case AquaTail = 58
    case SeedBomb = 59
    case Psyshock = 60
    case RockThrow = 61
    case AncientPower = 62
    case RockTomb = 63
    case RockSlide = 64
    case PowerGem = 65
    case ShadowSneak = 66
    case ShadowPunch = 67
    case ShadowClaw = 68
    case OminousWind = 69
    case ShadowBall = 70
    case BulletPunch = 71
    case MagnetBomb = 72
    case SteelWing = 73
    case IronHead = 74
    case ParabolicCharge = 75
    case Spark = 76
    case ThunderPunch = 77
    case Thunder = 78
    case Thunderbolt = 79
    case Twister = 80
    case DragonBreath = 81
    case DragonPulse = 82
    case DragonClaw = 83
    case DisarmingVoice = 84
    case DrainingKiss = 85
    case DazzlingGleam = 86
    case Moonblast = 87
    case PlayRough = 88
    case CrossPoison = 89
    case SludgeBomb = 90
    case SludgeWave = 91
    case GunkShot = 92
    case MudShot = 93
    case BoneClub = 94
    case Bulldoze = 95
    case MudBomb = 96
    case FuryCutter = 97
    case BugBite = 98
    case SignalBeam = 99
    case XScissor = 100
    case FlameCharge = 101
    case FlameBurst = 102
    case FireBlast = 103
    case Brine = 104
    case WaterPulse = 105
    case Scald = 106
    case HydroPump = 107
    case Psychic = 108
    case Psystrike = 109
    case IceShard = 110
    case IcyWind = 111
    case FrostBreath = 112
    case Absorb = 113
    case GigaDrain = 114
    case FirePunch = 115
    case SolarBeam = 116
    case LeafBlade = 117
    case PowerWhip = 118
    case Splash = 119
    case Acid = 120
    case AirCutter = 121
    case Hurricane = 122
    case BrickBreak = 123
    case Cut = 124
    case Swift = 125
    case HornAttack = 126
    case Stomp = 127
    case Headbutt = 128
    case HyperFang = 129
    case Slam = 130
    case BodySlam = 131
    case Rest = 132
    case Struggle = 133
    case ScaldBlastoise = 134
    case HydroPumpBlastoise = 135
    case WrapGreen = 136
    case WrapPink = 137
    case FuryCutterFast = 200
    case BugBiteFast = 201
    case BiteFast = 202
    case SuckerPunchFast = 203
    case DragonBreathFast = 204
    case ThunderShockFast = 205
    case SparkFast = 206
    case LowKickFast = 207
    case KarateChopFast = 208
    case EmberFast = 209
    case WingAttackFast = 210
    case PeckFast = 211
    case LickFast = 212
    case ShadowClawFast = 213
    case VineWhipFast = 214
    case RazorLeafFast = 215
    case MudShotFast = 216
    case IceShardFast = 217
    case FrostBreathFast = 218
    case QuickAttackFast = 219
    case ScratchFast = 220
    case TackleFast = 221
    case PoundFast = 222
    case CutFast = 223
    case PoisonJabFast = 224
    case AcidFast = 225
    case PsychoCutFast = 226
    case RockThrowFast = 227
    case MetalClawFast = 228
    case BulletPunchFast = 229
    case WaterGunFast = 230
    case SplashFast = 231
    case WaterGunFastBlastoise = 232
    case MudSlapFast = 233
    case ZenHeadbuttFast = 234
    case ConfusionFast = 235
    case PoisonStingFast = 236
    case BubbleFast = 237
    case FeintAttackFast = 238
    case SteelWingFast = 239
    case FireFangFast = 240
    case RockSmashFast = 241
}

enum Item: NSNumber {
    case ItemUnknown = 0
    case ItemPokeBall = 1
    case ItemGreatBall = 2
    case ItemUltraBall = 3
    case ItemMasterBall = 4
    case ItemPotion = 101
    case ItemSuperPotion = 102
    case ItemHyperPotion = 103
    case ItemMaxPotion = 104
    case ItemRevive = 201
    case ItemMaxRevive = 202
    case ItemLuckyEgg = 301
    case ItemIncenseOrdinary = 401
    case ItemIncenseSpicy = 402
    case ItemIncenseCool = 403
    case ItemIncenseFloral = 404
    case ItemTroyDisk = 501
    case ItemXAttack = 602
    case ItemXDefense = 603
    case ItemXMiracle = 604
    case ItemRazzBerry = 701
    case ItemBlukBerry = 702
    case ItemNanabBerry = 703
    case ItemWeparBerry = 704
    case ItemPinapBerry = 705
    case ItemSpecialCamera = 801
    case ItemIncubatorBasicUnlimited = 901
    case ItemIncubatorBasic = 902
    case ItemPokemonStorageUpgrade = 1001
    case ItemItemStorageUpgrade = 1002
}

enum PokemonFamily: NSNumber {
    case FamilyUnknown = 0
    case FamilyBulbasaur = 1
    case FamilyCharmander = 4
    case FamilySquirtle = 7
    case FamilyCaterpie = 10
    case FamilyWeedle = 13
    case FamilyPidgey = 16
    case FamilyRattata = 19
    case FamilySpearow = 21
    case FamilyEkans = 23
    case FamilyPikachu = 25
    case FamilySandshrew = 27
    case FamilyNidoranFemale = 29
    case FamilyNidoranMale = 32
    case FamilyClefairy = 35
    case FamilyVulpix = 37
    case FamilyJigglypuff = 39
    case FamilyZubat = 41
    case FamilyOddish = 43
    case FamilyParas = 46
    case FamilyVenonat = 48
    case FamilyDiglett = 50
    case FamilyMeowth = 52
    case FamilyPsyduck = 54
    case FamilyMankey = 56
    case FamilyGrowlithe = 58
    case FamilyPoliwag = 60
    case FamilyAbra = 63
    case FamilyMachop = 66
    case FamilyBellsprout = 69
    case FamilyTentacool = 72
    case FamilyGeodude = 74
    case FamilyPonyta = 77
    case FamilySlowpoke = 79
    case FamilyMagnemite = 81
    case FamilyFarfetchd = 83
    case FamilyDoduo = 84
    case FamilySeel = 86
    case FamilyGrimer = 88
    case FamilyShellder = 90
    case FamilyGastly = 92
    case FamilyOnix = 95
    case FamilyDrowzee = 96
    case FamilyKrabby = 98
    case FamilyVoltorb = 100
    case FamilyExeggcute = 102
    case FamilyCubone = 104
    case FamilyHitmonlee = 106
    case FamilyHitmonchan = 107
    case FamilyLickitung = 108
    case FamilyKoffing = 109
    case FamilyRhyhorn = 111
    case FamilyChansey = 113
    case FamilyTangela = 114
    case FamilyKangaskhan = 115
    case FamilyHorsea = 116
    case FamilyGoldeen = 118
    case FamilyStaryu = 120
    case FamilyMrMime = 122
    case FamilyScyther = 123
    case FamilyJynx = 124
    case FamilyElectabuzz = 125
    case FamilyMagmar = 126
    case FamilyPinsir = 127
    case FamilyTauros = 128
    case FamilyMagikarp = 129
    case FamilyLapras = 131
    case FamilyDitto = 132
    case FamilyEevee = 133
    case FamilyPorygon = 137
    case FamilyOmanyte = 138
    case FamilyKabuto = 140
    case FamilyAerodactyl = 142
    case FamilySnorlax = 143
    case FamilyArticuno = 144
    case FamilyZapdos = 145
    case FamilyMoltres = 146
    case FamilyDratini = 147
    case FamilyMewtwo = 150
    case FamilyMew = 151
}