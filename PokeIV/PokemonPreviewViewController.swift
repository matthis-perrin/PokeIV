//
//  PokemonPreviewViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/11/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

let MAX_STAT = 15.0

let MIN_C = (red: 1.0, green: 131.0/255.0, blue: 0.0)
let AVG_C = (red: 1.0, green: 1.0, blue: 50.0/255.0)
let MAX_C = (red: 66.0/255.0, green: 1.0, blue: 129.0/255.0)

class PokemonPreviewViewController: UIViewController {
    
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
    
    @IBOutlet weak var globalIVLabel: UILabel!
    
    @IBOutlet weak var attackIVBarInner: UIView!
    @IBOutlet weak var defenceIVBarInner: UIView!
    @IBOutlet weak var staminaIVBarInner: UIView!
    
//    private func initUI() {
//        let gradientColors = [
//            UIColor(red: 1, green: 131/255, blue: 0, alpha: 1).CGColor,
//            UIColor(red: 1, green: 1, blue: 50/255, alpha: 1).CGColor,
//            UIColor(red: 66/255, green: 1, blue: 129/255, alpha: 1).CGColor,
//        ]
//        for barInner: UIView in [self.attackIVBarInner, self.defenceIVBarInner, self.staminaIVBarInner] {
//            let gradientLayer: CAGradientLayer = CAGradientLayer()
//            gradientLayer.frame = barInner.bounds
//            gradientLayer.colors = gradientColors
//            gradientLayer.startPoint = CGPointMake(0, 0)
//            gradientLayer.endPoint = CGPointMake(1, 0)
//            gradientLayer.locations = [0, 0.5, 1]
//            barInner.layer.insertSublayer(gradientLayer, atIndex: 0)
//        }
//    }
    
    private func initUI() {
        for bar in [attackIVBarInner, defenceIVBarInner, staminaIVBarInner] {
            bar.layer.borderWidth = 1
            bar.layer.borderColor = UIColor.blackColor().CGColor
        }
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    private func updateUI() {
        let attack = self.pokemon?.attack ?? 0.0
        let defence = self.pokemon?.defence ?? 0.0
        let stamina = self.pokemon?.stamina ?? 0.0
        
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(1, animations: {
            let inBetween2 = {(d1: Double, d2: Double, ratio: Double) in
                return d1 + ratio * (d2 - d1)
            }
            let inBetween3 = {(d1: Double, d2: Double, d3: Double, ratio: Double) in
                return ratio < 0.5 ? inBetween2(d1, d2, 2.0 * ratio) : inBetween2(d2, d3, 2.0 * (ratio - 0.5))
            }
            let updateIVBar = {(barInner: UIView, ratio: Double) in
                var layerAlreadyAdded = false
                if let layers = barInner.layer.sublayers {
                    if let layer = layers.first {
                        if layer.name == "IVBarLayer" {
                            layerAlreadyAdded = true
                        }
                    }
                }
                if !layerAlreadyAdded {
                    let layer = CALayer()
                    layer.name = "IVBarLayer"
                    layer.frame = barInner.bounds
                    barInner.layer.insertSublayer(layer, atIndex: 0)
                }
                if let layer = barInner.layer.sublayers?.first {
                    let red = CGFloat(inBetween3(MIN_C.red, AVG_C.red, MAX_C.red, ratio))
                    let green = CGFloat(inBetween3(MIN_C.green, AVG_C.green, MAX_C.green, ratio))
                    let blue = CGFloat(inBetween3(MIN_C.blue, AVG_C.blue, MAX_C.blue, ratio))
                    layer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).CGColor
                    layer.frame.size.width = barInner.bounds.size.width * CGFloat(ratio)
                }
            }
            
            updateIVBar(self.attackIVBarInner, attack / MAX_STAT)
            updateIVBar(self.defenceIVBarInner, defence / MAX_STAT)
            updateIVBar(self.staminaIVBarInner, stamina / MAX_STAT)
            
            let ivRatio = (attack + defence + stamina) / (3 * MAX_STAT)
            self.globalIVLabel.text = "IV " + String(format: "%.1f", ivRatio * 100) + "%"
            
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
