//
//  GoAPI.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/16/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi

class GoAPI: PGoApiDelegate {

    private let auth: PGoAuth
    private var inventoryCallback: ((success: Bool, pokemons: [Pogoprotos.Data.PokemonData]?) -> Void)!
    
    init(auth: PGoAuth) {
        self.auth = auth
    }
    
    func getInventory(callback: (success: Bool, pokemons: [Pogoprotos.Data.PokemonData]?) -> Void) {
        self.inventoryCallback = callback
        let request = PGoApiRequest()
        request.getInventory()
        request.makeRequest(.GetInventory, auth: self.auth, delegate: self)
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        if (intent == .GetInventory) {
            let r = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetInventoryResponse
            var pokemons = [Pogoprotos.Data.PokemonData()]
            for item in r.inventoryDelta.inventoryItems {
                if let pokemonData = item.inventoryItemData.pokemonData {
                    if !(pokemonData.isEgg || pokemonData.pokemonId.rawValue <= 0) {
                        pokemons.append(pokemonData)
                    }
                }
            }
            self.inventoryCallback(success: true, pokemons: pokemons)
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        self.inventoryCallback(success: false, pokemons: nil)
    }
    
}
