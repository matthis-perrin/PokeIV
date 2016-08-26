//
//  InventoryService.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/17/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import RealmSwift

class InventoryService: NSObject {

    static func addInventory(inventory: Inventory) {
        do {
            let realm = try! Realm()
            try! realm.write {
                realm.add(inventory, update: true)
            }
        }
    }
    
    static func getInventory(username: String) -> Inventory {
        let realm = try! Realm()
        if let inventory = realm.objects(Inventory).filter("username=\"\(username)\"").first {
            return inventory
        }
        return Inventory.fromData(username, pokemons: [], candies: [])
    }
    
}
