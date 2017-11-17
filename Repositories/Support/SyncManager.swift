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
import ReactiveSwift
import Result

class SyncManager: NSObject {

    var dataStack: DataStack?

    init(dataStack: DataStack) {
        super.init()

        self.dataStack = dataStack
    }

    func createSyncSignal(user: User) -> SignalProducer<(), NSError> {
        
        return SignalProducer<(), NSError> { observer, _ in
            
            let optionalUrl = URL(string: user.repos)
            
            guard let url = optionalUrl else { return }
            
            debugPrint("CreateSyncSP is main thread? \(Thread.current.isMainThread)")
            
            let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            request.responseJSON(queue: queue, completionHandler: { (response) in
                
                guard case .success(let json) = response.result else { return }
                
                guard let dict = json as? [[String: Any]] else { return }
                
                self.dataStack?.performInNewBackgroundContext { context in
                    
                    context.sync(dict, inEntityNamed: "CDRepo", predicate: NSPredicate(format: "owner.id = %@", user.id), parent: nil, completion: { (error) in
                        
                        guard let _ = error else {
                            
                            observer.sendCompleted()
                            return
                        }
                        
                        observer.send(error: NSError())
                    })
                }
            })
        }
    }
}
