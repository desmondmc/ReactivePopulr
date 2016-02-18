//
//  API.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-17.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation
import RxSwift

class API {
    class func login(username: String, password: String) -> Observable<AnyObject> {
        let signupDictionary =  ["data":[
                                    "username":username,
                                    "password":password]]
        
        let request = API.setupPostRequestWithBodyDictionary("http://populr_go_api.gzelle.co/login", dictionary: signupDictionary)
        
        return API.getURLSessionObservableWithRequest(request)
    }
    
    class func signup(username: String, password: String) -> Observable<AnyObject> {
        let signupDictionary =  ["data":[
                                    "username":username,
                                    "password":password]]
        
        let request = API.setupPostRequestWithBodyDictionary("http://populr_go_api.gzelle.co/signup", dictionary: signupDictionary)
        
        return API.getURLSessionObservableWithRequest(request)
    }
}

private extension API {
    class func getURLSessionObservableWithRequest(request: NSURLRequest) -> Observable<AnyObject> {
        let URLSession = NSURLSession.sharedSession()
        return URLSession.rx_response(request)
            .map { (maybeData, response) in
                
                do {
                    let jsonResults = try NSJSONSerialization.JSONObjectWithData(maybeData, options: [])
                    return jsonResults
                } catch {
                    print("Fetch failed: \((error as NSError).localizedDescription)")
                }
                
                return ["error": "could not parse response."]
            }
            .catchErrorJustReturn(["error": "could not parse response."])
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