//
//  MainTabBarController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/31/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

enum Tab: Int {
    case Pokemons = 0
    case Accounts = 1
}

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accounts = Account.getAll()
        if let firstAccount = accounts.first {
            self.navigateTo(Tab.Pokemons)
        } else {
            self.navigateTo(Tab.Accounts)
        }
    }

    func navigateTo(tab: Tab) {
        self.selectedIndex = tab.rawValue
    }

}
