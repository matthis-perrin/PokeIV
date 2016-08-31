//
//  Pokemon.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import RealmSwift
import PGoApi

let defaultDate = NSDate(timeIntervalSince1970: 0)

class Pokemon: Object {
    
    private static let MAX_STAT = 15.0
    
    dynamic var id: NSNumber = 0
    
    dynamic var cp: Double = 0.0
    dynamic var attack: Double = 0.0
    dynamic var defence: Double = 0.0
    dynamic var stamina: Double = 0.0
    dynamic var height: Double = 0.0
    dynamic var weight: Double = 0.0
    dynamic var cpMultiplier: Double = 0.0
    dynamic var additionalCpMultiplier: Double = 0
    dynamic var creationTime: NSDate = defaultDate
    dynamic var fromFort: Bool = false
    dynamic var battlesAttacked: Int32 = 0
    dynamic var battlesDefended: Int32 = 0
    dynamic var nickname: NSString = ""
    dynamic var numUpgrades: Int32 = 0
    dynamic var favorite: Bool = false
    
    dynamic var numRaw: NSNumber = 0
    dynamic var move1Raw: NSNumber = 0
    dynamic var move2Raw: NSNumber = 0
    dynamic var pokeballRaw: NSNumber = 0
    
    var num: PokemonNum {
        get {
            return PokemonNum(rawValue: self.numRaw) ?? .Unknown
        }
    }
    var move1: PokemonMove {
        get {
            return PokemonMove(rawValue: self.move1Raw) ?? .Unknown
        }
    }
    var move2: PokemonMove {
        get {
            return PokemonMove(rawValue: self.move2Raw) ?? .Unknown
        }
    }
    var pokeball: Item {
        get {
            return Item(rawValue: self.pokeballRaw) ?? .ItemUnknown
        }
    }
    var IVRatio: Double {
        get {
            return (self.attack + self.defence + self.stamina) / (3 * Pokemon.MAX_STAT)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func fromPokemonData(data: Pogoprotos.Data.PokemonData) -> Pokemon {
        let pokemon = Pokemon()
        
        pokemon.id = NSNumber(unsignedLongLong: data.id)
        
        pokemon.cp = Double(data.cp)
        pokemon.attack = Double(data.individualAttack)
        pokemon.defence = Double(data.individualDefense)
        pokemon.stamina = Double(data.individualStamina)
        pokemon.height = Double(data.heightM)
        pokemon.weight = Double(data.weightKg)
        pokemon.cpMultiplier = Double(data.cpMultiplier)
        pokemon.additionalCpMultiplier = Double(data.additionalCpMultiplier)
        pokemon.creationTime = NSDate(timeIntervalSince1970: Double(data.creationTimeMs) / 1000.0)
        pokemon.fromFort = data.fromFort == 1
        pokemon.battlesAttacked = data.battlesAttacked
        pokemon.battlesDefended = data.battlesDefended
        pokemon.nickname = data.nickname
        pokemon.numUpgrades = data.numUpgrades
        pokemon.favorite = data.favorite == 1
        
        pokemon.numRaw = NSNumber(int: data.pokemonId.rawValue)
        pokemon.move1Raw = NSNumber(int: data.move1.rawValue)
        pokemon.move2Raw = NSNumber(int: data.move2.rawValue)
        pokemon.pokeballRaw = NSNumber(int: data.pokeball.rawValue)
        
        return pokemon
    }
    
}
