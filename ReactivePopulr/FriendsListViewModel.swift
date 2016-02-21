//
//  FriendsListViewModel.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-21.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class FriendsListViewModel {
    let friends: Observable<RealmSwift.Results<POUser>>
    
    var token: RealmSwift.NotificationToken?
    
    let friendsNetworkCall: Observable<Void>
    
    init(submitTaps: Observable<Void>) {
        self.friends = RxRealm.observableOfUsersTableChanges()
        
        friendsNetworkCall = submitTaps.flatMapLatest {
            API.getFriends()
                .map { friends in
                    POUser.updateAddUsers(friends)
                }
        }
    }
}