//
//  Log.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/29/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

//import Foundation
//
//protocol Log {
//    func reverse(callback: (NSError) -> Void)
//    func apply(callback: (NSError) -> Void)
//}
//
//public enum FIELD: String {
//    case auth_token = "auth_token"
//    case status = "status"
//    case privacy = "privacy"
//    case rating = "rating"
//    case sane_rating_update = "sane_rating_update"
//    case rewatching = "rewatching"
//    case rewatched_times = "rewatched_times"
//    case notes = "notes"
//    case episodes_watched = "episodes_watched"
//    case increment_episodes = "increment_episodes"
//}
//
//public class FieldPair {
//    public let field: FIELD
//    public let value: AnyObject?
//    init(field: FIELD, value: AnyObject?) {
//        self.field = field
//        self.value = value
//    }
//}
//
//public class AnimeLog : Log {
//    private var animeId: Int
//    private var editing: Bool
//    private var fields: NSMutableSet
//    
//    init(animeId: Int, editing: Bool) {
//        self.animeId = animeId
//        self.editing = editing
//        fields = NSMutableSet()
//    }
//    
//    /// Adds a new field to value pairing
//    /// :param: field_type the field of a new parameter to add
//    /// :param: value the value of the parameter to either change or add
//    func addField(field_type: FIELD, value: AnyObject) {
//        fields.addObject(FieldPair(field: field_type, value: value))
//    }
//    
//    /// Reverses the logged action to both local and remote
//    /// :param: callback function to run after reverse() finishes
//    func reverse(callback: (NSError) -> Void) {
//        // call api to remove an anime
//    }
//    
//    /// Applies the logged action to both local and remote
//    /// :param: callback function to run after apply() finishes
//    func apply(callback: (NSError) -> Void) {
//        // call api to add an anime
//        var arr = fields.allObjects as? [FieldPair]
//        
//        var postData = ""
//        var first = false
//        
//        // build post data by looping through fields
//        for pair in arr! {
//            if first {
//                first = false
//            } else {
//                postData += "&"
//            }
//            postData += pair.field.rawValue + "=" + String(pair.value)
//        }
//        println(postData)
//    }
//}