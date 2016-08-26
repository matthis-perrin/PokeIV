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
    private var inventoryCallback: ((success: Bool, inventory: Inventory?) -> Void)!
    let username: String
    
    init(auth: PGoAuth, username: String) {
        self.auth = auth
        self.username = username
    }
    
    func getInventory(callback: (success: Bool, inventory: Inventory?) -> Void) {
        self.inventoryCallback = callback
        let request = PGoApiRequest()
        request.getInventory()
        request.makeRequest(.GetInventory, auth: self.auth, delegate: self)
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        if (intent == .GetInventory) {
            let r = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetInventoryResponse
            var pokemons = [Pokemon]()
            var candies = [Candy]()
            for item in r.inventoryDelta.inventoryItems {
                if let pokemonData = item.inventoryItemData.pokemonData {
                    if !(pokemonData.isEgg || pokemonData.pokemonId.rawValue <= 0) {
                        pokemons.append(Pokemon.fromPokemonData(pokemonData, ownerUsername: self.username))
                    }
                } else if let candy = item.inventoryItemData.candy {
                    candies.append(Candy.fromCandyData(candy))
                }
            }
            let inventory = Inventory.fromData(self.username, pokemons: pokemons, candies: candies)
            InventoryService.addInventory(inventory)
            self.inventoryCallback(success: true, inventory: inventory)
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        self.inventoryCallback(success: false, inventory: nil)
    }
    
}
