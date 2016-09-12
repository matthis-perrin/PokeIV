//
//  PokemonCollectionViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi
import Presentr

class PokemonCollectionViewController: UIViewController {

    private let BAR_SORT_BUTTON_TAG = 10
    
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    
    private var _dataSource: PokemonCollectionDataSource!
    private var _viewGestureRecognizer: UITapGestureRecognizer!
    private var refreshControl: UIRefreshControl!
    private var account: Account?
    
    private static let nc = NSNotificationCenter.defaultCenter()
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .Alert)
        presenter.transitionType = TransitionType.CrossDissolve
        presenter.presentationType = PresentationType.Popup
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._dataSource = PokemonCollectionDataSource(collectionView: self.collectionView)
        self.collectionView.dataSource = self._dataSource
        self.collectionView.delegate = self
        
        self.initPullToRefresh()
        self.initFilterTextField()
        self.initGestureRecognizer()
        
        if let account = self.account {
            self._dataSource.inventory = account.getInventory()
        }
    }
    
    func setAccount(account: Account) {
        self.updateAccountRefreshObserver(self.account, newAccount: account)
        
        self.account = account
        if let dataSource = self._dataSource {
            dataSource.inventory = account.getInventory()
        }
        
        self.fetchInventory()
    }
    
    @IBAction func onTapSort(sender: AnyObject) {
        if sender.tag == BAR_SORT_BUTTON_TAG {
            let sortingMethods = [
                (title: "Date", mode: PokemonCollectionDataSourceMode.Date),
                (title: "IV", mode: PokemonCollectionDataSourceMode.IV),
                (title: "PC", mode: PokemonCollectionDataSourceMode.CP),
                (title: "Numéro (puis IV)", mode: PokemonCollectionDataSourceMode.NumThenIV),
                (title: "Numéro (puis PC)", mode: PokemonCollectionDataSourceMode.NumThenCP),
                (title: "Numéro (puis Date)", mode: PokemonCollectionDataSourceMode.NumThenDate),
                (title: "Bonbon", mode: PokemonCollectionDataSourceMode.Candy),
            ]
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            for sortingMethod in sortingMethods {
                let sameMode = self._dataSource.mode == sortingMethod.mode
                let style: UIAlertActionStyle = sameMode ? .Cancel : .Default
                let handler: ((UIAlertAction) -> Void)? = sameMode ? nil : { (_) in
                    self._dataSource.mode = sortingMethod.mode
                }
                let alertAction = UIAlertAction(title: sortingMethod.title, style: style, handler: handler)
                alertController.addAction(alertAction)
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func fetchInventory() {
        if let account = self.account {
            if !account.isRefreshing {
                account.refreshInventory {
                    if let dataSource = self._dataSource {
                        dataSource.inventory = account.getInventory()
                    }
                }
            }
        }
    }

}


extension PokemonCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("PokemonDetailsViewController")
        if let controller = viewController as? PokemonDetailsViewController {
            let pokemon = self._dataSource.pokemonAtIndexPath(indexPath)
            controller.pokemon = pokemon
            controller.candyAmount = self._dataSource.inventory.getCandyAmount(pokemon.num)
            customPresentViewController(self.presenter, viewController: controller, animated: true, completion: nil)
        }
    }

}


extension PokemonCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 111, height: 157)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

}


extension PokemonCollectionViewController: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        self._viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self._viewGestureRecognizer.delegate = self
        self.collectionView?.addGestureRecognizer(self._viewGestureRecognizer)
    }
    
    func viewTapped(sender: UITapGestureRecognizer) {
        self.filterTextField.endEditing(true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return !(gestureRecognizer == self._viewGestureRecognizer) || self.filterTextField.isFirstResponder()
    }
    
}


extension PokemonCollectionViewController: UITextFieldDelegate {
    
    func initFilterTextField() {
        self.filterTextField.addTarget(self, action: #selector(PokemonCollectionViewController.filterTextFieldValueChanged(_:)), forControlEvents: .EditingChanged)
        self.filterTextField.delegate = self
    }
    
    func filterTextFieldValueChanged(textField: UITextField) {
        self._dataSource.filterText = self.filterTextField.text ?? ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.filterTextField {
            self.filterTextField.endEditing(true)
            return true
        }
        return false
    }
    
}


extension PokemonCollectionViewController {
    
    func initPullToRefresh() {
        // Refresh control
        self.refreshControl = UIRefreshControl()
        let pullToRefresh = NSLocalizedString("PullToRefresh", comment: "Shown in the refresh control when pulling the collection view to refresh the list of Pokemons")
        self.refreshControl.attributedTitle = NSAttributedString(string: pullToRefresh)
        self.refreshControl.addTarget(self, action: #selector(PokemonCollectionViewController.fetchInventory), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refreshControl)
    }
    
}


extension PokemonCollectionViewController {
    
    func updateAccountRefreshObserver(oldAccount: Account?, newAccount: Account?) {
        // Remove previous observer
        if let account = oldAccount {
            PokemonCollectionViewController.nc.removeObserver(self, name: account.accountRefreshEventName, object: nil)
        }
        // Add new observer
        if let account = newAccount {
            PokemonCollectionViewController.nc.addObserver(self, selector: #selector(accountRefreshStateChanged), name: account.accountRefreshEventName, object: nil)
        }
        // Trigger an update
        self.accountRefreshStateChanged()
    }
    
    @IBAction func onRefreshBarButtonItemTap(sender: AnyObject) {
        self.fetchInventory()
    }
    
    func accountRefreshStateChanged() {
        let isRefreshing = self.account?.isRefreshing ?? false
        if isRefreshing {
            self.refreshBarButtonItem?.enabled = false
            self.refreshControl?.beginRefreshing()
            
        } else {
            self.refreshBarButtonItem?.enabled = true
            self.refreshControl?.endRefreshing()
        }
    }
    
}
