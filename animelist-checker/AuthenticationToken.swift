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
    /// Authenticates user and stores the authentication token and username in core data
    /// :param: callback the callback that runs after the code executes
    class func setAuthToken(username: String, password: String, callback: (String?) -> Void) {
        HummingbirdAPI.authenticate(username, _email: nil, password: password) {maybe_auth_token in
            if let auth_token: String = maybe_auth_token as? String {
                let data_token: NSData = auth_token.dataUsingEncoding(NSUTF8StringEncoding)!
                let data_username: NSData = username.dataUsingEncoding(NSUTF8StringEncoding)!
                let result = Keychain.save("auth_token", data: data_token)
                let result2 = Keychain.save("username", data: data_username)
                
                if result == true && result2 == true {
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
    
    class func removeAuthToken() -> Bool {
        return Keychain.delete("auth_token") && Keychain.delete("username")
    }
    
    /// gets username from keychain
    /// :return: the username or nil if there is none
    class func getUsername() -> String? {
        var maybeData_token: NSData? = Keychain.load("auth_token")
        var maybeData_username: NSData? = Keychain.load("username")
        if let data_username: NSData = maybeData_username {
            if maybeData_token != nil {
                if let username:String = NSString(data: data_username, encoding: NSUTF8StringEncoding)  as? String {
                    return username
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// Takes authentication token from keychain
    /// :returns: the authentication token or nil if there is none
    class func getAuthToken() -> String? {
        // if there is a token and a username, then return the token otherwise return an error
        var maybeData_token: NSData? = Keychain.load("auth_token")
        var maybeData_username: NSData? = Keychain.load("username")
        if let data: NSData = maybeData_token {
            if maybeData_username != nil {
                if let auth_token:String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                    return auth_token
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}