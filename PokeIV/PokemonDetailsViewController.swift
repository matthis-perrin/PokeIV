//
//  PokemonDetailsViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/23/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var creationTimeLabel: UILabel!
    @IBOutlet weak var captureItemImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var candyAmountLabel: UILabel!
    @IBOutlet weak var candyView: PokemonCandy!
    
    @IBOutlet weak var pokemonIconImageView: UIImageView!
    
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var IVPercentLabel: UILabel!
    
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var staminaLabel: UILabel!
    
    @IBOutlet weak var attackBar: UIView!
    @IBOutlet weak var defenceBar: UIView!
    @IBOutlet weak var staminaBar: UIView!
    
    @IBOutlet weak var attackBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var defenceBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var staminaBarWidthConstraint: NSLayoutConstraint!
    
    
    private var _pokemon: Pokemon = Pokemon()
    var pokemon: Pokemon {
        get {
            return self._pokemon
        }
        set(pokemon) {
            self._pokemon = pokemon
            self.reloadUI()
        }
    }
    
    private var _candyAmount: Int32 = 0
    var candyAmount: Int32 {
        get {
            return self._candyAmount
        }
        set(candyAmount) {
            self._candyAmount = candyAmount
            self.reloadUI()
        }
    }
    
    private func reloadUI() {
        if self.isViewLoaded() {
            self.creationTimeLabel.text = self.pokemon.creationTime.timeAgo(true)
            
            self.nameLabel.text = self.pokemon.displayName
            
            self.candyAmountLabel.text = String(self.candyAmount)
            self.candyView.num = self.pokemon.num
            
            self.pokemonIconImageView.image = UIImage(named: String(format: "%03d.png", pokemon.num.rawValue.intValue))
            
            self.cpLabel.text = "CP \(String(format: "%.0f", self.pokemon.cp))"
            
            let IVRatio = self.pokemon.IVRatio * 100
            self.IVPercentLabel.text = String(format: "%.1f%%", IVRatio)
            self.IVPercentLabel.textColor = ColorUtils.colorForRatio(self.pokemon.IVRatio)
            
            self.attackLabel.text = "\(String(format: "%.0f", self.pokemon.attack)) ATTACK"
            self.defenceLabel.text = "\(String(format: "%.0f", self.pokemon.defence)) DEFENCE"
            self.staminaLabel.text = "\(String(format: "%.0f", self.pokemon.stamina)) STAMINA"
            
            let attackRatio = self.pokemon.attack / 15.0
            let newAttackConstraint = self.attackBarWidthConstraint.copyWithMultiplier(CGFloat(attackRatio))
            self.attackBar.superview?.removeConstraint(self.attackBarWidthConstraint)
            self.attackBar.superview?.addConstraint(newAttackConstraint)
            self.attackBarWidthConstraint = newAttackConstraint
            self.attackBar.backgroundColor = ColorUtils.colorForRatio(attackRatio)
            
            let defenceRatio = self.pokemon.defence / 15.0
            let newDefenceConstraint = self.defenceBarWidthConstraint.copyWithMultiplier(CGFloat(defenceRatio))
            self.defenceBar.superview?.removeConstraint(self.defenceBarWidthConstraint)
            self.defenceBar.superview?.addConstraint(newDefenceConstraint)
            self.defenceBarWidthConstraint = newDefenceConstraint
            self.defenceBar.backgroundColor = ColorUtils.colorForRatio(defenceRatio)
            
            let staminaRatio = self.pokemon.stamina / 15.0
            let newStaminaConstraint = self.staminaBarWidthConstraint.copyWithMultiplier(CGFloat(staminaRatio))
            self.staminaBar.superview?.removeConstraint(self.staminaBarWidthConstraint)
            self.staminaBar.superview?.addConstraint(newStaminaConstraint)
            self.staminaBarWidthConstraint = newStaminaConstraint
            self.staminaBar.backgroundColor = ColorUtils.colorForRatio(staminaRatio)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadUI()
    }

}
