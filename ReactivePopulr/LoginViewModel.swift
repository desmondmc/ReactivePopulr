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
    
    let validatedUsername: Observable<Bool>
    let validatedPassword: Observable<Bool>
    
    // Is submit button enabled
    let submitEnabled: Observable<Bool>
    
    let disposeBag = DisposeBag()
    
    init(
        username: Observable<String>,
        password: Observable<String>,
        submitTaps: Observable<Void>,
        segmentControl: Observable<Int>
    ) {
        validatedUsername = username
            .map { LoginViewModel.isUsernameValid($0) }
        
        validatedPassword = password
            .map { LoginViewModel.isPasswordValid($0) }
        
        submitEnabled = Observable.combineLatest(validatedUsername, validatedPassword) { $0 && $1 }
        
        let usernamePasswordAndSegment = Observable.combineLatest(username, password, segmentControl) { ($0, $1, $2) }
        
        submitTaps.withLatestFrom(usernamePasswordAndSegment).subscribeNext { username, password, segment in
            switch segment {
            case 0:
                print("login")
            default:
                print("register")
            }
            print("with username: \(username) and password: \(password)")
        }.addDisposableTo(disposeBag)
        
    }
    
    class func isUsernameValid(text: String) -> Bool {
        return text.characters.count > 5
    }
    
    class func isPasswordValid(text: String) -> Bool {
        return text.characters.count > 5
    }
}