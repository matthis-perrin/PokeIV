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
            self.setAccount(firstAccount)
            self.navigateTo(Tab.Pokemons)
        } else {
            self.navigateTo(Tab.Accounts)
        }
    }

    func navigateTo(tab: Tab) {
        self.selectedIndex = tab.rawValue
    }
    
    func setAccount(account: Account) {
        let controllers = self.viewControllers
        if let pokemonsNavigationController = controllers?[0] as? UINavigationController {
            if let pokemonsController = pokemonsNavigationController.topViewController as? PokemonCollectionViewController {
                pokemonsController.setAccount(account)
            }
        }
    }

}
