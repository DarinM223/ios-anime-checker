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
    let show_type: String
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
        self.alternate_title = dict["title"] as String?
        self.episode_count = dict["episode_count"] as Int?
        self.episode_length = dict["episode_length"] as Int?
        self.cover_image = dict["cover_image"] as String
        self.synopsis = dict["synopsis"] as String
        self.show_type = dict["show_type"] as String
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let started_airing_str = dict["started_airing"] as String?
        let finished_airing_str = dict["finished_airing"] as String?
        if let str:String = started_airing_str {
            self.started_airing = dateFormat.dateFromString(str)
        } else {
            self.started_airing = nil
        }
        
        if let str:String = finished_airing_str {
            self.finished_airing = dateFormat.dateFromString(str)
        } else {
            self.finished_airing = nil
        }
        self.community_rating = dict["community_rating"] as Double
        self.age_rating = dict["age_rating"] as String?
    }
}

public class LibraryItem {
    let anime: Anime
    let episodes_watched: Int
    let last_watched: NSDate
    let updated_at: NSDate
    let rewatched_times: Int
    let notes: String
    
    init(anime: Anime, episodes_watched: Int, last_watched: NSDate, updated_at: NSDate, rewatched_times: Int, notes: String) {
        self.anime = anime
        self.episodes_watched = episodes_watched
        self.last_watched = last_watched
        self.updated_at = updated_at
        self.rewatched_times = rewatched_times
        self.notes = notes
    }
    
    init(dict: NSDictionary) {
        self.anime = Anime(dict: dict["anime"] as NSDictionary)
        self.episodes_watched = dict["episodes_watched"] as Int
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        self.last_watched = dateFormat.dateFromString(dict["last_watched"] as String)!
        self.updated_at = dateFormat.dateFromString(dict["last_watched"] as String)!
        self.rewatched_times = dict["rewatched_times"] as Int
        self.notes = dict["notes"] as String
    }
}

public class Animelist {
    var list: [LibraryItem]
    
    init(username: String, callback: (NSError?) -> Void) {
        self.list = []
        
        // TODO: Attempt to get list through online api
        // if that fails check core data
        // if that fails return error
    }
    
    func getCurrentlyWatching() -> [LibraryItem] {
        return []
    }
    func getPlanToWatch() -> [LibraryItem] {
        return []
    }
    func getCompleted() -> [LibraryItem] {
        return []
    }
    func getOnHold() -> [LibraryItem] {
        return []
    }
    func getDropped() -> [LibraryItem] {
        return []
    }
    
    func removeAnime(callback: (NSError?) -> Void) {
    }
    
    func updateAnime(updateParams: NSDictionary, callback: (NSError?) -> Void) {
    }
}