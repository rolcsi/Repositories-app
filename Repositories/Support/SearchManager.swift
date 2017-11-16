//
//  SearchManager.swift
//  Repositories
//
//  Created by Roland Beke on 15/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveSwift

class SearchManager: NSObject {

    static func createSearchSP(with string: String?) -> SignalProducer<[User], NSError> {
        return SignalProducer<[User], NSError> { observer, _ in

            let optionalUrl = Constants.searchOrgUrl(for: string)

            guard let url = optionalUrl else { return }

            debugPrint("CreateSearchSP is main thread? \(Thread.current.isMainThread)")

            let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)

            request.responseJSON(queue: queue, completionHandler: { (response) in

                if case .success(let json) = response.result {

                    guard let dict = json as? [String: Any], let items = dict["items"] as? [[String: Any]] else { return }

                    observer.send(value: self.parseUsers(items: items))
                } else {

                    observer.send(error: NSError())
                    return
                }

                observer.sendCompleted()
            })
        }
    }

    // MARK: Private methods

    private static func parseUsers(items: [[String: Any]]) -> [User] {

        var array: [User] = []

        for item in items {

            guard let login = item["login"] as? String,
                let avatar = item["avatar_url"] as? String,
                let repos = item["repos_url"] as? String,
                let id = item["id"] as? Int
                else {
                    continue
            }

            let user = User(id: NSNumber(value: id), login: login, avatar: avatar, repos: repos)
            array.append(user)
        }

        return array
    }
}
