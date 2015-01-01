//
//  HummingbirdAPITest.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/24/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import Foundation
import CoreData

public class HummingbirdAPI {
    class func requestAnime(anime: NSString, callback: (NSDictionary?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://hummingbird.me/api/v1/anime/"+anime)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) {response, maybeData, error in
            if error != nil {
                callback(nil)
                return
            }
            if let data = maybeData {
                let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                callback(jsonResult)
            } else {
                println(error.localizedDescription)
                callback(nil)
                return
            }
        }
    }
    
    class func searchAnime(search: NSString, callback: (NSArray?) -> Void) {
        var url: NSURL! = NSURL(string: "http://hummingbird.me/api/v1/search/anime?query=" + search)
        var request = NSMutableURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) {response, maybeData, error in
            if error != nil {
                callback(nil)
                return
            }
            if let data = maybeData {
                let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                var parseError: NSError?
                
                let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                var dataArray: [NSDictionary] = []
                
                if let finalData:NSArray = parsedObject! as? NSArray{
                    callback(finalData)
                } else {
                    println("Error parsing the array!")
                }
            } else {
                println(error.localizedDescription)
            }
        }
    }
    
    class func getLibrary(user: NSString, callback: (NSArray?) -> Void) {
        var url: NSURL! = NSURL(string: "http://hummingbird.me/api/v1/users/" + user + "/library")
        var request = NSMutableURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) {response, maybeData, error in
            if error != nil {
                callback(nil)
                return
            }
            
            if let data = maybeData {
                let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                var parseError:NSError?
                
                let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                if let finalData:NSArray? = parsedObject as NSArray? {
                    callback(finalData)
                } else {
                    println("Error parsing the array!")
                    callback(nil)
                }
            }
        }
    }
    
    class func getActivityFeed(username: NSString, callback: (NSArray?) -> Void) {
        var url: NSURL! = NSURL(string: "http://hummingbird.me/api/v1/users/" + username + "/feed")
        var request = NSMutableURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) {response, maybeData, error in
            if error != nil {
                callback(nil)
                return
            }
            
            if let data = maybeData {
                let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                var parseError:NSError?
                
                let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                if let finalData:NSArray? = parsedObject as NSArray? {
                    callback(finalData)
                } else {
                    println("Error parsing the array!")
                    callback(nil)
                }
            }
        }
    }
    
    class func getAccountInfo(username: NSString, callback: (NSDictionary?) -> Void) {
        var url:NSURL! = NSURL(string: "http://hummingbird.me/api/v1/users/" + username)
        var request = NSMutableURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) {response, maybeData, error in
            if error != nil {
                println(error)
                callback(nil)
                return
            }
            
            if let data = maybeData {
                let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                callback(jsonResult)
                return
            } else {
                println(error.localizedDescription)
                callback(nil)
                return
            }
        }
    }
    
    class func authenticate(_username: NSString?, _email: NSString?, password: NSString, callback: (NSString?) -> Void) {
        var postString: NSString
        var url: NSURL! = NSURL(string: "http://hummingbird.me/api/v1/users/authenticate")
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        if let username = _username as NSString! {
            postString = "username=" + username + "&password=" + password
        } else if let email = _email as NSString! {
            postString = "email=" + email + "&password=" + password
        } else {
            println("Error!")
            return
        }
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) {response, maybeData, error in
            if error != nil {
                println(error.localizedDescription)
                callback(nil)
                return
            }
            if let data = maybeData {
                let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                callback(contents)
            }
        }
    }
    
    class func removeFromLibrary(animeid: Int, auth_token: String, callback:(Bool) -> Void) {
        var postString = "auth_token=" + auth_token
        var url: NSURL! = NSURL(string: "http://hummingbird.me/api/v1/libraries/" + String(animeid) + "/remove")
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) {response, maybeData, error in
            if error != nil {
                callback(false)
            } else {
                var res: NSHTTPURLResponse = response as NSHTTPURLResponse
                callback(true)
            }
        }
    }
}
