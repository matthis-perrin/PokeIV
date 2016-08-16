//
//  GoogleAccount.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/15/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import Foundation
import RealmSwift

class GoogleAccount: Object {
    dynamic var username: String = ""
    dynamic var password: String = ""
    dynamic var lastAccess: NSDate = NSDate()
    override static func primaryKey() -> String? {
        return "username"
    }
}
