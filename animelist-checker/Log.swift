//
//  Log.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/29/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import Foundation

protocol Log {
    func reverse(callback: (Bool) -> Void)
    func apply(callback: (Bool) -> Void)
}

public enum FIELD: String {
    case auth_token = "auth_token"
    case status = "status"
    case privacy = "privacy"
    case rating = "rating"
    case sane_rating_update = "sane_rating_update"
    case rewatching = "rewatching"
    case rewatched_times = "rewatched_times"
    case notes = "notes"
    case episodes_watched = "episodes_watched"
    case increment_episodes = "increment_episodes"
}

public class RemoveAnimeLog : Log {
    var libraryItem: LibraryItem
    
    init(libraryItem: LibraryItem) {
        self.libraryItem = libraryItem
    }
    
    func reverse(callback: (Bool) -> Void) {
        var maybe_auth_token = AuthenticationToken.getAuthToken()
        if let auth_token:String = maybe_auth_token {
            HummingbirdAPI.updateFromLibrary(self.libraryItem.updateParams(), auth_token: auth_token, callback: callback);
        } else {
            callback(false)
            return
        }
    }
    
    func apply(callback: (Bool) -> Void) {
        var maybe_auth_token = AuthenticationToken.getAuthToken()
        if let auth_token:String = maybe_auth_token {
            HummingbirdAPI.removeFromLibrary(self.libraryItem.anime.id, auth_token: auth_token, callback: callback)
        } else {
            callback(false)
            return
        }
    }
}

public class UpdateAnimeLog : Log {
    var libraryItem: LibraryItem
    var updateParams: NSDictionary
    init(libraryItem: LibraryItem, updateParams: NSDictionary) {
        self.libraryItem = libraryItem
        self.updateParams = updateParams
    }
    
    func reverse(callback: (Bool) -> Void) {
        var maybe_auth_token = AuthenticationToken.getAuthToken()
        if let auth_token:String = maybe_auth_token {
            HummingbirdAPI.updateFromLibrary(self.libraryItem.updateParams(), auth_token: auth_token, callback: callback)
        } else {
            callback(false)
            return
        }
    }
    
    func apply(callback: (Bool) -> Void) {
        var maybe_auth_token = AuthenticationToken.getAuthToken()
        if let auth_token:String = maybe_auth_token {
            HummingbirdAPI.updateFromLibrary(self.updateParams, auth_token: auth_token, callback: callback)
        } else {
            callback(false)
            return
        }
    }
}