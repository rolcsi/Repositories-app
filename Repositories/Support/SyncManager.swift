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

    var dataStack: DataStack!
    
    init(dataStack: DataStack) {
        super.init()
        
        self.dataStack = dataStack
    }
    
    public func checkForRepos() {
        
        let optionalUrl = URL(string: Constants.applesReposUrl)
        
        guard let url = optionalUrl else { return }
        
        let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
        request.responseJSON { (response) in
            
            if case .success(let json) = response.result {
                
                guard let dict = json as? [[String : Any]] else { return }
                
                self.dataStack.performInNewBackgroundContext { context in
                    
                    context.sync(dict, inEntityNamed: "CDRepo", completion: { (error) in
                        
                        print("sync done")
                        guard let _ = error else { return }
                        
                        // TODO: handle error
                        print("sync error")
                    })
                }
            }
        }
    }
}
