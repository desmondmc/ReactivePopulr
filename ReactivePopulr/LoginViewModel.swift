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
    
    let disposeBag = DisposeBag()
    
    // Is signing process in progress
    let signedIn: Observable<String>
    
    // Is signing process in progress
    let signingIn: Observable<Bool>
    
    init(
        username: Observable<String>,
        password: Observable<String>,
        submitTaps: Observable<Void>,
        segmentControl: Observable<Int>
    ) {
        self.validatedUsername = username
            .map { LoginViewModel.isUsernameValid($0) }
        
        self.validatedPassword = password
            .map { LoginViewModel.isPasswordValid($0) }
        
        submitEnabled = Observable.combineLatest(validatedUsername, validatedPassword) { $0 && $1 }
        
        let usernamePasswordAndSegment = Observable.combineLatest(username, password, segmentControl) { ($0, $1, $2) }
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asObservable()
        
        self.signedIn = submitTaps.withLatestFrom(usernamePasswordAndSegment)
            .flatMapLatest { username, password, segment -> Observable<String> in
                if segment == 0 {
                    return API.login(username, password: password)
                            .trackActivity(signingIn)
                }
                return API.signup(username, password: password)
                        .trackActivity(signingIn)
            }
    }
    
    class func isUsernameValid(text: String) -> Bool {
        return text.characters.count > 5
    }
    
    class func isPasswordValid(text: String) -> Bool {
        return text.characters.count > 2
    }
}