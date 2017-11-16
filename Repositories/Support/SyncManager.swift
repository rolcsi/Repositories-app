//
//  SyncManager.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import Alamofire
import Sync

class SyncManager: NSObject {

    var dataStack: DataStack?
    
    init(dataStack: DataStack) {
        super.init()
        
        self.dataStack = dataStack
    }
    
    public func checkForRepos(user: User) {
        
        let optionalUrl = URL(string: user.repos)
        
        guard let url = optionalUrl else { return }
        
        let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
        request.responseJSON { (response) in
            
            guard case .success(let json) = response.result else { return }
                
            guard let dict = json as? [[String : Any]] else { return }
            
            self.dataStack?.performInNewBackgroundContext { context in
                
                context.sync(dict, inEntityNamed: "CDRepo", predicate: NSPredicate(format: "owner.id = %@", user.id), parent: nil, completion: { (error) in
                    
                    debugPrint("sync done")
                    
                    guard let _ = error else { return }
                    
                    debugPrint("sync error")
                })
            }
        }
    }
}
