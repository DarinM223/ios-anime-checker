//
//  Animelist.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 1/8/15.
//  Copyright (c) 2015 com.d_m. All rights reserved.
//

import Foundation

public class Anime {
    let id: Int
    let slug: String
    let status: String
    let url: String
    let title: String
    let alternate_title: String?
    let episode_count: Int?
    let episode_length: Int?
    let cover_image: String
    let synopsis: String
    let show_type: String?
    let started_airing: NSDate?
    let finished_airing: NSDate?
    let community_rating: Double
    let age_rating: String?
    
    init(dict: NSDictionary) {
        self.id = dict["id"] as Int
        self.slug = dict["slug"] as String
        self.status = dict["status"] as String
        self.url = dict["url"] as String
        self.title = dict["title"] as String
        self.alternate_title = dict["title"] as? String
        self.episode_count = dict["episode_count"] as? Int
        self.episode_length = dict["episode_length"] as? Int
        self.cover_image = dict["cover_image"] as String
        self.synopsis = dict["synopsis"] as String
        self.show_type = dict["show_type"] as? String
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let started_airing_str = dict["started_airing"] as? String
        let finished_airing_str = dict["finished_airing"] as? String
        if let str:String = started_airing_str as String! {
            self.started_airing = dateFormat.dateFromString(str)
        } else {
            self.started_airing = nil
        }
        
        if let str:String = finished_airing_str as String! {
            self.finished_airing = dateFormat.dateFromString(str)
        } else {
            self.finished_airing = nil
        }
        self.community_rating = dict["community_rating"] as Double
        self.age_rating = dict["age_rating"] as? String
    }
}

public class LibraryItem {
    let anime: Anime
    let episodes_watched: Int
    let last_watched: NSDate?
    let updated_at: NSDate?
    let rewatched_times: Int
    let notes: String?
    let notes_present: Bool?
    let status: String
    let _private: Bool
    let rewatching: Bool
    
    init(dict: NSDictionary) {
        
        self.anime = Anime(dict: dict["anime"] as NSDictionary)
        self.episodes_watched = dict["episodes_watched"] as Int
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let last_watched_str = dict["last_watched"] as? String
        let updated_at_str = dict["last_watched"] as? String
        
        if let str:String = last_watched_str as String! {
            self.last_watched = dateFormat.dateFromString(str)
        } else {
            self.last_watched = nil
        }
        
        if let str:String = updated_at_str as String! {
            self.updated_at = dateFormat.dateFromString(str)
        } else {
            self.updated_at = nil
        }
        
        self.rewatched_times = dict["rewatched_times"] as Int
        self.notes = dict["notes"] as? String
        self.notes_present = dict["notes_present"] as? Bool
        self.status = dict["status"] as String
        self._private = dict["private"] as Bool
        self.rewatching = dict["rewatching"] as Bool
    }
    
    /// Update parameters for adding a library object that has these properties
    func updateParams() -> NSDictionary {
        var params = NSMutableDictionary()
        params["id"] = self.anime.id
        params["status"] = self.status
        params["privacy"] = self._private
        // params["rating"]
        // params["sane_rating_update"]
        params["rewatching"] = self.rewatching
        params["rewatched_times"] = self.rewatched_times
        params["notes"] = self.notes
        params["episodes_watched"] = self.episodes_watched
        return params
    }
}

public class Animelist {
    var username: String
    var list: [LibraryItem]
    
    func getList(callback: (NSError?) -> Void) {
        HummingbirdAPI.getLibrary(self.username) {result in
            if result == nil {
                // check core data
                // if it fails callback with error
            } else {
                self.list.removeAll(keepCapacity: true)
                let arr: [AnyObject] = result as [AnyObject]
                for item:AnyObject in arr {
                    if let dict:NSDictionary = item as? NSDictionary {
                        self.list.append(LibraryItem(dict: dict))
                    }
                }
                callback(nil)
            }
        }
    }
    
    init(username: String, callback: (NSError?) -> Void) {
        self.username = username
        self.list = []
        
        self.getList(callback)
    }
    
    func getCurrentlyWatching() -> [LibraryItem] {
        return self.list.filter { item in
            return item.status == "currently-watching"
        }
    }
    func getPlanToWatch() -> [LibraryItem] {
        return self.list.filter { item in
            return item.status == "plan-to-watch"
        }
    }
    func getCompleted() -> [LibraryItem] {
        return self.list.filter { item in
            return item.status == "completed"
        }
    }
    func getOnHold() -> [LibraryItem] {
        return self.list.filter { item in
            return item.status == "on-hold"
        }
    }
    func getDropped() -> [LibraryItem] {
        return self.list.filter { item in
            return item.status == "dropped"
        }
    }
}