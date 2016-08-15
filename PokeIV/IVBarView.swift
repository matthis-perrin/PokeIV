//
//  IVBarView.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/12/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

let MIN_COLOR = (red: 1.0, green: 131.0/255.0, blue: 0.0)
let AVG_COLOR = (red: 1.0, green: 1.0, blue: 50.0/255.0)
let MAX_COLOR = (red: 66.0/255.0, green: 1.0, blue: 129.0/255.0)

class IVBarView: UIView {

    private var _percent: Double = 0
    var percent: Double {
        get {
            return _percent
        }
        set (percent) {
            self._percent = percent
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
    }
    
    private func inBetween2(d1: Double, d2: Double, ratio: Double) -> Double {
        return d1 + ratio * (d2 - d1)
    }
    private func inBetween3(d1: Double, d2: Double, d3: Double, ratio: Double) -> Double {
        return ratio < 0.5 ? self.inBetween2(d1, d2: d2, ratio: 2.0 * ratio) : self.inBetween2(d2, d2: d3, ratio: 2.0 * (ratio - 0.5))
    }

}
