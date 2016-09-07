//
//  UILabel+liveText.swift
//  PokeIV
//
//  Created by Matthis Perrin on 9/2/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

private class UILabelTimerActor {
    var textFn: () -> String
    var label: UILabel
    
    init(textFn: () -> String, label: UILabel) {
        self.textFn = textFn
        self.label = label
    }
    
    dynamic func fire() {
        self.label.text = self.textFn()
    }
}

private var timers: [Int: UILabelTimerActor] = [:]

extension UILabel {
    public func liveText(textFn: () -> String) {
        var actor = timers[self.hash]
        if actor == nil {
            actor = UILabelTimerActor(textFn: textFn, label: self)
            timers[self.hash] = actor
        } else {
            actor?.textFn = textFn
        }
        let timer = NSTimer(timeInterval: 1.0, target: actor!, selector: #selector(actor!.fire), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        timer.fire()
    }
}
