//
//  Pokemon.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class Pokemon: NSObject {

    let num: PokemonNum
    let name: String
    let cp: Double
    let attack: Double
    let defence: Double
    let stamina: Double
    
    init(num: PokemonNum, name: String, cp: Double, attack: Double, defence: Double, stamina: Double) {
        self.num = num
        self.name = name
        self.cp = cp
        self.attack = attack
        self.defence = defence
        self.stamina = stamina
    }
    
}
