//
//  Candy.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/22/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import RealmSwift
import PGoApi

class Candy: Object {
    
    dynamic var amount: Int32 = 0
    dynamic var pokemonFamilyRaw: NSNumber = 0
    
    var pokemonFamily: PokemonFamily {
        get {
            return PokemonFamily(rawValue: self.pokemonFamilyRaw) ?? .FamilyUnknown
        }
    }
    
    static func fromCandyData(data: Pogoprotos.Inventory.Candy) -> Candy {
        let candy = Candy()
        candy.amount = data.candy
        candy.pokemonFamilyRaw = NSNumber(int: data.familyId.rawValue)
        return candy
    }

}
