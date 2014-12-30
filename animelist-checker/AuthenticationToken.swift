//
//  AuthenticationToken.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/29/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit
import Security

let serviceIdentifier = "MyService"
let userAccount = "authenticatedUser"
let accessGroup = "MyService"


public class AuthenticationToken {
    /// Authenticates user and stores the authentication token in core data
    /// :param: callback the callback that runs after the code executes
    class func setAuthToken(username: String, password: String, callback: (String?) -> Void) {
        HummingbirdAPI.authenticate(username, _email: nil, password: password) {maybe_auth_token in
            if let auth_token: String = maybe_auth_token {
                let data: NSData = auth_token.dataUsingEncoding(NSUTF8StringEncoding)!
                let result = Keychain.save("auth_token", data: data)
                if result == true {
                    callback(auth_token)
                    return
                } else {
                    callback(nil)
                    return
                }
            } else {
                callback(nil)
                return
            }
        }
    }
    
    /// Takes authentication token from core data
    /// :returns: the authentication token or nil if there is none in core data
    class func getAuthToken() -> String? {
        // check core data for auth token
        // if there is a token in core data, return it, otherwise return nil
        var maybeData: NSData? = Keychain.load("auth_token")
        if let data: NSData = maybeData {
            if let auth_token:String = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return auth_token
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}