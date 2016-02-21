//
//  RxRealm.swift
//  ReactivePopulr
//
//  Created by Desmond McNamee on 2016-02-21.
//  Copyright © 2016 Populr. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class RxRealm {
    class func observableOfUsersTableChanges() -> Observable<(RealmSwift.Results<POUser>)> {
        return Observable.create { observer in
            let realm = try! Realm()
            let token = realm.objects(POUser).addNotificationBlock { results, maybeError in
                if let error = maybeError {
                    observer.on(.Error(error))
                }
                
                observer.on(.Next(results! as RealmSwift.Results<POUser>))
            }
            
            let cancel = AnonymousDisposable {
                token.stop()
            }
            
            return cancel
        }
    }
}