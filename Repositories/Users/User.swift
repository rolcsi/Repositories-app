//
//  User.swift
//  Repositories
//
//  Created by Roland Beke on 15/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit

struct User {
    
    var login: String!
    var avatar: String!
    var repos: String!
    var id: NSNumber!
    
    init(id: NSNumber, login: String, avatar: String, repos: String) {
        
        self.login = login
        self.avatar = avatar
        self.repos = repos
        self.id = id
    }
}
