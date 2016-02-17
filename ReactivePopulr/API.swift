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
    class func login(username: String, password: String) -> Observable<Bool> {
        let URLSession = NSURLSession.sharedSession()
        
        let signupDictionary =  ["data":[
                                    "username":username,
                                    "password":password]]
        
        let request = API.setupPostRequestWithBodyDictionary("http://populr_go_api.gzelle.co/login", dictionary: signupDictionary)
        
        return URLSession.rx_response(request)
            .map { (maybeData, response) in
                return (response.statusCode >= 200 && response.statusCode <= 299)
            }
            .catchErrorJustReturn(false)
    }
}

private extension API {
    class func setupPostRequestWithBodyDictionary(url: String, dictionary: [String:AnyObject]) -> NSURLRequest {
        let URL = NSURL(string: "http://populr_go_api.gzelle.co/signup")!
        let request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}