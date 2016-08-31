//
//  PokemonCollectionViewCell.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/11/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    private var _pokemon: Pokemon?
    var pokemon: Pokemon? {
        get {
            return self._pokemon
        }
        set(pokemon) {
            self._pokemon = pokemon
            self.updateUI()
        }
    }
    
    
    @IBOutlet weak var ivPercentLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var cpLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    private func initUI() {
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
    }
    
    private func updateUI() {
        let pokemon = self.pokemon ?? Pokemon()
        
        let ratio = pokemon.IVRatio
        let imageName = String(format: "%03d.png", pokemon.num.rawValue.intValue)
        
        self.ivPercentLabel.text = String(format: "%.1f%%", ratio * 100)
        self.ivPercentLabel.textColor = ColorUtils.colorForRatio(ratio)
        self.pokemonImageView.image = UIImage(named: imageName)
        self.cpLabel.text = String(format: "%.0f", pokemon.cp)
    }
    
}
