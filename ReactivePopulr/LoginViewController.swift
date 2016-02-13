//
//  ViewController.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 12/02/16.
//  Copyright © 2016 Populr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sublitButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isValidUsername = usernameTextField.rx_text
            .map { self.isUsername($0)}
        let isValidPassword = passwordTextField.rx_text
            .map { self.isPassword($0)}
        
        Observable.combineLatest(isValidUsername, isValidPassword) { $0 && $1 }
            .bindTo(sublitButton.rx_enabled)
            .addDisposableTo(disposeBag)
            
    }
    
    func isUsername(text: String) -> Bool {
        return text.characters.count > 5
    }
    
    func isPassword(text: String) -> Bool {
        return text.characters.count > 5
    }
}

