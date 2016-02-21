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
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: LoginViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = LoginViewModel(
            username: usernameTextField.rx_text.asObservable(),
            password: passwordTextField.rx_text.asObservable(),
            submitTaps: submitButton.rx_tap.asObservable(),
            segmentControl:  segmentControl.rx_value.asObservable()
        )
        
        self.viewModel!.submitEnabled
            .bindTo(submitButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
        self.viewModel!.signingIn
            .bindTo(activityIndicator.rx_animating)
            .addDisposableTo(disposeBag)
        
        self.viewModel!.signedIn
            .subscribeNext { maybeError in
                if let error = maybeError {
                    print("Error: \(error)")
                } else {
                    print("I guess it worked.")
                    self.presentViewController(FriendsListViewController(), animated: true, completion: nil)
                }
            }.addDisposableTo(disposeBag)
    }
}

