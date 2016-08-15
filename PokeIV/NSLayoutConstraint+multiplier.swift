//
//  NSLayoutConstraint+multiplier.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/11/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit


extension NSLayoutConstraint {
    public func copyWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let duplicate = NSLayoutConstraint(item: self.firstItem,
                                           attribute: self.firstAttribute,
                                           relatedBy: self.relation,
                                           toItem: self.secondItem,
                                           attribute: self.secondAttribute,
                                           multiplier: multiplier,
                                           constant: self.constant)
        duplicate.identifier = self.identifier
        return duplicate
    }
}
