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
    private var googleCallback: ((success: Bool) -> Void)!
    private var pokemonGoCallback: ((success: Bool) -> Void)!
    
    private static var auths: [String: PGoAuth] = [:]
    
    static func getAuth(username: String) -> PGoAuth? {
        return AuthenticationService.auths[username]
    }
    
    init() {
        self.auth = GPSOAuth()
        self.auth.delegate = self
    }
    
    func logIn(username: String,
               password: String,
               googleCallback: (success: Bool) -> Void,
               pokemonGoCallback: (success: Bool) -> Void) {
        self.googleCallback = googleCallback
        self.pokemonGoCallback = pokemonGoCallback
        self.auth.login(withUsername: username, withPassword: password)
    }
    
    func didReceiveAuth() {
        self.googleCallback(success: true)
        let request = PGoApiRequest()
        request.simulateAppStart()
        request.makeRequest(.Login, auth: self.auth, delegate: self)
    }
    
    func didNotReceiveAuth() {
        self.googleCallback(success: false)
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        if (intent == .Login) {
            self.auth.endpoint = "https://\((response.response as! Pogoprotos.Networking.Envelopes.ResponseEnvelope).apiUrl)/rpc"
            AuthenticationService.auths[self.auth.email] = self.auth
            self.pokemonGoCallback(success: true)
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        self.pokemonGoCallback(success: false)
    }
    
}
