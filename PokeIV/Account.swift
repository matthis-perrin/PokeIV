//
//  GoogleAccount.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/15/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import Foundation
import RealmSwift
import PGoApi

class Account: Object {
    
    dynamic var username: String = ""
    dynamic var password: String = ""
    dynamic var lastAccess: NSDate = NSDate()
    dynamic var inventory: Inventory? = Inventory()
    
    private var _isRefreshing: Bool = false
    var isRefreshing: Bool {
        get {
            return _isRefreshing
        }
    }
    
    var accountRefreshEventName: String {
        get {
            return "\(self.username)_account_refreshingStateChanged"
        }
    }
    
    override static func primaryKey() -> String? {
        return "username"
    }
    
    private static let nc = NSNotificationCenter.defaultCenter()
    
    
    // STATIC METHODS
    // --------------
    
    static func create(username: String, password: String) -> Account {
        let account = Account()
        account.username = username
        account.password = password
        return account
    }
    
    static func getAll() -> [Account] {
        do {
            return try Array(Realm().objects(Account).sorted("lastAccess", ascending: false))
        } catch {
            return []
        }
    }
    
    
    // CLASS METHODS
    // -------------
    
    func logIn(callback: (success: Bool) -> Void) {
        self.setIsRefreshing(true)
        let authenticationService = AuthenticationService()
        let googleCallback = { (success: Bool) in
            if !success {
                self.setIsRefreshing(false)
                callback(success: false)
            }
        }
        let pokemonGoCallback = { (success: Bool) in
            if success {
                do {
                    let realm = try! Realm()
                    try! realm.write {
                        self.lastAccess = NSDate()
                        realm.add(self, update: true)
                    }
                }
            }
            self.setIsRefreshing(false)
            callback(success: success)
        }
        authenticationService.logIn(self.username, password: self.password, googleCallback: googleCallback, pokemonGoCallback: pokemonGoCallback)
    }
    
    func refreshInventory(callback: () -> Void) {
        let api = GoApi(account: self)
        self.setIsRefreshing(true)
        api.getInventory({ (success, inventory) in
            if let inventory = inventory {
                do {
                    let realm = try! Realm()
                    try! realm.write {
                        self.lastAccess = NSDate()
                        self.inventory = inventory
                    }
                }
            }
            self.setIsRefreshing(false)
            callback()
        })
    }
    
    func getInventory() -> Inventory {
        return self.inventory ?? Inventory()
    }
    
    func delete() {
        do {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(self)
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return AuthenticationService.getAuth(self.username) != nil
    }
    
    func updateLastAccess() {
        do {
            let realm = try! Realm()
            try! realm.write {
                self.lastAccess = NSDate()
            }
        }
    }
    
    private func setIsRefreshing(newValue: Bool) {
        self._isRefreshing = newValue
        Account.nc.postNotificationName(self.accountRefreshEventName, object: nil)
    }
    
}
