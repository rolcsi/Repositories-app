//
//  User.swift
//  Repositories
//
//  Created by Roland Beke on 15/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import Sync

class User {

    var login: String!
    var avatar: String!
    var repos: String!
    var id: NSNumber!

    init() {

        self.login = ""
        self.avatar = ""
        self.repos = ""
        self.id = 0
    }

    init(id: NSNumber, login: String, avatar: String, repos: String) {

        self.login = login
        self.avatar = avatar
        self.repos = repos
        self.id = id
    }
}

class Repo: User {

    var description: String!
    var starsCount: String!
    var updatedAt: String!

    override init() {
        super.init()

        description = ""
        starsCount = ""
        updatedAt = ""
    }

    init(item: NSManagedObject) {
        super.init()

        login = String.bindNilOrEmpty(item.value(forKey: "fullName"))
        description = String.bindNilOrEmpty(item.value(forKey: "summary"))
        starsCount = String.bindNilOrEmpty(item.value(forKey: "starsCount"))
        updatedAt = String.bindNilOrEmpty(item.value(forKey: "updatedAt"))

        guard let owner = item.value(forKey: "owner") as? CDOwner else { return }
        avatar = owner.avatarUrl
    }
}
