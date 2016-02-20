//
//  CurrentUserData.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-20.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation

private let ObjectIDKey = "PopObjectID"
private let AuthTokenKey = "PopGoToken"
private let UsernameKey = "PopUsername"
private let PhoneNumberKey = "PopPhoneNumber"

struct UserModel {
    var objectID: Int?
    var authToken: String?
    var username: String?
    var phoneNumber: String?
    
    // This is used for unsuccessful logins so the UI can print an error message.
    var errorMessage: String?
    
    init(errorMessage: String?) {
        self.errorMessage = errorMessage
    }
}

class CurrentUserModel {
    class func setupWithUserModel(usermodel: UserModel) {
        if let objectID = usermodel.objectID {
            NSUserDefaults.standardUserDefaults().setObject(objectID, forKey: ObjectIDKey)
        }
        
        if let authToken = usermodel.authToken {
            NSUserDefaults.standardUserDefaults().setObject(authToken, forKey: AuthTokenKey)
        }
        
        if let username = usermodel.username {
            NSUserDefaults.standardUserDefaults().setObject(username, forKey: UsernameKey)
        }
        
        if let phoneNumber = usermodel.phoneNumber {
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: PhoneNumberKey)
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func objectID() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(ObjectIDKey) as? String
    }
    
    class func authToken() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(AuthTokenKey) as? String
    }
    
    class func username() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UsernameKey) as? String
    }
    
    class func phoneNumber() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(PhoneNumberKey) as? String
    }
    
    class func setPhoneNumber(phoneNumber: String) {
        NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: PhoneNumberKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
