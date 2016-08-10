//
//  ViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/9/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi

class ViewController: UIViewController, PGoAuthDelegate, PGoApiDelegate {
    
    var auth: GPSOAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = GPSOAuth()
        auth.delegate = self
        auth.login(withUsername: "matthis.perrin@gmail.com", withPassword: ">hBhFZ]oeJLJWA9em}Q.w]QCRHWNER9aDuo")
    }
    
    func didReceiveAuth() {
        let request = PGoApiRequest()
        request.simulateAppStart()
        request.makeRequest(.Login, auth: auth, delegate: self)
    }
    
    func didNotReceiveAuth() {
        print("Failed to auth!")
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        print("Got that API response: \(intent)")
        print(response.response)
        print(response.subresponses)
        if (intent == .Login) {
            let request = PGoApiRequest()
            request.getPlayer()
            request.makeRequest(.GetPlayer, auth: auth, delegate: self)
//            auth.endpoint = "https://\((response.response as! Pogoprotos.Networking.Envelopes.ResponseEnvelope).apiUrl)/rpc"
//            print("New endpoint: \(auth.endpoint)")
//            let request = PGoApiRequest()
//            
//            //Set the latitude/longitude of player; altitude is optional
//            request.setLocation(37.331686, longitude: -122.030765, altitude: 0)
//            
//            request.getMapObjects()
//            request.makeRequest(.GetMapObjects, auth: auth, delegate: self)
//        } else if (intent == .GetMapObjects) {
//            print("Got map objects!")
//            print(response.response)
//            print(response.subresponses)
//            let r = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetMapObjectsResponse
//            let cell = r.mapCells[0]
//            print(cell.nearbyPokemons)
//            print(cell.wildPokemons)
//            print(cell.catchablePokemons)
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        print("API Error: \(statusCode)")
    }
    
    
}
