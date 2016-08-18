//
//  PokemonCollectionViewCell.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/11/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi

let MAX_STAT = 15.0

let MIN_C = (red: 1.0, green: 131.0/255.0, blue: 0.0)
let AVG_C = (red: 1.0, green: 1.0, blue: 50.0/255.0)
let MAX_C = (red: 66.0/255.0, green: 1.0, blue: 129.0/255.0)

class PokemonCollectionViewCell: UICollectionViewCell {
    
    private var _pokemon: Pogoprotos.Data.PokemonData?
    var pokemon: Pogoprotos.Data.PokemonData? {
        get {
            return self._pokemon
        }
        set(pokemon) {
            self._pokemon = pokemon
            dispatch_async(dispatch_get_main_queue()) {
                self.updateUI()
            };
        }
    }
    
    
    @IBOutlet weak var ivPercentLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var cpLabel: UILabel!
    
    
    private func updateUI() {
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
        
        let attack = Double(self.pokemon?.individualAttack ?? 0)
        let defence = Double(self.pokemon?.individualDefense ?? 0)
        let stamina = Double(self.pokemon?.individualStamina ?? 0)
        
        let inBetween2 = {(d1: Double, d2: Double, ratio: Double) in
            return d1 + ratio * (d2 - d1)
        }
        let inBetween3 = {(d1: Double, d2: Double, d3: Double, ratio: Double) in
            return ratio < 0.5 ? inBetween2(d1, d2, 2.0 * ratio) : inBetween2(d2, d3, 2.0 * (ratio - 0.5))
        }
        
        let ratio = (attack + defence + stamina) / (3 * MAX_STAT)
        let red = CGFloat(inBetween3(MIN_C.red, AVG_C.red, MAX_C.red, ratio))
        let green = CGFloat(inBetween3(MIN_C.green, AVG_C.green, MAX_C.green, ratio))
        let blue = CGFloat(inBetween3(MIN_C.blue, AVG_C.blue, MAX_C.blue, ratio))
        let ivColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        let imageName = String(format: "%03d.png", self.pokemon?.pokemonId.rawValue ?? 0)
        
        self.ivPercentLabel.text = String(format: "%.1f%%", ratio * 100)
        self.ivPercentLabel.textColor = ivColor
        self.pokemonImageView.image = UIImage(named: imageName)
        self.cpLabel.text = String(self.pokemon?.cp ?? 0)
    }
    
}
