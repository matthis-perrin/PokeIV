//
//  AuthenticationViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/15/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi
import MBProgressHUD

let CELL_IDENTIFIER = "googleAccountCell"

class AuthenticationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeToggle: UISwitch!
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
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let remember = rememberMeToggle.enabled
        self.authenticate(username, password: password, remember: remember)
    }
    
    private func authenticate(username: String, password: String, remember: Bool) {
        let topView = UIApplication.sharedApplication().windows.first?.rootViewController?.view
        let hud = MBProgressHUD.showHUDAddedTo(topView ?? self.view, animated: true)
        hud.mode = .Indeterminate
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.3)
        hud.label.text = "Connecting Google Account"
        
        let hideHUDWithMessage = { (message: String) in
            hud.mode = .Text
            hud.label.text = message
            hud.hideAnimated(true, afterDelay: 2.0)
        }
        
        let googleCallback = { (success: Bool, auth: PGoAuth?) in
            if success {
                hud.label.text = "Connecting to Pokemon Go"
            } else {
                hideHUDWithMessage("Invalid Credentials")
            }
        }
        let pokemonGoCallback = { (success: Bool, auth: PGoAuth?) in
            if let auth = auth {
                let api = GoAPI(auth: auth)
                if remember {
                    GoogleAccountService.addAccount(username, password: password)
                    self.rememberedAccountTableView.reloadData()
                }
                hud.label.text = "Fetching Pokemons"
                api.getInventory { (success, pokemons) in
                    if let pokemons = pokemons {
                        hud.hideAnimated(false)
                        let controllerId = "PokemonCollectionViewControllerId"
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let controller = storyboard.instantiateViewControllerWithIdentifier(controllerId) as? PokemonCollectionViewController {
                            controller.pokemons = pokemons
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    } else {
                        hideHUDWithMessage("Error")
                    }
                }
            } else {
                hideHUDWithMessage("Error")
            }
        }
        let authService = AuthenticationService()
        authService.logIn(username, password: password, googleCallback: googleCallback, pokemonGoCallback: pokemonGoCallback)
    }

    // MARK: - Table View Delegate and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoogleAccountService.getAccounts().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let accounts = GoogleAccountService.getAccounts()
        let username = accounts[indexPath.row].username
        var cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CELL_IDENTIFIER)
        }
        cell.textLabel?.text = username
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accounts = GoogleAccountService.getAccounts()
        let account = accounts[indexPath.row]
        print(account.username, account.password)
        self.authenticate(account.username, password: account.password, remember: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let accounts = GoogleAccountService.getAccounts()
            let account = accounts[indexPath.row]
            GoogleAccountService.removeAccount(account.username)
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
        let uiViews = [
            self.usernameTextField,
            self.passwordTextField,
            self.rememberMeToggle,
            self.logInButton,
            self.rememberedAccountTableView
        ]
        for view in uiViews {
            if (touch.view?.isDescendantOfView(view) ?? false) {
                return false
            }
        }
        self.view.endEditing(true)
        return true
    }
    
}
