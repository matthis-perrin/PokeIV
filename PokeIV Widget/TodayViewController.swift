//
//  TodayViewController.swift
//  PokeIV Widget
//
//  Created by Matthis Perrin on 8/30/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading...")
        print(Account.getAll())
//        let inventory = InventoryService.getInventory("matthis.perrin@gmail.com")
//        print(inventory)
        print("Loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
