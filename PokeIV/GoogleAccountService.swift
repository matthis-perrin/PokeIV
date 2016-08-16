//
//  GoogleAccountService.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/15/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import RealmSwift

class GoogleAccountService: NSObject {
    
    static func addAccount(username: String, password: String) {
        do {
            let realm = try! Realm()
            try! realm.write {
                let account = GoogleAccount()
                account.username = username
                account.password = password
                realm.add(account, update: true)
            }
        }
    }
    
    static func getAccounts() -> [GoogleAccount] {
        do {
            return try Array(Realm().objects(GoogleAccount).sorted("lastAccess"))
        } catch {
            return []
        }
    }
    
}
