//
//  SearchManager.swift
//  Repositories
//
//  Created by Roland Beke on 15/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import Alamofire

class SearchManager: NSObject {

    public static func serchOrgs(with string: String?, closure: @escaping ([User]) -> ()) {
        
        let optionalUrl = Constants.searchOrgUrl(for: string)
        
        guard let url = optionalUrl else { return }
        
        let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
        request.responseJSON { (response) in
            
            if case .success(let json) = response.result {
                
                guard let dict = json as? [String : Any], let items = dict["items"] as? [[String : Any]] else { return }
                closure(self.parseUsers(items: items))
            }
        }
        
    }
    
    // MARK: Private methods
    
    private static func parseUsers(items: [[String : Any]]) -> [User] {
        
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
