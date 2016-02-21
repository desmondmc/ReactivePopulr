//
//  FriendsListViewController.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-21.
//  Copyright © 2016 Populr. All rights reserved.
//

import UIKit
import RxSwift

class FriendsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadFriendsButton: UIButton!
    
    var viewModel: FriendsListViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = FriendsListViewModel(
            submitTaps: loadFriendsButton.rx_tap.asObservable()
        )
        
        self.viewModel!.friends
            .subscribeNext { users in
                print(users.count)
            }.addDisposableTo(disposeBag)
        
        self.viewModel!.friendsNetworkCall
            .subscribeNext {
                // Do nothing
            }
    }
}
