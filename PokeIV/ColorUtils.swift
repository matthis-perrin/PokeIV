//
//  ColorUtils.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/24/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class ColorUtils: NSObject {
    
    private static let MIN_C = (red: 193.0/255.0, green:  52.0/255.0, blue: 52.0/255.0)
    private static let AVG_C = (red: 255.0/255.0, green: 175.0/255.0, blue: 48.0/255.0)
    private static let MAX_C = (red:   0.0/255.0, green: 200.0/255.0, blue:  0.0/255.0)
    
    private static func inBetween2(d1: Double, d2: Double, ratio: Double) -> Double {
        return d1 + ratio * (d2 - d1)
    }
    private static func inBetween3(d1: Double, d2: Double, d3: Double, ratio: Double) -> Double {
        return ratio < 0.5 ? ColorUtils.inBetween2(d1, d2: d2, ratio: 2.0 * ratio) : ColorUtils.inBetween2(d2, d2: d3, ratio: 2.0 * (ratio - 0.5))
    }
    
    static func colorForRatio(ratio: Double) -> UIColor {
        let red = CGFloat(ColorUtils.inBetween3(ColorUtils.MIN_C.red, d2: AVG_C.red, d3: MAX_C.red, ratio: ratio))
        let green = CGFloat(ColorUtils.inBetween3(ColorUtils.MIN_C.green, d2: AVG_C.green, d3: MAX_C.green, ratio: ratio))
        let blue = CGFloat(ColorUtils.inBetween3(ColorUtils.MIN_C.blue, d2: AVG_C.blue, d3: MAX_C.blue, ratio: ratio))
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
    
}
