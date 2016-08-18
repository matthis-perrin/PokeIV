//
//  AuthenticationService.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/16/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi

class AuthenticationService: PGoAuthDelegate, PGoApiDelegate {

    private let auth: GPSOAuth
    private var googleCallback: ((success: Bool, auth: GPSOAuth?) -> Void)!
    private var pokemonGoCallback: ((success: Bool, auth: GPSOAuth?) -> Void)!
    
    init() {
        self.auth = GPSOAuth()
        self.auth.delegate = self
    }
    
    func logIn(username: String,
               password: String,
               googleCallback: (success: Bool, auth: GPSOAuth?) -> Void,
               pokemonGoCallback: (success: Bool, auth: GPSOAuth?) -> Void) {
        self.googleCallback = googleCallback
        self.pokemonGoCallback = pokemonGoCallback
        self.auth.login(withUsername: username, withPassword: password)
    }
    
    func didReceiveAuth() {
        self.googleCallback(success: true, auth: self.auth)
        let request = PGoApiRequest()
        request.simulateAppStart()
        request.makeRequest(.Login, auth: self.auth, delegate: self)
    }
    
    func didNotReceiveAuth() {
        self.googleCallback(success: false, auth: nil)
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        if (intent == .Login) {
            self.auth.endpoint = "https://\((response.response as! Pogoprotos.Networking.Envelopes.ResponseEnvelope).apiUrl)/rpc"
            self.pokemonGoCallback(success: true, auth: self.auth)
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        self.pokemonGoCallback(success: false, auth: nil)
    }
    
}
