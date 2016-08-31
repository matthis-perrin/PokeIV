//
//  GoAPI.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/16/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi

class GoApi: PGoApiDelegate {

    private let account: Account
    private var inventoryCallback: ((success: Bool, inventory: Inventory?) -> Void)!
    
    init(account: Account) {
        self.account = account
    }
    
    func getInventory(callback: (success: Bool, inventory: Inventory?) -> Void) {
        if let auth = AuthenticationService.getAuth(self.account.username) {
            self._getInventory(auth, callback: callback)
        } else {
            let googleCallback = {(success: Bool) in
                if !success {
                    callback(success: false, inventory: nil)
                }
            }
            let pokemonGoCallback = {(success: Bool) in
                if success {
                    self.getInventory(callback)
                } else {
                    callback(success: false, inventory: nil)
                }
            }
            AuthenticationService().logIn(account.username, password: account.password, googleCallback: googleCallback, pokemonGoCallback: pokemonGoCallback)
        }
    }
    
    private func _getInventory(auth: PGoAuth, callback: (success: Bool, inventory: Inventory?) -> Void) {
        self.inventoryCallback = callback
        let request = PGoApiRequest()
        request.getInventory()
        request.makeRequest(.GetInventory, auth: auth, delegate: self)
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        if (intent == .GetInventory) {
            let r = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetInventoryResponse
            var pokemons = [Pokemon]()
            var candies = [Candy]()
            for item in r.inventoryDelta.inventoryItems {
                if let pokemonData = item.inventoryItemData.pokemonData {
                    if !(pokemonData.isEgg || pokemonData.pokemonId.rawValue <= 0) {
                        pokemons.append(Pokemon.fromPokemonData(pokemonData))
                    }
                } else if let candy = item.inventoryItemData.candy {
                    candies.append(Candy.fromCandyData(candy))
                }
            }
            let inventory = Inventory.fromData(pokemons, candies: candies)
            self.inventoryCallback(success: true, inventory: inventory)
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        self.inventoryCallback(success: false, inventory: nil)
    }
    
}
