//
//  POUser.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-21.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation
import RealmSwift

class POUser: Object {
    dynamic var id = 0
    dynamic var username = ""
    dynamic var isFriend = false
    
    // Optionals
    dynamic var phoneNumber: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func updateAddUsers(users: [POUser]) {
        let realm = try! Realm()
        
        try! realm.write {
            for user in users {
                realm.add(user, update: true)
            }
        }
    }
}

