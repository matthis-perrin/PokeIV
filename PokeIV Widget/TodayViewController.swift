//
//  TodayViewController.swift
//  PokeIV Widget
//
//  Created by Matthis Perrin on 8/30/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private static let LOGGED_OUT_HEIGHT = CGFloat(50)
    private static let LOGGED_IN_HEIGHT = CGFloat(155)
    
    private var account: Account!
    
    @IBOutlet weak var refreshButtonTitleLabel: UILabel!
    @IBOutlet weak var refreshButtonSubtitleLabel: UILabel!
    
    @IBOutlet weak var lastCapturedImageView: UIImageView!
    @IBOutlet weak var lastCapturedIVLabel: UILabel!
    @IBOutlet weak var lastCapturedCPLabel: UILabel!
    @IBOutlet weak var lastCapturedTimeLabel: UILabel!
    
    @IBOutlet weak var lastCapturedPokemonView: UIView!
    @IBOutlet weak var refreshButtonView: UIView!
    
    @IBOutlet weak var loggedInView: UIView!
    @IBOutlet weak var loggedOutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Realm DB path
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.raccoonzninja.PokeIV")!
        let path = directory.URLByAppendingPathComponent("db.realm")

        // Update Realm config
        var realmConfig = Realm.Configuration()
        realmConfig.fileURL = path
        Realm.Configuration.defaultConfiguration = realmConfig

        self.initUI()
        if let account = Account.getAll().first {
            self.account = account
            self.showLoggedInUI()
            self.initObserver()
        } else {
            self.showLoggedOutUI()
        }
    }
    
    private func initUI() {
        self.refreshButtonView.layer.borderColor = UIColor(white: 1, alpha: 0.75).CGColor
        self.refreshButtonView.layer.borderWidth = 1
        self.refreshButtonView.layer.cornerRadius = 5
        self.refreshButtonSubtitleLabel.liveText { () -> String in
            if let account = self.account {
                return "Updated \(account.lastAccess.timeAgo(true).lowercaseString)"
            } else {
                return ""
            }
        }
    }
    
    private func initObserver() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.showLoggedInUI), name: account.accountRefreshEventName, object: nil)
        self.account.refreshInventory() {}
    }
    
    @objc private func showLoggedInUI() {
        self.preferredContentSize = CGSizeMake(0, TodayViewController.LOGGED_IN_HEIGHT)
        self.loggedInView.hidden = false
        self.loggedOutView.hidden = true
        
        if self.account.isRefreshing {
            self.refreshButtonTitleLabel.text = "Refreshing..."
        } else {
            self.refreshButtonTitleLabel.text = "Refresh"
        }
        
        let lastPokemon = self.account.getInventory().pokemons.minElement { (p1, p2) -> Bool in
            return p1.creationTime.compare(p2.creationTime) == NSComparisonResult.OrderedDescending
        }
        if let pokemon = lastPokemon {
            let imageName = String(format: "%03d.png", pokemon.num.rawValue.intValue)
            let image = UIImage(named: imageName)
            
            self.lastCapturedIVLabel.text = String(format: "%.1f%%", pokemon.IVRatio * 100)
            self.lastCapturedIVLabel.textColor = ColorUtils.colorForRatio(pokemon.IVRatio)
            self.lastCapturedCPLabel.text = String(format: "%.0f", pokemon.cp)
            self.lastCapturedImageView.image = image
            
            self.lastCapturedTimeLabel.liveText { () -> String in
                return "Captured \(pokemon.creationTime.timeAgo(true).lowercaseString)"
            }
        }
    }
    
    private func showLoggedOutUI() {
        print("Logged Out UI")
        self.preferredContentSize = CGSizeMake(0, TodayViewController.LOGGED_OUT_HEIGHT)
        self.loggedInView.hidden = true
        self.loggedOutView.hidden = false
    }

    @IBAction func onRefreshButtonTap(sender: AnyObject) {
        self.account.refreshInventory() {}
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
