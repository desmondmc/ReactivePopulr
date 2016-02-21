//
//  API.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-17.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class API {
    
    //MARK: Onboarding
    
    // Returns a UserModel and an error string.
    class func login(username: String, password: String) -> Observable<(UserModel?, String?)> {
        let signupDictionary =  ["data":[
                                    "username":username,
                                    "password":password]]
        
        let request = API.setupPostRequestWithBodyDictionary("http://populr_go_api.gzelle.co/login", dictionary: signupDictionary)
        
        return API.getURLSessionOnboardingObservableWithRequest(request)
    }
    
    class func signup(username: String, password: String) -> Observable<(UserModel?, String?)> {
        let signupDictionary =  ["data":[
                                    "username":username,
                                    "password":password]]
        
        let request = API.setupPostRequestWithBodyDictionary("http://populr_go_api.gzelle.co/signup", dictionary: signupDictionary)
        
        return API.getURLSessionOnboardingObservableWithRequest(request)
    }
    
    //MARK: Friends
    
    class func getFriends() -> Observable<[POUser]> {
        let request = API.setupGetRequestForURL("http://populr_go_api.gzelle.co/friends")
        
        return API.getURLSessionObservableForArrayOfUsers(request)
    }
}

private extension API {
    
    class func getURLSessionObservableForArrayOfUsers(request: NSURLRequest) -> Observable<[POUser]> {
        
        let URLSession = NSURLSession.sharedSession()
        
        return URLSession.rx_response(request)
                .map {data, response in
                    let httpResponse = response as NSHTTPURLResponse
                    
                    let json = JSON(data: data)
                    
                    if let errorString = checkResponseForError(json, response: httpResponse) {
                        print(errorString)
                    }
                    
                    var friendsArray = [POUser]()
                    
                    for (_, subJson):(String, JSON) in json["data"] {
                        let maybeNewUser = POUser()
                        maybeNewUser.id = subJson["id"].intValue
                        maybeNewUser.username = subJson["username"].stringValue
                        maybeNewUser.isFriend = subJson["friends"].boolValue
                        
                        friendsArray.append(maybeNewUser)
                    }
                    
                    return friendsArray
                }
    }
    
    class func getURLSessionOnboardingObservableWithRequest(request: NSURLRequest) -> Observable<(UserModel?, String?)> {
        let URLSession = NSURLSession.sharedSession()
        return URLSession.rx_response(request)
            .map { (data, response) in
                let httpResponse = response as NSHTTPURLResponse
                
                let json = JSON(data: data)
                var usermodel = UserModel()
                
                if let errorString = checkResponseForError(json, response: httpResponse) {
                    return (nil, errorString)
                }
                
                guard let objectID = json["data"]["id"].int else {
                    return (nil, "Something went wrong. Try again?")
                }
                
                guard let username = json["data"]["username"].string else {
                    return (nil, "Something went wrong. Try again?")
                }
                
                guard let authToken = json["data"]["new_token"].string else {
                    return (nil, "Something went wrong. Try again?")
                }
                
                usermodel.objectID = objectID
                usermodel.username = username
                usermodel.authToken = authToken
                usermodel.phoneNumber = json["data"]["phone_number"].string
               
                return (usermodel, nil)
            }
            .catchErrorJustReturn((nil, "Something went wrong. Try again?"))
    }
    
    //MARK: Network Helpers
    
    class func checkResponseForError(json: JSON, response: NSHTTPURLResponse) -> String? {
        if let errorString = json["errors"][0]["detail"].string {
            return errorString
        }
        
        if response.statusCode < 200 || response.statusCode > 299 {
            return "Something went wrong. Try again?"
        }
        
        // No error found.
        return nil
    }
    
    class func setupPostRequestWithBodyDictionary(url: String, dictionary: [String:AnyObject]) -> NSURLRequest {
        let URL = NSURL(string: url)!
        var request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
        
        setDefaultHeadersForRequest(&request)
        
        return request
    }
    
    class func setupGetRequestForURL(url: String) -> NSURLRequest {
        let URL = NSURL(string: url)!
        var request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "GET"
        setDefaultHeadersForRequest(&request)
        
        return request
    }
    
    class func setDefaultHeadersForRequest(inout request: NSMutableURLRequest) {
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
        
        if let authToken = CurrentUserModel.authToken() {
            request.setValue(authToken, forHTTPHeaderField: "new-token")
        }
        
        if let objectID = CurrentUserModel.objectID() {
            request.setValue("\(objectID)", forHTTPHeaderField: "x-key")
        }
    }
}