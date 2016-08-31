//
//  Inventory.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/17/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import Foundation
import RealmSwift
import PGoApi

class Inventory: Object {

    dynamic var creationTime: NSDate = NSDate()
    let pokemons = List<Pokemon>()
    let candies = List<Candy>()
    
    func getCandyAmount(pokemonNum: PokemonNum) -> Int32 {
        let pokemonFamily = POKEMON_NUM_TO_FAMILY[pokemonNum] ?? .FamilyUnknown
        for candy in self.candies {
            if candy.pokemonFamily == pokemonFamily {
                return candy.amount
            }
        }
        return 0
    }
    
    static func fromData(pokemons: [Pokemon], candies: [Candy]) -> Inventory {
        let inventory = Inventory()
        inventory.pokemons.appendContentsOf(pokemons)
        inventory.candies.appendContentsOf(candies)
        return inventory
    }

}
