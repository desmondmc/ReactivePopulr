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
    class func login(username: String, password: String) -> Observable<String> {
        let signupDictionary =  ["data":[
                                    "username":username,
                                    "password":password]]
        
        let request = API.setupPostRequestWithBodyDictionary("http://populr_go_api.gzelle.co/login", dictionary: signupDictionary)
        
        return API.getURLSessionOnboardingObservableWithRequest(request)
    }
    
    class func signup(username: String, password: String) -> Observable<String> {
        let signupDictionary =  ["data":[
                                    "username":username,
                                    "password":password]]
        
        let request = API.setupPostRequestWithBodyDictionary("http://populr_go_api.gzelle.co/signup", dictionary: signupDictionary)
        
        return API.getURLSessionOnboardingObservableWithRequest(request)
    }
}

private extension API {
    
    class func getURLSessionOnboardingObservableWithRequest(request: NSURLRequest) -> Observable<String> {
        let URLSession = NSURLSession.sharedSession()
        return URLSession.rx_response(request)
            .map { (data, response) in
                let httpResponse = response as NSHTTPURLResponse
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                    return getErrorMessageFromResponseData(data)
                }
                
                return ""
               
            }
            .catchErrorJustReturn("Unknown error")
    }
    
    class func getErrorMessageFromResponseData(data: NSData) -> String {
        let json = JSON(data: data)
        if let errorString = json["errors"][0]["detail"].string {
            return errorString
        }
        return ""
    }
    
    class func setupPostRequestWithBodyDictionary(url: String, dictionary: [String:AnyObject]) -> NSURLRequest {
        let URL = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}