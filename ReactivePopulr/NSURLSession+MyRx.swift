//
//  NSURLSession+MyRx.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-19.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation
import RxSwift



extension NSURLSession {
    
    private func unknownError() -> ErrorType {
        return NSError(domain: "Unknown Error", code: 999, userInfo: nil)
    }
    
    public func rx_requestLifeCycle(request: NSURLRequest) -> RxSwift.Observable<AnyObject> {
        return Observable.create { observer in
            observer.on(.Next(true))
            
            self.dataTaskWithRequest(request) { data, response, error in
                observer.on(.Next(false))
                
                if let _ = error {
                    observer.onError(self.unknownError())
                    return
                }
                
                guard let unwrappedResponse = response as? NSHTTPURLResponse else {
                    observer.onError(self.unknownError())
                    return
                }
                if unwrappedResponse.statusCode < 200 || unwrappedResponse.statusCode > 299 {
                    observer.onError(NSError(
                        domain: "Bad HTTP code: \(unwrappedResponse.statusCode)",
                        code: 999,
                        userInfo: nil)
                    )
                    return
                }
                
                do {
                    let jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    observer.onNext(jsonResults)
                    observer.on(.Completed)
                    return
                } catch {
                    observer.onError(self.unknownError())
                }
                
            }
            
            
            return NopDisposable.instance
        }
    }
}