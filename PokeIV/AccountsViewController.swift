//
//  AccountsViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/30/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import MBProgressHUD

let CELL_IDENTIFIER = "googleAccountCell"
let CELL_IDENTIFIER_CONNECTED = "ConnectedgoogleAccountCell"

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var rememberedAccountTableView: UITableView!
    @IBOutlet var viewtapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rememberedAccountTableView.delegate = self
        self.rememberedAccountTableView.dataSource = self
        self.rememberedAccountTableView.tableFooterView = UIView(frame: CGRectZero)
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.viewtapGestureRecognizer.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInHandler(sender: AnyObject?) {
        self.view.endEditing(true)
        let username = self.usernameTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        self.authenticate(username, password: password)
    }
    
    private func authenticate(username: String, password: String) {
        let topView = UIApplication.sharedApplication().windows.first?.rootViewController?.view
        let hud = MBProgressHUD.showHUDAddedTo(topView ?? self.view, animated: true)
        hud.mode = .Indeterminate
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.3)
        hud.label.text = NSLocalizedString("AccountsViewController.connecting", comment: "Shown in the HUD while connecting the user account")
        
        let account = Account.create(username, password: password)
        account.logIn { (success) in
            self.rememberedAccountTableView.reloadData()
            if success {
                hud.mode = .Text
                hud.label.text = NSLocalizedString("AccountsViewController.success", comment: "Shown in the HUD after succeeding to connect the user account")
                hud.hideAnimated(true, afterDelay: 0.3)
                self.onLogIn(account)
            } else {
                hud.mode = .Text
                hud.label.text = NSLocalizedString("AccountsViewController.failure", comment: "Shown in the HUD after failing to connect the user account")
                hud.hideAnimated(true, afterDelay: 1.0)
            }
        }
    }
    
    private func onLogIn(account: Account) {
        account.updateLastAccess()
        self.rememberedAccountTableView.reloadData()
        self.resetForm()
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.setAccount(account)
            tabBarController.navigateTo(.Pokemons)
        }
    }
    
    private func resetForm() {
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    // MARK: - Table View Delegate and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Account.getAll().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let accounts = Account.getAll()
        let account = accounts[indexPath.row]
        let isLoggedIn = account.isLoggedIn()
        let identifier = isLoggedIn ? CELL_IDENTIFIER_CONNECTED : CELL_IDENTIFIER
        var cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            cell = dequeuedCell
        } else {
            let style: UITableViewCellStyle = identifier == CELL_IDENTIFIER ? .Default : .Subtitle
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
        }
        cell.textLabel?.text = account.username
        let connectedString = NSLocalizedString("AccountsViewController.connected", comment: "Shown in the `remembered account table view` under the name of the account that are currently connected")
        cell.detailTextLabel?.text = isLoggedIn ? connectedString : nil
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accounts = Account.getAll()
        let account = accounts[indexPath.row]
        if account.isLoggedIn() {
            self.onLogIn(account)
        } else {
            self.authenticate(account.username, password: account.password)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let accounts = Account.getAll()
            let account = accounts[indexPath.row]
            account.delete()
            self.rememberedAccountTableView.reloadData()
        }
    }
    
    
    // MARK: - Textfield delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
            return true
        } else if textField == self.passwordTextField {
            self.logInHandler(nil)
            return true
        }
        return false
    }
    
    
    // MARK - UIView gesture recognizer
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // Let event pass through if the user tapped on the following views
        let uiViews = [
            self.usernameTextField,
            self.passwordTextField,
            self.logInButton
        ]
        for view in uiViews {
            if (touch.view?.isDescendantOfView(view) ?? false) {
                return false
            }
        }
        
        // Check the current editing state before calling `endEditing`
        let usernameFirstResponder = self.usernameTextField.isFirstResponder()
        let passwordFirstResponder = self.passwordTextField.isFirstResponder()
        
        // End editing
        self.view.endEditing(true)
        
        // But still capture the event if the user tapped the table view while editing
        let isTableView = touch.view?.isDescendantOfView(self.rememberedAccountTableView) ?? false
        if isTableView && (usernameFirstResponder || passwordFirstResponder) {
            return true
        }
        
        // Otherwise, let the user pass through
        return false
    }

}
