//
//  PokemonEvolutionsTests.swift
//  PokeIV
//
//  Created by Matthis Perrin on 9/19/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

class PokemonEvolutionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func _testEvolution(evolution: (Int, Int, Int), result: (Int, Int, Int)) {
        let e = PokemonEvolutions(pokemonNum: .Unknown, pokemonCount: evolution.0, candyCount: evolution.1, candyToEvolve: evolution.2)
        assert(e.possibleEvolutions == result.0)
        assert(e.suggestedTransfers == result.1)
        assert(e.possibleEvolutionsAfterTransfers == result.2)
    }
    
    func testPokemonEvolutions() {
        self._testEvolution((0, 0, 12), result: (0, 0, 0))
        self._testEvolution((1, 0, 12), result: (0, 0, 0))
        self._testEvolution((0, 1, 12), result: (0, 0, 0))
        self._testEvolution((12, 0, 12), result: (0, 0, 0))
        self._testEvolution((1, 11, 12), result: (0, 0, 0))
        self._testEvolution((1, 12, 12), result: (1, 0, 0))
        self._testEvolution((2, 11, 12), result: (0, 1, 1))
        self._testEvolution((12, 12, 12), result: (1, 0, 1))
        self._testEvolution((14, 12, 12), result: (1, 12, 2))
        self._testEvolution((12, 14, 12), result: (1, 10, 2))
        self._testEvolution((44, 123, 12), result: (10, 21, 12))
    }
    
}
