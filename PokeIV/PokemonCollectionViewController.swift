//
//  PokemonCollectionViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi
import PopupDialog
import Presentr

class PokemonCollectionViewController: UIViewController {

    private let BAR_SORT_BUTTON_TAG = 10
    
    var account: Account!
    
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    private var _dataSource: PokemonCollectionDataSource!
    private var _viewGestureRecognizer: UITapGestureRecognizer!
    private var refreshControl: UIRefreshControl!
    
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
        
        // Refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(PokemonCollectionViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refreshControl)
        
        // Inventory fetching
        self._dataSource.inventory = self.account.getInventory()
        self.fetchInventory(nil)
        
        self.initFilterTextField()
        self.initGestureRecognizer()
    }
    
    func refresh(sender:AnyObject) {
        self.fetchInventory { 
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onTapSort(sender: AnyObject) {
        if sender.tag == BAR_SORT_BUTTON_TAG {
            let sortingMethods = [
                (title: "Date", mode: PokemonCollectionDataSourceMode.Date),
                (title: "IV", mode: PokemonCollectionDataSourceMode.IV),
                (title: "CP", mode: PokemonCollectionDataSourceMode.CP),
                (title: "Num (then IV)", mode: PokemonCollectionDataSourceMode.NumThenIV),
                (title: "Num (then CP)", mode: PokemonCollectionDataSourceMode.NumThenCP),
                (title: "Num (then Date)", mode: PokemonCollectionDataSourceMode.NumThenDate),
                (title: "Candy", mode: PokemonCollectionDataSourceMode.Candy),
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
    
    private func fetchInventory(callback: (() -> Void)?) {
        self.account.refreshInventory {
            self._dataSource.inventory = self.account.getInventory()
            callback?()
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
