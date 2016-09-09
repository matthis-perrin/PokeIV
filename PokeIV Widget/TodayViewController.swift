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
    
    private static let REFRESH_BUTTON_SUBTITLE_TAG = 13
    private static let LAST_CAPTURED_TIME_TAG = 14
    
    
    private var account: Account!
    private var otherPokemonScrollIndex = 0
    
    @IBOutlet weak var refreshButtonTitleLabel: UILabel!
    @IBOutlet weak var refreshButtonSubtitleLabel: UILabel!
    
    @IBOutlet weak var lastCapturedImageView: UIImageView!
    @IBOutlet weak var lastCapturedIVLabel: UILabel!
    @IBOutlet weak var lastCapturedCPLabel: UILabel!
    @IBOutlet weak var lastCapturedIVDetailsLabel: UILabel!
    @IBOutlet weak var lastCapturedTimeLabel: UILabel!
    
    @IBOutlet weak var lastCapturedPokemonView: UIView!
    @IBOutlet weak var refreshButtonView: UIView!
    
    @IBOutlet weak var scrollDownButton: UIButton!
    @IBOutlet weak var scrollUpButton: UIButton!
    
    @IBOutlet weak var otherPokemonsTableView: UITableView!
    @IBOutlet weak var otherPokemonsTableViewHeightConstraint: NSLayoutConstraint!
    
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
        self.initAccount()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.initAccount()
        self.account.refreshInventory() {}
    }
    
    private func initUI() {
        self.refreshButtonSubtitleLabel.tag = TodayViewController.REFRESH_BUTTON_SUBTITLE_TAG
        self.lastCapturedTimeLabel.tag = TodayViewController.LAST_CAPTURED_TIME_TAG
        self.refreshButtonSubtitleLabel.liveText { () -> String in
            if let account = self.account {
                return "Updated \(account.lastAccess.timeAgo(true).lowercaseString)"
            } else {
                return ""
            }
        }
        for button in [self.scrollUpButton, self.scrollDownButton, self.refreshButtonView] {
            let grayColor = UIColor(white: 1, alpha: 0.75).CGColor
            button.layer.borderColor = grayColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
        }
        self.otherPokemonsTableView.backgroundColor = UIColor.clearColor()
        self.otherPokemonsTableView.dataSource = self
        self.otherPokemonsTableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0)
    }
    
    private func initAccount() {
        if let account = Account.getAll().first {
            self.account = account
            self.showLoggedInUI()
            self.initObserver()
        } else {
            self.showLoggedOutUI()
        }
    }
    
    private func initObserver() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.showLoggedInUI), name: account.accountRefreshEventName, object: nil)
        self.account.refreshInventory() {}
    }
    
    private func getWidgetHeight() -> CGFloat {
        return CGFloat(155) + self.getTableViewHeight()
    }
    
    private func getTableViewHeight() -> CGFloat {
        let rowCount = self.getOtherPokemons().count
        let rowHeight = 44
        return CGFloat(25 + rowCount * rowHeight)
    }
    
    @objc private func showLoggedInUI() {
        self.preferredContentSize = CGSizeMake(0, self.getWidgetHeight())
        self.otherPokemonsTableViewHeightConstraint.constant = self.getTableViewHeight()
        self.loggedInView.hidden = false
        self.loggedOutView.hidden = true
        
        if self.account.isRefreshing {
            self.refreshButtonTitleLabel.text = "Refreshing..."
        } else {
            self.refreshButtonTitleLabel.text = "Refresh"
        }
        
        let hideScrollButton = self.getOtherPokemons().count <= 8
        self.scrollUpButton.hidden = hideScrollButton
        self.scrollDownButton.hidden = hideScrollButton
        
        if let pokemon = self.lastPokemon() {
            let imageName = String(format: "%03d.png", pokemon.num.rawValue.intValue)
            let image = UIImage(named: imageName)
            
            self.lastCapturedIVLabel.text = String(format: "%.1f%%", pokemon.IVRatio * 100)
            self.lastCapturedIVLabel.textColor = ColorUtils.colorForRatio(pokemon.IVRatio)
            self.lastCapturedIVDetailsLabel.text = "(\(String(format: "%.0f%", pokemon.attack))/\(String(format: "%.0f%", pokemon.defence))/\(String(format: "%.0f%", pokemon.stamina)))"
            self.lastCapturedCPLabel.text = String(format: "%.0f", pokemon.cp)
            self.lastCapturedImageView.image = image
            
            self.lastCapturedTimeLabel.liveText { () -> String in
                return "Captured \(pokemon.creationTime.timeAgo(true).lowercaseString)"
            }
        }
        self.otherPokemonsTableView.reloadData()
    }
    
    private func showLoggedOutUI() {
        self.preferredContentSize = CGSizeMake(0, TodayViewController.LOGGED_OUT_HEIGHT)
        self.loggedInView.hidden = true
        self.loggedOutView.hidden = false
    }
    
    private func lastPokemon() -> Pokemon? {
        guard let account = self.account else {
            return nil
        }
        return account.getInventory().pokemons.minElement { (p1, p2) -> Bool in
//            return p1.num == .Magikarp
            return p1.creationTime.compare(p2.creationTime) == NSComparisonResult.OrderedDescending
        }
    }

    @IBAction func onRefreshButtonTap(sender: AnyObject) {
        self.initAccount()
        self.account.refreshInventory() {}
    }
    @IBAction func onScrollDownButtonTap(sender: AnyObject) {
        self.setOtherPokemonScrollIndex(self.otherPokemonScrollIndex + 5)
    }
    @IBAction func onScrollUpButtonTap(sender: AnyObject) {
        self.setOtherPokemonScrollIndex(self.otherPokemonScrollIndex - 5)
    }
    
    private func setOtherPokemonScrollIndex(index: Int) {
        self.otherPokemonScrollIndex = min(self.getOtherPokemons().count - 8, max(0, index))
        self.otherPokemonsTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.otherPokemonScrollIndex, inSection: 0), atScrollPosition: .Top, animated: true)
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


extension TodayViewController: UITableViewDataSource {
    
    func getOtherPokemons() -> [Pokemon] {
        guard let lastPokemon = self.lastPokemon() else {
            return []
        }
        return Array(self.account.getInventory().pokemons)
            .filter({ (pokemon: Pokemon) -> Bool in
                return pokemon.num == lastPokemon.num
            })
            .sort({ (p1: Pokemon, p2: Pokemon) -> Bool in
                return p1.IVRatio > p2.IVRatio
            })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getOtherPokemons().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("otherPokemonCellIdentifer", forIndexPath: indexPath)
        let pokemon = self.getOtherPokemons()[indexPath.row]
        let ivPercentText = "IV \(String(format: "%.1f%%", pokemon.IVRatio * 100))"
        let ivDetailsText = "(\(String(format: "%.0f%", pokemon.attack))/\(String(format: "%.0f%", pokemon.defence))/\(String(format: "%.0f%", pokemon.stamina)))"
        let cpText = "CP \(String(format: "%.0f%", pokemon.cp))"
        cell.textLabel!.text = "\(ivPercentText) \(ivDetailsText) - \(cpText)"
        cell.selectionStyle = .None
        if pokemon.id == self.lastPokemon()?.id ?? -1 {
            cell.backgroundColor = UIColor(red: 0.506, green: 0.506, blue: 0.506, alpha: 1.00)
        } else {
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let otherPokemons = self.getOtherPokemons()
        if otherPokemons.isEmpty {
            return ""
        }
        let firstPokemon = otherPokemons.first!
        return "\(NUM_TO_NAME[firstPokemon.num] ?? "Unknown") (\(otherPokemons.count))"
    }
    
}
