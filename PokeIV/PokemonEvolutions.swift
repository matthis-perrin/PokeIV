//
//  PokemonEvolutions.swift
//  PokeIV
//
//  Created by Matthis Perrin on 9/19/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class PokemonEvolutions: NSObject {

    let pokemonNum: PokemonNum
    let pokemonCount: Int
    let candyCount: Int
    let candyToEvolve: Int
    let possibleEvolutions: Int
    let suggestedTransfers: Int
    let possibleEvolutionsAfterTransfers: Int

    init(pokemonNum: PokemonNum, pokemonCount: Int, candyCount: Int, candyToEvolve: Int) {
        self.pokemonNum = pokemonNum
        self.pokemonCount = pokemonCount
        self.candyCount = candyCount
        self.candyToEvolve = candyToEvolve
        self.possibleEvolutions = min(self.pokemonCount, floor(self.candyCount / self.candyToEvolve))
        let extraEvolutions = (self.candyCount - (self.possibleEvolutions * self.candyToEvolve) + (self.pokemonCount - self.possibleEvolutions)) / (self.candyToEvolve + 1)
        self.suggestedTransfers = extraEvolutions * self.candyToEvolve - (self.candyCount - self.possibleEvolutions * self.candyToEvolve)
        self.possibleEvolutionsAfterTransfers = (self.candyCount + self.suggestedTransfers) / (self.candyToEvolve)
    }

}
