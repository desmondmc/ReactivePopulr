//
//  LoginViewModel.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-15.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation
import RxSwift


class LoginViewModel {
    
    // Is submit button enabled
    let submitEnabled: Observable<Bool>
    
    let validatedUsername: Observable<Bool>
    let validatedPassword: Observable<Bool>
    
    let submitTaps: Observable<Void>
    
    let disposeBag: DisposeBag
    
    init(
        username: Observable<String>,
        password: Observable<String>,
        submitTaps: Observable<Void>,
        segmentControl: Observable<Int>,
        disposeBag: DisposeBag
    ) {
        self.disposeBag = disposeBag
        
        self.validatedUsername = username
            .map { LoginViewModel.isUsernameValid($0) }
        
        self.validatedPassword = password
            .map { LoginViewModel.isPasswordValid($0) }
        
        submitEnabled = Observable.combineLatest(validatedUsername, validatedPassword) { $0 && $1 }
        
        let usernamePasswordAndSegment = Observable.combineLatest(username, password, segmentControl) { ($0, $1, $2) }
        
        self.submitTaps = submitTaps
        
        self.submitTaps.withLatestFrom(usernamePasswordAndSegment)
            .flatMapLatest { username, password, segment -> Observable<AnyObject> in
                if segment == 0 {
                    // Do nothing!
                }
                
                return API.login(username, password: password)
            }.subscribeNext() { result in
                print("Something happened! Here's the result: \(result)")
            }.addDisposableTo(self.disposeBag)
    }
    
    class func isUsernameValid(text: String) -> Bool {
        return text.characters.count > 5
    }
    
    class func isPasswordValid(text: String) -> Bool {
        return text.characters.count > 2
    }
}